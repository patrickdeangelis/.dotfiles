package main

import (
	"flag"
	"fmt"
	"os"
)

func main() {
	if len(os.Args) < 2 {
		printUsage()
		os.Exit(1)
	}

	installCmd := flag.NewFlagSet("install", flag.ExitOnError)
	// install flags can go here if needed, e.g. --dry-run

	updateCmd := flag.NewFlagSet("update", flag.ExitOnError)
	cleanCmd := flag.NewFlagSet("clean", flag.ExitOnError)
	syncCmd := flag.NewFlagSet("sync", flag.ExitOnError)
	editCmd := flag.NewFlagSet("edit", flag.ExitOnError)

	switch os.Args[1] {
	case "install":
		installCmd.Parse(os.Args[2:])
		if err := runInstall(); err != nil {
			fmt.Printf("Error during installation: %v\n", err)
			os.Exit(1)
		}
	case "update":
		updateCmd.Parse(os.Args[2:])
		if err := runUpdate(); err != nil {
			fmt.Printf("Error during update: %v\n", err)
			os.Exit(1)
		}
	case "clean":
		cleanCmd.Parse(os.Args[2:])
		if err := runClean(); err != nil {
			fmt.Printf("Error during clean: %v\n", err)
			os.Exit(1)
		}
	case "sync":
		syncCmd.Parse(os.Args[2:])
		if err := runSync(); err != nil {
			fmt.Printf("Error during sync: %v\n", err)
			os.Exit(1)
		}
	case "edit":
		editCmd.Parse(os.Args[2:])
		if err := runEdit(); err != nil {
			fmt.Printf("Error during edit: %v\n", err)
			os.Exit(1)
		}
	case "help":
		printUsage()
	default:
		fmt.Printf("Unknown command: %s\n", os.Args[1])
		printUsage()
		os.Exit(1)
	}
}

func printUsage() {
	fmt.Println("Usage: dotman <command> [options]")
	fmt.Println("Commands:")
	fmt.Println("  install    Bootstrap the environment (install packages, link dotfiles)")
	fmt.Println("  update     Update dotfiles and packages")
	fmt.Println("  clean      Remove linked dotfiles")
	fmt.Println("  sync       Sync dotfiles (restow)")
	fmt.Println("  edit       Select and edit a dotfile")
	fmt.Println("  help       Show this help message")
}
