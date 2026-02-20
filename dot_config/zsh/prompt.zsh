#!/usr/bin/env zsh
# Prompt Configuration

if command -v starship >/dev/null; then
  eval "$(starship init zsh)"
else
  # Fallback prompt
  autoload -Uz vcs_info
  precmd() { vcs_info }
  zstyle ':vcs_info:git:*' formats '%F{yellow}(%b)%f '
  setopt PROMPT_SUBST
  PROMPT='%F{cyan}%~%f ${vcs_info_msg_0_}%F{green}❯%f '
fi
