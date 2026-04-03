# Frutiger Aero Zsh Theme
# Colors
AERO_BLUE="%F{39}"      # Glossy Window Blue
AERO_CYAN="%F{51}"      # Clear Water Cyan
AERO_GREEN="%F{82}"     # Nature/Grass Green
AERO_WHITE="%F{15}"     # Cloud White
AERO_GRAY="%F{245}"     # Silver sheen
RESET="%f"

# Enable command substitution in the prompt
setopt prompt_subst

# Git info (Oh My Zsh standard integration)
ZSH_THEME_GIT_PROMPT_PREFIX="%{$AERO_WHITE%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$AERO_WHITE%}]"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$AERO_GREEN%}✨%f"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Prompt Structure
# Top line:    ╭─ ☁️  username 🔹 💧 directory [git]
# Bottom line: ╰─ 🌿 ❯
PROMPT="
%{$AERO_BLUE%}╭─ %{$AERO_WHITE%}☁️  %{$AERO_BLUE%}%n %{$AERO_WHITE%}🔹 %{$AERO_CYAN%}💧 %{$AERO_CYAN%}%~ %{$AERO_WHITE%}\$(git_prompt_info)
%{$AERO_BLUE%}╰─ %{$AERO_GREEN%}🌿 ❯ %{$RESET%}"

# Right prompt: Time (globe)
RPROMPT="%{$AERO_GRAY%}🌐 %*"
