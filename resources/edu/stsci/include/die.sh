[[ -n ${_shutil_die_header} ]] && return || readonly _shutil_die_header=1

shutil_die() {
    echo "shutil_die: ${1-no_error_specified_by_caller}" >&2
    exit 1
}
