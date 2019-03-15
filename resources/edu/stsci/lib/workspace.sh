shutil_ws_path() {
    echo "${WORKSPACE}"
}

shutil_ws_search() {
    local pattern
    pattern="${1-*}"

    for f in $(find $(shutil_ws_path) -type f -name "${pattern}" | xargs)
    do
        echo "${f}"
    done
}

shutil_ws_file_exists() {
    local filename
    filename="${1}"
    if [[ -z ${filename} ]]; then
        echo "exists_in_ws() missing argument: filename" >&2
        echo 0
        return
    fi

    ([[ -n $(shutil_ws_search "${filename}") ]] && echo 1) || echo 0
}

