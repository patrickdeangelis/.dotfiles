package main

import (
	"fmt"
	"os"
)

func runUpdate() error {
	fmt.Println("Updating dotfiles...")

	dotfilesDir, err := getDotfilesDir()
	if err != nil {
		return err
	}

	// 1. Pull changes
	fmt.Printf("Pulling latest changes in %s...\n", dotfilesDir)
	if err := os.Chdir(dotfilesDir); err != nil {
		return fmt.Errorf("failed to change dir to %s: %w", dotfilesDir, err)
	}

	if err := runCommand("git", "pull"); err != nil {
		return fmt.Errorf("failed to git pull: %w", err)
	}

	// 2. Restow
	fmt.Println("Restowing configuration...")
	if err := stowDotfiles(stowPackages); err != nil {
		return fmt.Errorf("failed to restow: %w", err)
	}

	fmt.Println("Update complete!")
	return nil
}
