package main

import (
	"bufio"
	"bytes"
	"crypto/sha256"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

// runCommand executes a shell command and streams output to stdout/stderr
func runCommand(name string, args ...string) error {
	fmt.Printf("Running: %s %s\n", name, strings.Join(args, " "))
	cmd := exec.Command(name, args...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return cmd.Run()
}

// runCommandOutput executes a command and returns stdout.
func runCommandOutput(name string, args ...string) (string, error) {
	cmd := exec.Command(name, args...)
	var out bytes.Buffer
	cmd.Stdout = &out
	cmd.Stderr = os.Stderr
	if err := cmd.Run(); err != nil {
		return "", err
	}
	return out.String(), nil
}

// showDiff runs a unified diff and ignores the exit code for differences.
func showDiff(a, b string) error {
	cmd := exec.Command("diff", "-u", a, b)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	if err := cmd.Run(); err != nil {
		if exitErr, ok := err.(*exec.ExitError); ok && exitErr.ExitCode() == 1 {
			return nil
		}
		return err
	}
	return nil
}

func filesEqual(a, b string) (bool, error) {
	aInfo, err := os.Stat(a)
	if err != nil {
		return false, err
	}
	bInfo, err := os.Stat(b)
	if err != nil {
		return false, err
	}
	if aInfo.Size() != bInfo.Size() {
		return false, nil
	}
	aHash, err := hashFile(a)
	if err != nil {
		return false, err
	}
	bHash, err := hashFile(b)
	if err != nil {
		return false, err
	}
	return bytes.Equal(aHash, bHash), nil
}

func hashFile(path string) ([]byte, error) {
	f, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer f.Close()

	h := sha256.New()
	if _, err := io.Copy(h, f); err != nil {
		return nil, err
	}
	return h.Sum(nil), nil
}

func promptDecision(path string) (string, error) {
	reader := bufio.NewReader(os.Stdin)
	for {
		fmt.Printf("Conflict for %s. (m)erge/(o)verwrite/(s)kip: ", path)
		input, err := reader.ReadString('\n')
		if err != nil {
			return "", err
		}
		switch strings.ToLower(strings.TrimSpace(input)) {
		case "m":
			return "merge", nil
		case "o":
			return "overwrite", nil
		case "s":
			return "skip", nil
		default:
			fmt.Println("Please enter m, o, or s.")
		}
	}
}

func mergeFiles(dstPath, srcPath string) error {
	dstBytes, err := os.ReadFile(dstPath)
	if err != nil {
		return err
	}
	srcBytes, err := os.ReadFile(srcPath)
	if err != nil {
		return err
	}

	tmp, err := os.CreateTemp("", "dotman-merge-*.tmp")
	if err != nil {
		return err
	}
	defer os.Remove(tmp.Name())

	if _, err := fmt.Fprintf(tmp, "<<<<<<< dotfiles\n%s\n=======\n%s\n>>>>>>> home\n", dstBytes, srcBytes); err != nil {
		_ = tmp.Close()
		return err
	}
	if err := tmp.Close(); err != nil {
		return err
	}

	editor := os.Getenv("EDITOR")
	if editor == "" {
		editor = "vi"
	}
	cmd := exec.Command(editor, tmp.Name())
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	if err := cmd.Run(); err != nil {
		return err
	}

	mode := os.FileMode(0o644)
	if info, err := os.Stat(dstPath); err == nil {
		mode = info.Mode()
	} else if info, err := os.Stat(srcPath); err == nil {
		mode = info.Mode()
	}

	merged, err := os.ReadFile(tmp.Name())
	if err != nil {
		return err
	}

	if err := os.MkdirAll(filepath.Dir(dstPath), 0o755); err != nil {
		return err
	}
	return os.WriteFile(dstPath, merged, mode)
}

// checkCommand checks if a command exists in the PATH
func checkCommand(name string) bool {
	_, err := exec.LookPath(name)
	return err == nil
}

// ensureBrew ensures Homebrew is installed (macOS only)
func ensureBrew() error {
	if checkCommand("brew") {
		return nil
	}
	fmt.Println("Homebrew not found. Installing...")
	// This is the standard install script for Homebrew
	cmd := "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
	return runCommand("bash", "-c", cmd)
}

// getDotfilesDir returns the root directory of the dotfiles
func getDotfilesDir() (string, error) {
	// Assuming the CLI is run from within the repo or we can find it relative to HOME
	// For now, let's assume $HOME/.dotfiles or current directory if it contains .git

	// Check env var first
	if envDir := os.Getenv("DOTFILES"); envDir != "" {
		return envDir, nil
	}

	home, err := os.UserHomeDir()
	if err != nil {
		return "", err
	}

	defaultPath := fmt.Sprintf("%s/.dotfiles", home)
	if _, err := os.Stat(defaultPath); err == nil {
		return defaultPath, nil
	}

	// Fallback: use current working directory
	wd, err := os.Getwd()
	if err != nil {
		return "", err
	}
	return wd, nil
}
