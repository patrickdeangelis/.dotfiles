package main

import (
	"fmt"
	"os"
)

var packages = []string{
	"neovim",
	"tmux",
	"stow",
	"ripgrep",
	"fd",
	"fzf",
	"git",
	"sketchybar",
}

var stowPackages = []string{
	"nvim",
	"tmux",
}

func runInstall() error {
	fmt.Println("Starting installation...")

	// 1. Ensure Homebrew (macOS)
	if err := ensureBrew(); err != nil {
		return fmt.Errorf("failed to ensure brew: %w", err)
	}

	// 2. Install System Packages
	fmt.Println("Installing system packages...")
	if err := installPackages(packages); err != nil {
		return fmt.Errorf("failed to install packages: %w", err)
	}

	// 3. Stow Dotfiles
	fmt.Println("Stowing dotfiles...")
	if err := stowDotfiles(stowPackages); err != nil {
		return fmt.Errorf("failed to stow dotfiles: %w", err)
	}

	fmt.Println("Installation complete!")
	return nil
}

func installPackages(pkgs []string) error {
	// Filter out already installed packages to save time?
	// Brew handles this gracefully, so we can just run brew install
	args := append([]string{"install"}, pkgs...)
	return runCommand("brew", args...)
}

func stowDotfiles(pkgs []string) error {
	dotfilesDir, err := getDotfilesDir()
	if err != nil {
		return err
	}

	// Change to dotfiles directory
	if err := os.Chdir(dotfilesDir); err != nil {
		return fmt.Errorf("failed to change dir to %s: %w", dotfilesDir, err)
	}

	for _, pkg := range pkgs {
		fmt.Printf("Stowing %s...\n", pkg)
		// Unstow first (clean slate) - ignore error if it wasn't stowed
		_ = runCommand("stow", "-D", pkg)
		
		// Stow
		if err := runCommand("stow", pkg); err != nil {
			return fmt.Errorf("failed to stow %s: %w", pkg, err)
		}
	}
	
	// Try to return to original dir, though not strictly necessary for CLI exit
	return nil
}