#!/usr/bin/env sh

# shellcheck disable=SC2039
set -o errexit -o nounset -o pipefail

#if bash is available and wanted reexec with bash as executing shell has only effect under GITHUB ACTIONS
if [ "${PIPELINECOMPONENTS_GLOBASSIST:-}" = "true" ] ; then
  if [ -z "${BASH:-}" ] ; then
    BASHEXE="$(command -v bash)"
    if [ -n "${BASHEXE}" ] ; then
      exec "${BASHEXE}" "${0}" "$@"
    fi
  else
    # shellcheck disable=3044
    shopt -s nullglob
    # shellcheck disable=3044
    shopt -s globstar
    # shellcheck disable=3044
    shopt -s extglob
  fi
fi

entrypoint() {
  # Allow this, our target is dash/busybox
  # shellcheck disable=SC2039
  local A

  if [ "${GITHUB_ACTIONS:-}" = "true" ] ; then
    # problem matchers need to be run from the host
    find /app/ -maxdepth 1 -type f -name '*-problem-matcher.json' -exec cp {} "$PWD" \;
    find . -maxdepth 1 -type f -name '*-problem-matcher.json' \( -exec echo -n '::add-matcher::' \; -a -exec basename {} \;  \)

    # GITHUB escapes too much, so 'unescape' it ;-(
    # shellcheck disable=SC2068
    exec ${@}
  fi

  # CI is set, just execute the arguments
  if [ -n "${CI:-}" ] ; then
    exec "${@}"
  fi

  # workplace detecting
  readonly A="${1:-}"
  if [ -n "${A}" ] && [ -n "$(command -v "${A}" 2>/dev/null)" ] ; then
    exec "${@}"
  else
    exec "${DEFAULTCMD}" "${@}"
  fi
}

entrypoint "$@"
