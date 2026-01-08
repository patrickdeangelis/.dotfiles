package main

import (
	"os"
	"path/filepath"
	"testing"
)

func TestSyncFileOverwrite(t *testing.T) {
	dir := t.TempDir()
	src := filepath.Join(dir, "src.txt")
	dst := filepath.Join(dir, "dst.txt")

	writeFile(t, src, "new")
	writeFile(t, dst, "old")

	binDir := filepath.Join(dir, "bin")
	if err := os.MkdirAll(binDir, 0o755); err != nil {
		t.Fatalf("mkdir bin: %v", err)
	}
	diffPath := filepath.Join(binDir, "diff")
	rsyncPath := filepath.Join(binDir, "rsync")

	makeExecutable(t, diffPath, "#!/bin/sh\necho diff\nexit 1\n")
	makeExecutable(t, rsyncPath, "#!/bin/sh\nset -- \"$@\"\nwhile [ $# -gt 2 ]; do shift; done\ncp -f \"$1\" \"$2\"\n")

	origPath := os.Getenv("PATH")
	t.Setenv("PATH", binDir+string(os.PathListSeparator)+origPath)

	origStdin := os.Stdin
	defer func() { os.Stdin = origStdin }()

	// Use a pipe to provide stdin to promptDecision
	r, w, err := os.Pipe()
	if err != nil {
		t.Fatalf("pipe: %v", err)
	}
	if _, err := w.Write([]byte("o\n")); err != nil {
		t.Fatalf("write pipe: %v", err)
	}
	_ = w.Close()
	os.Stdin = r

	if err := syncFile(src, dst); err != nil {
		t.Fatalf("syncFile error: %v", err)
	}

	got, err := os.ReadFile(dst)
	if err != nil {
		t.Fatalf("read dst: %v", err)
	}
	if string(got) != "new" {
		t.Fatalf("expected overwrite, got %q", string(got))
	}
}
