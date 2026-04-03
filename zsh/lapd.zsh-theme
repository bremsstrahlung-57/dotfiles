# Colors
CYAN="%F{45}"
RED="%F{196}"
WHITE="%F{15}"
GRAY="%F{242}"
GREEN="%F{46}"
RESET="%f"

# Enable command substitution in the prompt
setopt prompt_subst

# Full Prompts
LAPD_FULL_PROMPT="
${CYAN}[ 警察 LAPD ] ${GRAY}OFFICER:${CYAN} %n ${GRAY}ACCESS:${WHITE} %~\$(git_prompt_info) ${RESET}
${RED}█║▌│█│║▌║││█║▌ ROOT${CYAN}# ${RESET}"
LAPD_FULL_RPROMPT="%{"$'\e[1A'"%}${RED}\$(cmd_exec_time) ${GRAY}T- ${CYAN}%*%{"$'\e[1B'"%}"

# Transient Prompt (Shows in scrollback history)
LAPD_TRANSIENT_PROMPT="${CYAN}❯ ${RESET}"

PROMPT=$LAPD_FULL_PROMPT
RPROMPT=$LAPD_FULL_RPROMPT

# Transient prompt hook for Zle
_lapd_transient_prompt_finish() {
  PROMPT=$LAPD_TRANSIENT_PROMPT
  RPROMPT=""
  zle reset-prompt
}
zle -N zle-line-finish _lapd_transient_prompt_finish

# Git info (p10k style compact status)
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
  local res=" ${GRAY}SEC_CODE:${RED}[${branch}]"

  local ahead=0 behind=0
  local tracking=$(git rev-parse --abbrev-ref @{u} 2>/dev/null)
  if [[ -n "$tracking" ]]; then
    local counts=($(git rev-list --left-right --count HEAD...@{u} 2>/dev/null))
    ahead=${counts[1]:-0}
    behind=${counts[2]:-0}
  else
    ahead=$(git rev-list --count HEAD 2>/dev/null || echo 0)
  fi

  (( ahead > 0 )) && res+=" %F{46}⇡${ahead}"
  (( behind > 0 )) && res+=" %F{196}⇣${behind}"
  (( staged > 0 )) && res+=" %F{226}+${staged}"
  (( unstaged > 0 )) && res+=" %F{214}!${unstaged}"
  (( untracked > 0 )) && res+=" %F{45}?${untracked}"

  echo "${res}%f"
}

# Execution time
zmodload zsh/datetime
autoload -Uz add-zsh-hook

_timer_preexec() {
  _cmd_start_time=$EPOCHREALTIME
}

_timer_precmd() {
  if [[ -n $_cmd_start_time ]]; then
    local _cmd_end_time=$EPOCHREALTIME
    _cmd_duration_ms=$(( (_cmd_end_time - _cmd_start_time) * 1000 ))
    _cmd_duration_ms=${_cmd_duration_ms%.*} # Truncate to integer
    unset _cmd_start_time
  else
    _cmd_duration_ms=0
  fi
}

add-zsh-hook preexec _timer_preexec
add-zsh-hook precmd _timer_precmd

# Restore full prompt before every new command line
_lapd_restore_prompt() {
  PROMPT=$LAPD_FULL_PROMPT
  RPROMPT=$LAPD_FULL_RPROMPT
}
add-zsh-hook precmd _lapd_restore_prompt

cmd_exec_time() {
  if [[ -n $_cmd_duration_ms && $_cmd_duration_ms -gt 500 ]]; then
    echo "LATENCY: ${_cmd_duration_ms}ms "
  fi
}
