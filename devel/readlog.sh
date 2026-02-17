#!/usr/bin/env bash

declare -a COLORS=(
  "31" "32" "33" "34" "35" "36" "37" "91" "92" "93" "94" "95" "96"
)

function fatal() {
  local msg=$1
  printf >&2 "fatal: %s" "$msg"
  exit 1
}

function print_line() {
  local color=$1 svc=$2 time=$3 line=$4

  local svc_sz=$(( ${#svc} + 2 + 1 ))
  local time_sz=$(( ${#time} + 1 ))

  local svc_end="]"
  local outline out=""
  local expected_line_sz=$(( COLUMNS - svc_sz - time_sz ))
  local line_remaining_sz=${#line}
  while [ "$line_remaining_sz" -gt "$expected_line_sz" ]
  do
    local segment="${line:0:expected_line_sz}"
    printf -v outline "[\033[%sm%s\033[0m%s %s \033[2m%s\033[0m\n" "$color" "$svc" "$svc_end" "$segment" "$time"
    out+="$outline"
    line="${line:expected_line_sz}"
    line_remaining_sz="${#line}"

    time="" # only write time once per logical line
    svc_end=">"
  done

  padding=$(( ${#line} - expected_line_sz ))
  printf -v outline "[\033[%sm%s\033[0m%s %s%*s \033[2m%s\033[0m\n" "$color" "$svc" "$svc_end" "$line" "$padding" '' "$time"
  out+="$outline"

  printf "%s" "$out"
}

function log_svc() {
  local svc=$1 color=$2
  # shellcheck disable=SC2155
  local svc_name="$(basename "$svc")"

  cd "$svc" || fatal "cannot chdir into $svc"
  test -r current || fatal "service $svc_name is too quiet"

  local data
  tail -F current | while read -r data
  do
    local time="${data%% *}"
    local line="${data#* }"
    line="$(printf '%s' "$line" | tr -d '\r\v\f')"
    print_line "$color" "$svc_name" "$time" "$line"
  done
}

function cleanup() {
  tput rmcup
  kill 0
}

: ${COLUMNS:=$(tput cols)}

trap cleanup EXIT || fatal "cannot trap on EXIT"

test -d devel || fatal "not run from project root: ./devel is not a directory"
test -d devel/log || fatal "not run from project root: ./devel/log is not a directory"

tput smcup

COLOR_IDX=0
for svc in ./devel/log/*
do
  color="${COLORS[COLOR_IDX]}"
  (( ++COLOR_IDX ))
  log_svc "$svc" "$color" &
done

wait
