# Introduction to RCM

This repo uses RCM (RC file Manager) to manage dotfiles. RCM is a suite of tools that helps manage your dotfiles by maintaining them in a central directory and creating appropriate symlinks in your home directory.

## Getting Started

First, make sure you have RCM installed:

```bash
# Debian/Ubuntu
apt-get update && apt-get install rcm
```

When you clone this repo, you'll see a structure like this:
```
dotfiles/
├── rcrc                # RCM's configuration
├── gitconfig           # Your future ~/.gitconfig
├── zshrc               # Your future ~/.zshrc
├── config/             # Maps to ~/.config/
│   └── nvim/          # Maps to ~/.config/nvim/
└── install.sh         # Bootstrap script
```

## How It Works

RCM works by creating symlinks from your home directory to the files in this repo. For example:
- `~/dotfiles/gitconfig` becomes `~/.gitconfig`
- `~/dotfiles/config/nvim/init.vim` becomes `~/.config/nvim/init.vim`

The `config/` directory is special - it maps directly to `~/.config/` while maintaining its internal structure. This is particularly useful for tools that follow the XDG Base Directory specification.

## Installation

The included `install.sh` script handles setup:
```bash
./install.sh
```

This will:
1. Install RCM if it's not already present
2. Set up the RCM configuration
3. Create all necessary symlinks

## Daily Usage

### Common Commands

```bash
rcup              # Update all symlinks (run after pulling changes)
rcup -v           # Same as above but verbose (shows what's happening)
lsrc              # List all files managed by RCM
mkrc ~/.zshrc     # Add an existing dotfile to the repo
```

### Adding New Files

To add a new configuration file:

1. Add it to the repo without the leading dot:
   ```bash
   vim ~/dotfiles/tmux.conf  # Will become ~/.tmux.conf
   ```

2. Run rcup to create the symlink:
   ```bash
   rcup
   ```

### Checking Your Setup

To verify everything is linked correctly:
```bash
ls -la ~/ | grep ^l    # View symlinks in home directory
lsrc                   # List RCM-managed files
```

## Configuration Details

### The rcrc File

The `rcrc` file configures RCM's behavior. Ours is set up to exclude repository files that shouldn't be symlinked:

```bash
# ~/dotfiles/rcrc
DOTFILES_DIRS="$HOME/dotfiles"
EXCLUDES="README.md LICENSE .github/* .gitignore rcrc install.sh"
```

### File Naming

- Files in the repo don't need leading dots
- If they have dots, they won't be double-dotted
- Both `gitconfig` and `.gitconfig` in the repo become `~/.gitconfig`

## Advanced Features

### Host-Specific Files

RCM supports host-specific configurations:

```
dotfiles/
├── gitconfig           # Used everywhere
├── tag-work/          # Only linked with -t work
│   └── gitconfig-work
└── host-laptop/       # Only linked on host "laptop"
    └── specific-config
```

## Troubleshooting

If symlinks aren't being created as expected:

1. Check if the rcrc file is properly linked:
   ```bash
   ls -la ~/.rcrc
   ```

2. Run rcup in verbose mode:
   ```bash
   rcup -v
   ```

3. Verify the file isn't excluded in rcrc

4. For existing files, either remove them or use `mkrc` to add them to the repo:
   ```bash
   mkrc ~/.existing_file
   ```

## Further Resources

- [RCM GitHub Repository](https://github.com/thoughtbot/rcm)
- [Thoughtbot's rcm Blog Post](https://thoughtbot.com/blog/rcm-for-rc-files-in-dotfiles-repos)

## Questions?

If you run into any issues or have questions about this setup, please open an issue in this repository!
