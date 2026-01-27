#!/bin/bash

function fatal() {
  local msg=$1
  printf >&2 "fatal: %s" "$msg"
  exit 1
}

trap "kill 0" EXIT || fatal "cannot trap on EXIT"
test -d devel || fatal "not run from project root: ./devel is not a directory"
test -d devel/svc || fatal "not run from project root: ./devel/svc is not a directory"

runsvdir devel/svc
