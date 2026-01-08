package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func runPush(message string) error {
	fmt.Println("Pushing dotfiles...")

	dotfilesDir, err := getDotfilesDir()
	if err != nil {
		return err
	}

	if err := os.Chdir(dotfilesDir); err != nil {
		return fmt.Errorf("failed to change dir to %s: %w", dotfilesDir, err)
	}

	status, err := runCommandOutput("git", "status", "--porcelain")
	if err != nil {
		return fmt.Errorf("failed to check git status: %w", err)
	}
	if strings.TrimSpace(status) == "" {
		fmt.Println("No changes to commit.")
		return nil
	}

	if message == "" {
		reader := bufio.NewReader(os.Stdin)
		fmt.Print("Commit message: ")
		input, err := reader.ReadString('\n')
		if err != nil {
			return err
		}
		message = strings.TrimSpace(input)
	}
	if message == "" {
		return fmt.Errorf("commit message is required")
	}

	if err := runCommand("git", "add", "-A"); err != nil {
		return fmt.Errorf("failed to git add: %w", err)
	}
	if err := runCommand("git", "commit", "-m", message); err != nil {
		return fmt.Errorf("failed to git commit: %w", err)
	}
	if err := runCommand("git", "push"); err != nil {
		return fmt.Errorf("failed to git push: %w", err)
	}

	fmt.Println("Push complete!")
	return nil
}
