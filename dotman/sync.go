package main

import "fmt"

func runSync() error {
	fmt.Println("Syncing dotfiles (restowing)...")
	// stowDotfiles is defined in install.go
	if err := stowDotfiles(stowPackages); err != nil {
		return fmt.Errorf("failed to sync (stow) dotfiles: %w", err)
	}
	fmt.Println("Sync complete!")
	return nil
}
