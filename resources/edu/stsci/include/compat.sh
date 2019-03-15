#!/bin/bash
[[ -n ${_shutil_compat_header} ]] && return || readonly _shutil_compat_header=1

declare -r _shutil_compat_sed_str='s|%s|%s|%s'
shutil_compat_get_arch() {
    : # pass
}

shutil_compat_get_platform() {
    : # pass
}

shutil_compat_replace() {
    local mod tmp
    mod=''
    args=()

    while [[ $# != 0 ]]
    do
        key="${1}"
        case "${key}" in
            --global|-g)
                mod='g'
                shift
                ;;
            *)
                args+=("${1}")
                shift
        esac
    done

    [[ ${#args[@]} != 3 ]] && echo "shutil_compat_replace [-g] {pattern1} {pattern2} {file}" && exit 1

    tmp=$(mktemp)
    sed -e $(printf ${_shutil_compat_sed_str} ${args[1]} ${args[2]} ${mod}) < ${args[0]} > ${tmp}
    mv ${tmp} ${args[0]}
}

