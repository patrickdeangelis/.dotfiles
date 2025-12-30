package main

import (
	"bytes"
	"fmt"
	"io/fs"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

func runEdit() error {
	dotfilesDir, err := getDotfilesDir()
	if err != nil {
		return err
	}

	if err := os.Chdir(dotfilesDir); err != nil {
		return fmt.Errorf("failed to chdir: %w", err)
	}

	// Collect files
	var files []string
	for _, pkg := range stowPackages {
		err := filepath.WalkDir(pkg, func(path string, d fs.DirEntry, err error) error {
			if err != nil {
				return err
			}
			if !d.IsDir() {
				files = append(files, path)
			}
			return nil
		})
		if err != nil {
			fmt.Printf("Warning: error walking %s: %v\n", pkg, err)
		}
	}

	selectedFile := ""

	// Try fzf
	if checkCommand("fzf") {
		cmd := exec.Command("fzf")
		cmd.Stdin = strings.NewReader(strings.Join(files, "\n"))
		cmd.Stderr = os.Stderr // UI display
		var out bytes.Buffer
		cmd.Stdout = &out // Selection output

		if err := cmd.Run(); err != nil {
			// If user cancels (Ctrl-C/Esc), fzf returns non-zero
			return nil 
		}
		selectedFile = strings.TrimSpace(out.String())
	} else {
		// Fallback: Simple list
		fmt.Println("Select a file to edit:")
		for i, f := range files {
			fmt.Printf("[%d] %s\n", i+1, f)
		}
		fmt.Print("Enter number: ")
		var idx int
		if _, err := fmt.Scanln(&idx); err != nil {
			return nil
		}
		if idx < 1 || idx > len(files) {
			return fmt.Errorf("invalid selection")
		}
		selectedFile = files[idx-1]
	}

	if selectedFile == "" {
		return nil
	}

	editor := os.Getenv("EDITOR")
	if editor == "" {
		editor = "vi"
	}

	fmt.Printf("Opening %s with %s...\n", selectedFile, editor)
	cmd := exec.Command(editor, selectedFile)
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return cmd.Run()
}
