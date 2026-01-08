package main

import (
	"os"
	"path/filepath"
	"testing"
)

func writeFile(t *testing.T, path, content string) {
	t.Helper()
	if err := os.WriteFile(path, []byte(content), 0o644); err != nil {
		t.Fatalf("write file: %v", err)
	}
}

func makeExecutable(t *testing.T, path, content string) {
	t.Helper()
	if err := os.WriteFile(path, []byte(content), 0o755); err != nil {
		t.Fatalf("write exe: %v", err)
	}
}

func TestFilesEqual(t *testing.T) {
	dir := t.TempDir()
	a := filepath.Join(dir, "a.txt")
	b := filepath.Join(dir, "b.txt")

	writeFile(t, a, "same")
	writeFile(t, b, "same")

	eq, err := filesEqual(a, b)
	if err != nil {
		t.Fatalf("filesEqual error: %v", err)
	}
	if !eq {
		t.Fatalf("expected files to be equal")
	}
}

func TestFilesNotEqual(t *testing.T) {
	dir := t.TempDir()
	a := filepath.Join(dir, "a.txt")
	b := filepath.Join(dir, "b.txt")

	writeFile(t, a, "one")
	writeFile(t, b, "two")

	eq, err := filesEqual(a, b)
	if err != nil {
		t.Fatalf("filesEqual error: %v", err)
	}
	if eq {
		t.Fatalf("expected files to be different")
	}
}

func TestMergeFilesUsesEditor(t *testing.T) {
	dir := t.TempDir()
	dst := filepath.Join(dir, "dst.txt")
	src := filepath.Join(dir, "src.txt")
	editor := filepath.Join(dir, "fake-editor")

	writeFile(t, dst, "old")
	writeFile(t, src, "new")
	makeExecutable(t, editor, "#!/bin/sh\nexit 0\n")

	t.Setenv("EDITOR", editor)
	if err := mergeFiles(dst, src); err != nil {
		t.Fatalf("mergeFiles error: %v", err)
	}

	merged, err := os.ReadFile(dst)
	if err != nil {
		t.Fatalf("read merged: %v", err)
	}
	if string(merged) == "old" || string(merged) == "new" {
		t.Fatalf("expected merged markers, got plain content")
	}
}
