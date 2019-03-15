# source-only
if [[ -z ${_shutil_init_protect} ]] || [[ ${_shutil_init_protect} == 0 ]]; then

export EDU_STSCI_SHUTIL_ROOT=$(python -c "import os.path; print(os.path.abspath(os.path.dirname('${BASH_SOURCE[0]}')))")
export EDU_STSCI_SHUTIL_INCLUDE="${EDU_STSCI_SHUTIL_ROOT}/include"
export EDU_STSCI_SHUTIL_LIB="${EDU_STSCI_SHUTIL_ROOT}/lib"

# Remove this
export WORKSPACE=$EDU_STSCI_SHUTIL_ROOT

shutil_init() {
    local lib
    for lib in "${EDU_STSCI_SHUTIL_LIB}"/*.sh
    do
        echo "Loading shutil library: $(basename ${lib})"
        source "${lib}"
    done
}

shutil_init
export _shutil_init_protect=1

fi  # _shutil_init_protect

