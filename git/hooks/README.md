# Git Hooks

This directory contains useful Git hooks to maintain code quality.

## Available Hooks

### pre-commit

Runs before each commit to check for common mistakes:

- Trailing whitespace
- Debug statements (console.log, debugger, etc.)
- Sensitive files (.env, *.pem, etc.)
- Merge conflict markers
- Shell script syntax errors

## Installation

The hooks will be automatically installed by the main `install.sh` script.

To manually install a hook:

```bash
# Set up git hooks path
git config --global core.hooksPath ~/.dotfiles/git/hooks

# Or copy to a specific repository
cp pre-commit /path/to/repo/.git/hooks/
chmod +x /path/to/repo/.git/hooks/pre-commit
```

## Customization

Edit the hooks directly to add project-specific checks or remove checks you don't need.

You can also create a `.git/hooks/pre-commit.local` file in your repositories for repository-specific checks.

## Bypassing Hooks

If you need to bypass the hooks temporarily:

```bash
git commit --no-verify
```

**Note:** Use this sparingly and only when you know what you're doing!
