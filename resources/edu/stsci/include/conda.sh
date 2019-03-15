[[ -n ${_shutil_conda_header} ]] && return || readonly _shutil_conda_header=1

declare -r _URL_CONTINUUMIO=https://repo.continuum.io
declare -r _URL_CONTINUUMIO_MINICONDA=${_URL_CONTINUUMIO}/miniconda
declare -r _URL_CONTINUUMIO_ANACONDA=${_URL_CONTINUUMIO}/archive
