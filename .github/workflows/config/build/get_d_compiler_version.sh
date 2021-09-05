#!/usr/bin/env bash

set -o pipefail

RED='\033[0;31m'
COLORLESS='\033[0m'

print_error() {
  local error_message="$1"
  echo >&2 -e "${RED}Error:${COLORLESS} ${error_message}"
}

if [[ -v ${DC} ]]; then
  print_error "D compiler \"${DC}\" (\"DC\" environment variable) not found."
  exit 1
else
  echo "Info: DC=${DC}"
fi

dc_version_str="$(${DC} --version)"
last_command_failed=$?

if [[ ${last_command_failed} ]]; then
  print_error "D compiler \"${DC}\" failed to supply its version."
  exit 2
fi

dc_version_line_str="$(echo "${dc_version_str}" | grep -i -E -o -m1 "D compiler [v\(][0-9]+\.[0-9]+\.[0-9]+[-\)]")"
last_command_failed=$?

if [[ ${last_command_failed} ]]; then
  print_error "Failed to find a string line supplied by \"${DC}\" which contains the D compiler's version."
  exit 3
fi

dc_version="$(echo "${dc_version_line_str}" | grep -i -E -o "[0-9]+\.[0-9]+\.[0-9]+")"
last_command_failed=$?

if [[ ${last_command_failed} ]]; then
  print_error "Failed to extract the D compiler's (\"${DC}\") version from a string line previously found which was supposed to contain it."
  exit 4
fi

echo "${dc_version}"
