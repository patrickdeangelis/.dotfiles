package main

import (
	"fmt"
	"os"
)

func runClean() error {
	fmt.Println("Cleaning linked dotfiles...")

	dotfilesDir, err := getDotfilesDir()
	if err != nil {
		return err
	}

	if err := os.Chdir(dotfilesDir); err != nil {
		return fmt.Errorf("failed to change dir to %s: %w", dotfilesDir, err)
	}

	for _, pkg := range stowPackages {
		fmt.Printf("Unstowing %s...\n", pkg)
		if err := runCommand("stow", "-D", pkg); err != nil {
			fmt.Printf("Warning: failed to unstow %s (might not be linked): %v\n", pkg, err)
		}
	}

	fmt.Println("Clean complete!")
	return nil
}
