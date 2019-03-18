shutil_ws_path() {
    echo "${WORKSPACE}"
}

shutil_ws_search() {
    local ftype pattern
    ftype="${ftype-f}"
    pattern="${1-*}"

    for f in $(find $(shutil_ws_path) -type "${ftype}" -name "${pattern}" | xargs)
    do
        echo "${f}"
    done
}

shutil_ws_file_exists() {
    local filename
    filename="${1}"
    if [[ -z ${filename} ]]; then
        echo "shutil_ws_file_exists: missing argument: filename" >&2
        echo 0
        return
    fi

    ([[ -n $(shutil_ws_search "${filename}") ]] && echo 1) || echo 0
}

shutil_ws_dir_exists() {
    local filename
    filename="${1}"
    if [[ -z ${filename} ]]; then
        echo "shutil_ws_dir_exists: missing argument: filename" >&2
        echo 0
        return
    fi

    ([[ -n $(shutil_ws_search "${filename}") ]] && echo 1) || echo 0
}
