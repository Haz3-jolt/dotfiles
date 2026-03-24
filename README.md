# Haz3's Dotfiles

Fully automated development environment setup managed with [chezmoi](https://chezmoi.io). One command to go from a fresh Linux install to a fully configured shell with 50+ modern CLI tools.

## Quick Start

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply Haz3-jolt
```

That's it. Grab a coffee — everything installs automatically.

## What Gets Installed

### Shell
- **Zsh** — set as default shell automatically
- **Antidote** — fast ZSH plugin manager
- **Starship** — cross-shell prompt with custom bracketed config
- **Zsh plugins** — autosuggestions, syntax highlighting, fzf-tab, completions, git/sudo/extract from oh-my-zsh

### Runtimes & Package Managers
- **Rust** (rustup) — Rust toolchain
- **Bun** — fast JavaScript runtime & bundler
- **uv** — fast Python package installer
- **mise** — runtime version manager (Node LTS, Python latest)
- **npm globals** — typescript, prettier, eslint, pnpm, nodemon, etc.

### Modern CLI Replacements
| Classic | Replacement | Description |
|---------|-------------|-------------|
| `ls` | `eza` | Icons, git status, tree view |
| `cat` | `bat` | Syntax highlighting, line numbers |
| `grep` | `ripgrep` | Blazing fast recursive search |
| `find` | `fd` | Simpler syntax, respects .gitignore |
| `cd` | `zoxide` | Smart directory jumping |
| `du` | `dust` | Intuitive disk usage |
| `df` | `duf` | Better disk free output |
| `ps` | `procs` | Modern process viewer |
| `sed` | `sd` | Intuitive find & replace |
| `top` | `btop` | Beautiful resource monitor |
| `diff` | `delta` | Syntax-aware git diffs |
| `dig` | `dog` | DNS lookup (Arch only) |

### Developer Tools
- **fzf** — fuzzy finder (Ctrl+T, Alt+C, Ctrl+R)
- **lazygit** / **gitui** — terminal git UIs
- **zellij** — terminal multiplexer
- **yazi** — terminal file manager (cd on exit)
- **just** — modern make alternative
- **hyperfine** — CLI benchmarking
- **watchexec** — file watcher
- **tokei** — code statistics
- **xh** — friendly HTTP client
- **jless** — JSON viewer
- **tldr** — simplified man pages
- **atuin** — shell history search & sync
- **direnv** — auto-load project environments
- **fastfetch** — system info

### System Services (systemd)
- **ssh-agent** — auto-started via systemd user service
- **chezmoi-sync** — auto-syncs dotfiles every 6 hours

## Supported Distros

| Distro | Package Manager |
|--------|----------------|
| Ubuntu / Debian / Pop!_OS | apt |
| Arch / EndeavourOS / Manjaro | pacman |
| Fedora | dnf |

Tools not available via system packages are installed through Rust's `cargo install`.

## What Happens During Setup

The bootstrap runs numbered scripts in order:

1. **System packages** — installs core tools via your distro's package manager
2. **Zsh** — set as default shell (`chsh`)
3. **Starship** — prompt installed via official installer
4. **mise** — runtime version manager
5. **Bun** — JavaScript runtime
6. **uv** — Python package manager
7. **Rust** — toolchain via rustup
8. **Antidote** — ZSH plugin manager
9. **Runtimes** — Node LTS + Python latest via mise
10. **npm globals** — typescript, prettier, eslint, pnpm, etc.
11. **SSH key** — generates ed25519 key, prints public key for GitHub
12. **XDG dirs** — creates standard directories
13. **ssh-agent** — enables systemd user service
14. **Auto-sync** — enables chezmoi sync timer
15. **ZSH plugins** — syncs and compiles plugins
16. **Cargo tools** — installs 20+ Rust-based CLI tools
17. **Cleanup** — installs lazygit, final setup

## Configuration

On first run, you'll be prompted for:
- **Email** — used for SSH key generation and git config
- **Name** — used for git config

These are stored in `~/.config/chezmoi/chezmoi.toml` and only asked once.

## Shell Features

### Key Bindings
- `Ctrl+T` — fuzzy file search (fzf)
- `Alt+C` — fuzzy cd into directory (fzf)
- `Ctrl+R` — search shell history (atuin)
- `Esc Esc` — prefix current command with `sudo` (oh-my-zsh sudo plugin)

### Aliases

#### Chezmoi
| Alias | Command |
|-------|---------|
| `cz` | `chezmoi` |
| `cze` | `chezmoi edit` |
| `czd` | `chezmoi diff` |
| `cza` | `chezmoi apply` |
| `czcd` | `cd` to chezmoi source dir |
| `czu` | `chezmoi update --apply` |

#### Modern Replacements (auto-detected)
| Alias | Replacement |
|-------|-------------|
| `ls` | `eza --icons` |
| `ll` | `eza -la` with git status |
| `la` | `eza -a` |
| `lt` | `eza --tree` (2 levels) |
| `tree` | `eza --tree` |
| `cat` | `bat` / `batcat` |
| `du` | `dust` |
| `df` | `duf` |
| `ps` | `procs` |
| `sed` | `sd` |
| `top` | `btop` |
| `dig` | `dog` |
| `grep` | `rg` |

#### Git
| Alias | Command |
|-------|---------|
| `lg` | `lazygit` |
| `g` | `git` |
| `gs` | `git status` |
| `ga` | `git add` |
| `gc` | `git commit` |
| `gp` | `git push` |
| `gl` | `git pull` |
| `gd` | `git diff` |
| `gco` | `git checkout` |
| `gb` | `git branch` |
| `glog` | `git log --oneline --graph --all` |

#### Docker
| Alias | Command |
|-------|---------|
| `lzd` | `lazydocker` |
| `dps` | `docker ps` |
| `dpsa` | `docker ps -a` |
| `di` | `docker images` |
| `dex` | `docker exec -it` |

#### Shortcuts
| Alias | Command |
|-------|---------|
| `y` | `yazi` (cd on exit) |
| `j` | `just` |
| `vim` | `nvim` |

#### Safety
| Alias | Effect |
|-------|--------|
| `rm` | `rm -i` (confirm before delete) |
| `mv` | `mv -i` (confirm before overwrite) |
| `cp` | `cp -i` (confirm before overwrite) |

#### Navigation & Common
| Alias | Command |
|-------|---------|
| `..` | `cd ..` |
| `...` | `cd ../..` |
| `....` | `cd ../../..` |
| `~` | `cd ~` |
| `-` | `cd -` |
| `h` | `history` |
| `c` | `clear` |
| `e` | `$EDITOR` (nvim) |
| `reload` | `exec zsh` (restart shell) |

#### Clipboard (Linux)
| Alias | Maps to |
|-------|---------|
| `pbcopy` | `wl-copy` or `xclip` |
| `pbpaste` | `wl-paste` or `xclip` |

#### Networking & Misc
| Alias | Command |
|-------|---------|
| `myip` | `curl ifconfig.me` |
| `ports` | `netstat -tulanp` |
| `listening` | `lsof -i -P \| grep LISTEN` |
| `weather` | `curl wttr.in` |
| `cheat` | `curl cheat.sh` |

### Custom Functions

#### File & Directory
| Function | Description |
|----------|-------------|
| `mkcd <dir>` | Create directory and cd into it |
| `extract <file>` | Extract any archive (tar, gz, zip, 7z, rar, zst, etc.) |
| `backup <file>` | Copy file to file.bak |
| `serve [port]` | Quick Python HTTP server (default: 8080) |

#### Fuzzy Finders (fzf-powered)
| Function | Description |
|----------|-------------|
| `fe` | Fuzzy find + edit file (with bat preview) |
| `fcd` | Fuzzy find + cd into directory (with eza tree preview) |
| `gcof` | Fuzzy git checkout branch (with log preview) |

#### Git
| Function | Description |
|----------|-------------|
| `gc [msg]` | `git add -A && git commit && git push` (default msg: "update") |

#### Process & Port
| Function | Description |
|----------|-------------|
| `port <num>` | Find process listening on port |
| `killport <num>` | Kill process on port |

#### Docker
| Function | Description |
|----------|-------------|
| `docker-stop-all` | Stop all running containers |
| `docker-rm-all` | Remove all containers |

#### System & Info
| Function | Description |
|----------|-------------|
| `update-all` | Update everything (system packages, rust, starship, mise, plugins, dotfiles) |
| `weather [city]` | Show weather forecast |
| `cheat <cmd>` | Show cheat sheet for a command |
| `hs <query>` | Search shell history |
| `time-zsh` | Benchmark zsh startup time |

#### ZSH Config Editors
| Function | Opens |
|----------|-------|
| `editzshrc` | `.zshrc` |
| `editenv` | `env.zsh` |
| `editaliases` | `aliases.zsh` |
| `editfunc` | `functions.zsh` |
| `editplugins` | `plugins.zsh` |
| `editprompt` | `prompt.zsh` |
| `editpluglist` | `.zsh_plugins.txt` |

## Post-Install

After the bootstrap completes:

1. **Log out and back in** (for zsh to take effect as default shell)
2. **Add your SSH key to GitHub** — the public key is printed during setup

## Structure

```
├── .chezmoi.toml.tmpl                    # chezmoi config (prompts for name/email)
├── run_once_before_01-install-packages   # system packages
├── run_once_before_02-set-zsh-default    # chsh to zsh
├── run_once_before_03-install-starship   # starship prompt
├── run_once_before_04..08-install-*      # mise, bun, uv, rust, antidote
├── run_once_09..15-*                     # runtimes, npm, ssh, xdg, services, plugins
├── run_once_after_99-cleanup             # cargo tools, lazygit, final setup
├── dot_zshenv                            # points ZDOTDIR to ~/.config/zsh
├── dot_gitconfig                         # git user config
├── dot_config/
│   ├── starship.toml                     # starship prompt theme
│   ├── mise/config.toml                  # mise tool versions
│   ├── systemd/user/                     # ssh-agent + chezmoi-sync services
│   └── zsh/
│       ├── .zshrc                        # main entry point
│       ├── env.zsh                       # environment, PATH, XDG, history
│       ├── aliases.zsh                   # modern CLI aliases
│       ├── functions.zsh                 # custom shell functions
│       ├── plugins.zsh                   # plugin loading (antidote, zoxide, fzf, etc.)
│       ├── prompt.zsh                    # starship init (with fallback)
│       └── .zsh_plugins.txt              # antidote plugin list
```

## License

MIT
