package main

import (
	"fmt"
	"os"
	"os/exec"
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
