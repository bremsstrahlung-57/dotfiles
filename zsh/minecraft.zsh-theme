# Minecraft Zsh Theme
# A blocky, survival-ready theme for your terminal.

# Colors
MC_GREEN="%F{46}"    # Grass / Creeper
MC_BROWN="%F{130}"   # Dirt / Wood
MC_GRAY="%F{244}"    # Stone / Iron
MC_CYAN="%F{51}"     # Diamond
MC_RED="%F{196}"     # Redstone / Health
MC_GOLD="%F{226}"    # Gold / Experience
MC_WHITE="%F{15}"    # Quartz / Wool
RESET="%f"

# Enable command substitution in the prompt
setopt prompt_subst

# Git info (Oh My Zsh standard integration)
# Uses TNT 🧨 for branches and Experience ✨ for dirty state
ZSH_THEME_GIT_PROMPT_PREFIX="%{$MC_GRAY%}[%{$MC_RED%}🧨 "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$MC_GRAY%}]"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$MC_GOLD%}✨"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Prompt Structure
# Top line:    ⛏️  username 💎 directory [git]
# Bottom line: 🟩 ❯
PROMPT="
%{$MC_GRAY%}⛏️  %{$MC_GREEN%}%n %{$MC_CYAN%}💎 %{$MC_BROWN%}%~ %{$MC_WHITE%}\$(git_prompt_info)
%{$MC_GREEN%}🟩 ❯ %{$RESET%}"

# Right prompt: Time (Compass)
RPROMPT="%{$MC_GOLD%}🧭 %*"
