package main

import (
	"fmt"
	"io/fs"
	"os"
	"path/filepath"
	"strings"
)

func runSyncHome() error {
	fmt.Println("Syncing home config into dotfiles...")

	if !checkCommand("rsync") {
		return fmt.Errorf("rsync not found in PATH")
	}

	dotfilesDir, err := getDotfilesDir()
	if err != nil {
		return err
	}

	home, err := os.UserHomeDir()
	if err != nil {
		return err
	}

	lazySrc := filepath.Join(home, ".config", "nvim-lazy")
	lazyDst := filepath.Join(dotfilesDir, "lazy-vim")
	if err := syncDir(lazySrc, lazyDst, []string{".git"}, true); err != nil {
		return err
	}

	tmuxConfSrc := filepath.Join(home, ".tmux.conf")
	tmuxConfDst := filepath.Join(dotfilesDir, "tmux", ".tmux.conf")
	if err := syncFile(tmuxConfSrc, tmuxConfDst); err != nil {
		return err
	}

	tmuxDirSrc := filepath.Join(home, ".tmux")
	tmuxDirDst := filepath.Join(dotfilesDir, "tmux", ".tmux")
	tmuxDirExcludes := []string{"plugins", ".tmux.conf"}
	if err := syncDir(tmuxDirSrc, tmuxDirDst, tmuxDirExcludes, true); err != nil {
		return err
	}

	tmuxNestedConfSrc := filepath.Join(home, ".tmux", ".tmux.conf")
	tmuxNestedConfDst := filepath.Join(dotfilesDir, "tmux", ".tmux", ".tmux.conf")
	if err := syncFile(tmuxNestedConfSrc, tmuxNestedConfDst); err != nil {
		return err
	}

	fmt.Println("Home sync complete!")
	return nil
}

func syncDir(src, dst string, excludes []string, deleteExcluded bool) error {
	if _, err := os.Stat(src); err != nil {
		if os.IsNotExist(err) {
			fmt.Printf("Skipping missing directory: %s\n", src)
			return nil
		}
		return err
	}

	if err := os.MkdirAll(dst, 0o755); err != nil {
		return fmt.Errorf("failed to create destination %s: %w", dst, err)
	}

	keepExcludes, err := preflightDirConflicts(src, dst, excludes)
	if err != nil {
		return err
	}

	args := []string{"-a", "--delete"}
	for _, ex := range append([]string{}, excludes...) {
		args = append(args, "--exclude", ex)
	}
	for _, ex := range keepExcludes {
		args = append(args, "--exclude", ex)
	}
	if deleteExcluded && len(keepExcludes) == 0 && len(excludes) > 0 {
		args = append(args, "--delete-excluded")
	}
	args = append(args, src+"/", dst+"/")
	if err := runCommand("rsync", args...); err != nil {
		return err
	}
	if deleteExcluded && len(keepExcludes) > 0 && len(excludes) > 0 {
		if err := removeExcludedPaths(dst, excludes); err != nil {
			return err
		}
	}
	return nil
}

func syncFile(src, dst string) error {
	if _, err := os.Stat(src); err != nil {
		if os.IsNotExist(err) {
			fmt.Printf("Skipping missing file: %s\n", src)
			return nil
		}
		return err
	}

	if err := os.MkdirAll(filepath.Dir(dst), 0o755); err != nil {
		return fmt.Errorf("failed to create destination %s: %w", filepath.Dir(dst), err)
	}

	if _, err := os.Stat(dst); err == nil {
		equal, err := filesEqual(src, dst)
		if err != nil {
			return err
		}
		if !equal {
			if err := showDiff(dst, src); err != nil {
				return err
			}
			decision, err := promptDecision(dst)
			if err != nil {
				return err
			}
			switch decision {
			case "skip":
				return nil
			case "merge":
				return mergeFiles(dst, src)
			}
		}
	} else if !os.IsNotExist(err) {
		return err
	}

	return runCommand("rsync", "-a", src, dst)
}

func preflightDirConflicts(src, dst string, excludes []string) ([]string, error) {
	var keepExcludes []string
	err := filepath.WalkDir(src, func(path string, d fs.DirEntry, walkErr error) error {
		if walkErr != nil {
			return walkErr
		}
		rel, err := filepath.Rel(src, path)
		if err != nil {
			return err
		}
		if rel == "." {
			return nil
		}
		if isExcluded(rel, excludes) {
			if d.IsDir() {
				return filepath.SkipDir
			}
			return nil
		}
		if d.IsDir() {
			return nil
		}

		dstPath := filepath.Join(dst, rel)
		if _, err := os.Stat(dstPath); err == nil {
			equal, err := filesEqual(path, dstPath)
			if err != nil {
				return err
			}
			if !equal {
				if err := showDiff(dstPath, path); err != nil {
					return err
				}
				decision, err := promptDecision(dstPath)
				if err != nil {
					return err
				}
				switch decision {
				case "skip":
					keepExcludes = append(keepExcludes, rel)
				case "merge":
					if err := mergeFiles(dstPath, path); err != nil {
						return err
					}
					keepExcludes = append(keepExcludes, rel)
				}
			}
		} else if !os.IsNotExist(err) {
			return err
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	return keepExcludes, nil
}

func isExcluded(rel string, excludes []string) bool {
	for _, ex := range excludes {
		if rel == ex || strings.HasPrefix(rel, ex+string(os.PathSeparator)) {
			return true
		}
	}
	return false
}

func removeExcludedPaths(dst string, excludes []string) error {
	for _, ex := range excludes {
		path := filepath.Join(dst, ex)
		if _, err := os.Stat(path); err == nil {
			if err := os.RemoveAll(path); err != nil {
				return err
			}
		} else if !os.IsNotExist(err) {
			return err
		}
	}
	return nil
}
