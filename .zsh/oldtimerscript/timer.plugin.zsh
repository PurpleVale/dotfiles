zmodload zsh/datetime

__timer_current_time() {
  zmodload zsh/datetime
  echo $EPOCHREALTIME
}

__timer_format_duration() {
  local mins=$(printf '%.0f' $(($1 / 60)))
  local secs=$(printf "%.${TIMER_PRECISION:-1}f" $(($1 - 60 * mins)))
  local duration_str=$(echo "${mins}m${secs}s")
  local format="${TIMER_FORMAT:%d}"
  echo "${format//\%d/${duration_str#0m}}"
}

__timer_save_time_preexec() {
  __timer_cmd_start_time=$(__timer_current_time)
}

__timer_display_timer_precmd() {
  if [ -n "${__timer_cmd_start_time}" ]; then
    local cmd_end_time=$(__timer_current_time)
    local tdiff=$((cmd_end_time - __timer_cmd_start_time))
    unset __timer_cmd_start_time
    if [[ -z "${TIMER_THRESHOLD}" || ${tdiff} -ge "${TIMER_THRESHOLD}" ]]; then
        local tdiffstr=$(__timer_format_duration ${tdiff})

        if [[ -z "${TIMER_THRESHOLD_1}" || ${tdiff} -le "${TIMER_THRESHOLD_1}" ]]; then
            TIMER_LAST="%{$fg[green]%}${tdiffstr}%{$reset_color%}"
        elif [[ -z "${TIMER_THRESHOLD_2}" || ${tdiff} -le "${TIMER_THRESHOLD_2}" ]]; then
            TIMER_LAST="%{$fg[yellow]%}${tdiffstr}%{$reset_color%}"
        else
            TIMER_LAST="%{$fg[red]%}${tdiffstr}%{$reset_color%}"
        fi
    fi
  fi
}
TIMER_LAST="%{$fg[green]%}0s%{$reset_color%}"
autoload -U add-zsh-hook
add-zsh-hook preexec __timer_save_time_preexec
add-zsh-hook precmd __timer_display_timer_precmd
