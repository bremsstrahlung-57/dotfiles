# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#   ◢ RETRO FUTURISM ◣  ·  ZSH THEME  ·  THE FUTURE IS NOW
#   Inspired by: Atomic Age · Space Race · Googie · The Jetsons · 2001
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Atomic Age color palette - clean, optimistic, bold
ATOMIC_TEAL="%F{37}"
ATOMIC_ORANGE="%F{208}"
ATOMIC_CREAM="%F{223}"
ATOMIC_MINT="%F{121}"
ATOMIC_CORAL="%F{203}"
ATOMIC_GOLD="%F{220}"
ATOMIC_SKY="%F{117}"
ATOMIC_WHITE="%F{255}"
ATOMIC_SILVER="%F{249}"
ATOMIC_GRAY="%F{243}"
RESET="%f"
BOLD="%B"
UNBOLD="%b"

setopt prompt_subst

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# REACTOR CORE STATUS (system load as atomic reactor)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

_reactor_core() {
  local load=$(uptime 2>/dev/null | awk -F'load average:' '{print $2}' | cut -d, -f1 | tr -d ' ')
  if [[ -n "$load" ]]; then
    local load_int=${load%.*}
    if (( load_int >= 4 )); then
      echo "${ATOMIC_CORAL}⚛ CRITICAL"
    elif (( load_int >= 2 )); then
      echo "${ATOMIC_ORANGE}⚛ ELEVATED"
    elif (( load_int >= 1 )); then
      echo "${ATOMIC_GOLD}⚛ NOMINAL"
    else
      echo "${ATOMIC_MINT}⚛ OPTIMAL"
    fi
  else
    echo "${ATOMIC_MINT}⚛ OPTIMAL"
  fi
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# TRANSMISSION STATUS (local vs remote)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

_transmission() {
  if [[ -n "$SSH_CONNECTION" ]]; then
    echo "${ATOMIC_CORAL}◎ SATELLITE"
  else
    echo "${ATOMIC_TEAL}◉ GROUND"
  fi
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# MISSION CONTROL (git status with space race aesthetics)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

_mission_control() {
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
  local res=" ${ATOMIC_SILVER}on ${ATOMIC_ORANGE}${BOLD}🚀 ${branch}${UNBOLD}"

  local ahead=0 behind=0
  local tracking=$(git rev-parse --abbrev-ref @{u} 2>/dev/null)
  if [[ -n "$tracking" ]]; then
    local counts=($(git rev-list --left-right --count HEAD...@{u} 2>/dev/null))
    ahead=${counts[1]:-0}
    behind=${counts[2]:-0}
  else
    ahead=$(git rev-list --count HEAD 2>/dev/null || echo 0)
  fi

  (( ahead > 0 )) && res+=" ${ATOMIC_MINT}△${ahead}"
  (( behind > 0 )) && res+=" ${ATOMIC_CORAL}▽${behind}"
  (( staged > 0 )) && res+=" ${ATOMIC_GOLD}◆${staged}"
  (( unstaged > 0 )) && res+=" ${ATOMIC_ORANGE}◇${unstaged}"
  (( untracked > 0 )) && res+=" ${ATOMIC_SKY}○${untracked}"

  echo "${res}%f"
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# LAUNCH STATUS (exit code)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

_launch_status() {
  echo "%(?.${ATOMIC_MINT}▲ GO.${ATOMIC_CORAL}▼ ABORT:%?)"
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# MAIN PROMPT - MISSION BRIEFING DISPLAY
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Line 1: Station header with pilot info
RETRO_LINE1="${ATOMIC_TEAL}${BOLD}◢◤${UNBOLD} ${ATOMIC_CREAM}STATION ${ATOMIC_WHITE}${BOLD}%m${UNBOLD} ${ATOMIC_SILVER}━━━ ${ATOMIC_GOLD}PILOT: ${ATOMIC_ORANGE}${BOLD}%n${UNBOLD} ${ATOMIC_SILVER}━━━ \$(_transmission) ${ATOMIC_SILVER}━━━ \$(_reactor_core)"

# Line 2: Navigation coordinates (current directory + git)
RETRO_LINE2="
${ATOMIC_TEAL}${BOLD}┃${UNBOLD}  ${ATOMIC_SILVER}NAV ${ATOMIC_SKY}◈ ${ATOMIC_WHITE}${BOLD}%~${UNBOLD}\$(_mission_control)"

# Line 3: Command input with launch status
RETRO_LINE3="
${ATOMIC_TEAL}${BOLD}◥◣${UNBOLD} \$(_launch_status) ${ATOMIC_TEAL}▸▸▸ ${RESET}"

RETRO_FULL_PROMPT="${RETRO_LINE1}${RETRO_LINE2}${RETRO_LINE3}"

# Right prompt - telemetry data
RETRO_FULL_RPROMPT="%{"$'\e[2A'"%}${ATOMIC_GRAY}┃ ${ATOMIC_SILVER}\$(cmd_exec_time)${ATOMIC_GOLD}◷ ${ATOMIC_CREAM}%*${ATOMIC_GRAY} ┃%{"$'\e[2B'"%}"

# Transient prompt (sleek minimal after execution)
RETRO_TRANSIENT_PROMPT="${ATOMIC_TEAL}▸ ${RESET}"

PROMPT=$RETRO_FULL_PROMPT
RPROMPT=$RETRO_FULL_RPROMPT

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# TRANSIENT PROMPT HOOKS
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

_retro_transient_finish() {
  PROMPT=$RETRO_TRANSIENT_PROMPT
  RPROMPT=""
  zle reset-prompt
}
zle -N zle-line-finish _retro_transient_finish

_retro_restore_prompt() {
  PROMPT=$RETRO_FULL_PROMPT
  RPROMPT=$RETRO_FULL_RPROMPT
}
add-zsh-hook precmd _retro_restore_prompt

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# FLIGHT RECORDER (execution time)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

zmodload zsh/datetime
autoload -Uz add-zsh-hook

_retro_timer_preexec() {
  _cmd_start_time=$EPOCHREALTIME
}

_retro_timer_precmd() {
  if [[ -n $_cmd_start_time ]]; then
    local _cmd_end_time=$EPOCHREALTIME
    _cmd_duration_ms=$(( (_cmd_end_time - _cmd_start_time) * 1000 ))
    _cmd_duration_ms=${_cmd_duration_ms%.*}
    unset _cmd_start_time
  else
    _cmd_duration_ms=0
  fi
}

add-zsh-hook preexec _retro_timer_preexec
add-zsh-hook precmd _retro_timer_precmd

cmd_exec_time() {
  if [[ -n $_cmd_duration_ms && $_cmd_duration_ms -gt 500 ]]; then
    if (( _cmd_duration_ms >= 60000 )); then
      local mins=$(( _cmd_duration_ms / 60000 ))
      local secs=$(( (_cmd_duration_ms % 60000) / 1000 ))
      echo "${ATOMIC_ORANGE}T+${mins}m${secs}s "
    elif (( _cmd_duration_ms >= 1000 )); then
      local secs=$(( _cmd_duration_ms / 1000 ))
      echo "${ATOMIC_GOLD}T+${secs}s "
    else
      echo "${ATOMIC_MINT}T+${_cmd_duration_ms}ms "
    fi
  fi
}
