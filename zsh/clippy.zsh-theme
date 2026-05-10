# Clippy Zsh Theme (Pastel / Gruvbox / Rice aesthetic)

setopt prompt_subst

# Pastel Colors (Gruvbox/Everforest inspired)
FG_DARK="%F{232}"
FG_LIGHT="%F{223}"

C_BLUE="%F{109}"
BG_BLUE="%K{109}"

C_YELLOW="%F{180}"
BG_YELLOW="%K{180}"

C_GREEN="%F{108}"
BG_GREEN="%K{108}"

C_PINK="%F{167}"
BG_PINK="%K{167}"

C_DARK="%F{236}"
BG_DARK="%K{236}"

RESET="%f%k"

git_prompt_info() {
  [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == "true" ]] || return

  local gs=$(git status --porcelain 2>/dev/null)
  local staged=0 unstaged=0 untracked=0

  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    local x="${line:0:1}"
    local y="${line:1:1}"
    [[ "$x$y" == "??" ]] && ((untracked++)) && continue
    [[ "$x" != " " && "$x" != "?" && "$x" != "U" ]] && ((staged++))
    [[ "$y" != " " && "$y" != "?" && "$y" != "U" ]] && ((unstaged++))
  done <<< "$gs"

  local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  local ahead=0 behind=0
  local tracking=$(git rev-parse --abbrev-ref @{u} 2>/dev/null)

  if [[ -n "$tracking" ]]; then
    local counts=($(git rev-list --left-right --count HEAD...@{u} 2>/dev/null))
    ahead=${counts[1]:-0}
    behind=${counts[2]:-0}
  else
    ahead=$(git rev-list --count HEAD 2>/dev/null || echo 0)
  fi

  local bg=$BG_GREEN
  local edge=$C_GREEN
  (( staged > 0 || unstaged > 0 || untracked > 0 )) && { bg=$BG_PINK; edge=$C_PINK; }

  local res="${bg}${FG_DARK}  ${branch} "

  (( ahead > 0 )) && res+="⇡${ahead} "
  (( behind > 0 )) && res+="⇣${behind} "
  (( staged > 0 )) && res+="+${staged} "
  (( unstaged > 0 )) && res+="!${unstaged} "
  (( untracked > 0 )) && res+="?${untracked} "

  res=${res% }
  echo " ${res} ${RESET}"
}

zmodload zsh/datetime
autoload -Uz add-zsh-hook

_timer_preexec() { _cmd_start_time=$EPOCHREALTIME }
_timer_precmd() {
  if [[ -n $_cmd_start_time ]]; then
    local _cmd_end_time=$EPOCHREALTIME
    _cmd_duration_ms=$(( (_cmd_end_time - _cmd_start_time) * 1000 ))
    _cmd_duration_ms=${_cmd_duration_ms%.*}
    unset _cmd_start_time
  else
    _cmd_duration_ms=0
  fi
}
add-zsh-hook preexec _timer_preexec
add-zsh-hook precmd _timer_precmd

cmd_exec_time() {
  if [[ -n $_cmd_duration_ms && $_cmd_duration_ms -gt 500 ]]; then
    local sec=$(( _cmd_duration_ms / 1000 ))
    local frac=$(( (_cmd_duration_ms % 1000) / 100 ))
    echo "${BG_DARK}${FG_LIGHT} 󱎫 ${sec}.${frac}s ${RESET} "
  fi
}

# Rectangular block prompt segments
CLIPPY_FULL_PROMPT="
${BG_BLUE}${FG_DARK}  %n ${RESET} ${BG_YELLOW}${FG_DARK}  %~ ${RESET}\$(git_prompt_info)
${C_PINK}╰─❯ ${RESET}"

CLIPPY_FULL_RPROMPT="%{"$'\e[1A'"%}\$(cmd_exec_time)${BG_DARK}${C_GREEN}  %* ${RESET}%{"$'\e[1B'"%}"

CLIPPY_TRANSIENT_PROMPT="${C_PINK}❯ ${RESET}"

PROMPT=$CLIPPY_FULL_PROMPT
RPROMPT=$CLIPPY_FULL_RPROMPT

_clippy_transient_prompt_finish() {
  PROMPT=$CLIPPY_TRANSIENT_PROMPT
  RPROMPT=""
  zle reset-prompt
}
zle -N zle-line-finish _clippy_transient_prompt_finish

_clippy_restore_prompt() {
  PROMPT=$CLIPPY_FULL_PROMPT
  RPROMPT=$CLIPPY_FULL_RPROMPT
}
add-zsh-hook precmd _clippy_restore_prompt
