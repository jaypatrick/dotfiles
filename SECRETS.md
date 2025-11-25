# Secrets Management

This document explains how to handle sensitive information and machine-specific configuration in your dotfiles.

## Overview

Dotfiles are typically stored in public repositories, so it's crucial to never commit sensitive information such as:
- API keys
- Passwords
- Private SSH keys
- Database credentials
- AWS/cloud provider credentials
- Personal access tokens

## Local Configuration Files

This dotfiles setup provides several ways to manage secrets and machine-specific configuration:

### 1. `.env.local`

Located at `~/.env.local`, this file is for environment variables that shouldn't be tracked in git.

**Created by:** `install.sh` (if it doesn't exist)
**Sourced by:** `shell/env`
**Usage:** Add environment variables for secrets and machine-specific settings

```bash
# Example ~/.env.local
export AWS_PROFILE=personal
export AWS_DEFAULT_REGION=us-east-1
export GITHUB_TOKEN=ghp_xxxxxxxxxxxx
export OPENAI_API_KEY=sk-xxxxxxxxxxxx
export DATABASE_URL=postgres://localhost/mydb
```

### 2. `.bashrc.local` / `.zshrc.local`

Located at `~/.bashrc.local` and `~/.zshrc.local`, these files are for shell-specific local configuration.

**Created by:** You (manually)
**Sourced by:** `.bashrc` / `.zshrc`
**Usage:** Shell aliases, functions, or settings specific to this machine

```bash
# Example ~/.bashrc.local
# Work-specific aliases
alias vpn='sudo openvpn /etc/openvpn/company.ovpn'
alias ssh-work='ssh user@work-server.company.com'

# Machine-specific PATH additions
export PATH="/opt/company-tools/bin:$PATH"
```

### 3. `.gitconfig.local`

Located at `~/.gitconfig.local`, this file is for git configuration specific to this machine.

**Created by:** You (manually)
**Included by:** `.gitconfig`
**Usage:** Machine-specific git settings, work email, signing keys

```ini
# Example ~/.gitconfig.local
[user]
    name = Your Name
    email = you@company.com
    signingkey = ABCD1234

[commit]
    gpgsign = true

[url "ssh://git@github.company.com/"]
    insteadOf = https://github.company.com/
```

### 4. `.path.local`

Located at `~/.path.local`, this file is for machine-specific PATH additions.

**Created by:** You (manually)
**Sourced by:** `shell/path`
**Usage:** Add custom directories to your PATH

```bash
# Example ~/.path.local
# Company tools
add_to_path "/opt/company/bin"

# Local installations
add_to_path "/usr/local/custom/bin"
```

### 5. `.ssh/config.local`

Located at `~/.ssh/config.local`, this file is for machine-specific SSH configuration.

**Created by:** You (manually)
**Included by:** `.ssh/config`
**Usage:** Private SSH hosts and configurations

```ssh
# Example ~/.ssh/config.local
Host work-server
    HostName server.company.com
    User myusername
    IdentityFile ~/.ssh/id_rsa_work

Host personal-vps
    HostName 192.168.1.100
    User admin
    Port 2222
    IdentityFile ~/.ssh/id_ed25519_personal
```

## Best Practices

### 1. Never Commit Secrets

- Always use local configuration files for secrets
- Double-check files before committing (`git diff --cached`)
- Use the pre-commit hook to catch sensitive files

### 2. Use Environment Variables

Store secrets as environment variables in `.env.local`:

```bash
# Good
export DATABASE_PASSWORD="secret123"
# Then use in scripts: $DATABASE_PASSWORD

# Bad: Hardcoding in scripts
db_password="secret123"
```

### 3. SSH Key Management

- Never commit private SSH keys
- Store keys in `~/.ssh/` with proper permissions (600)
- Use different keys for different services
- Consider using SSH agent forwarding carefully

```bash
# Generate a new SSH key
ssh-keygen -t ed25519 -C "your.email@example.com" -f ~/.ssh/id_ed25519_github

# Set correct permissions
chmod 600 ~/.ssh/id_ed25519_github
chmod 644 ~/.ssh/id_ed25519_github.pub
```

### 4. Git Credential Storage

For HTTPS Git operations, use a credential helper:

```bash
# macOS Keychain
git config --global credential.helper osxkeychain

# Linux libsecret
git config --global credential.helper libsecret

# Windows Credential Manager
git config --global credential.helper wincred

# Cache credentials temporarily (in memory)
git config --global credential.helper 'cache --timeout=3600'
```

### 5. GPG Signing

For commit signing with GPG:

```bash
# Generate GPG key
gpg --full-generate-key

# List GPG keys
gpg --list-secret-keys --keyid-format LONG

# Export public key for GitHub/GitLab
gpg --armor --export YOUR_KEY_ID

# Configure git (add to ~/.gitconfig.local)
git config --global user.signingkey YOUR_KEY_ID
git config --global commit.gpgsign true
```

### 6. Use Secret Management Tools

For more complex needs, consider:

- **pass**: The standard Unix password manager
- **1Password CLI**: Integrate with 1Password
- **AWS Secrets Manager**: For AWS credentials
- **Vault**: HashiCorp's secret management solution

Example with `pass`:

```bash
# Store a secret
pass insert api/openai

# Retrieve a secret in your scripts
export OPENAI_API_KEY=$(pass api/openai)
```

## Checking for Exposed Secrets

Before committing, scan for accidentally included secrets:

```bash
# Check staged files
git diff --cached

# Use git-secrets (preventive tool)
git secrets --scan

# Use truffleHog (scan history)
trufflehog git file://. --only-verified
```

## What's Ignored

The repository's `.gitignore` already includes common files that might contain secrets:

```
*.env
*.env.*
.env.local
*.key
*.pem
*_rsa
*_dsa
credentials.json
secrets.yml
```

## Recovery from Accidental Commit

If you accidentally commit secrets:

1. **Immediately rotate/revoke the secret** (change password, regenerate API key, etc.)
2. Remove from git history:

```bash
# Remove a specific file from all history
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch path/to/secret/file" \
  --prune-empty --tag-name-filter cat -- --all

# Or use BFG Repo-Cleaner (faster)
bfg --delete-files secret-file.txt
bfg --replace-text passwords.txt  # File containing patterns to replace

# Force push (careful!)
git push --force --all
git push --force --tags
```

3. **Never** just delete the file in a new commit - the secret remains in git history!

## Machine-Specific Setup Script

Create a setup script for new machines with your secrets:

```bash
#!/bin/bash
# ~/.dotfiles-secrets-setup.sh (keep this OUTSIDE the dotfiles repo!)

# API Keys
echo 'export OPENAI_API_KEY=sk-xxx' >> ~/.env.local
echo 'export GITHUB_TOKEN=ghp_xxx' >> ~/.env.local

# Work Git Config
cat > ~/.gitconfig.local << EOF
[user]
    email = you@company.com
EOF

# Copy SSH keys from secure location
cp /secure/backup/id_rsa ~/.ssh/
chmod 600 ~/.ssh/id_rsa
```

Store this script in a secure, private location (encrypted USB drive, password manager, etc.).

## Questions?

If you have questions about managing secrets in your dotfiles, refer to:
- [GitHub: Removing sensitive data](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository)
- [git-secrets](https://github.com/awslabs/git-secrets)
- [The Twelve-Factor App: Config](https://12factor.net/config)
