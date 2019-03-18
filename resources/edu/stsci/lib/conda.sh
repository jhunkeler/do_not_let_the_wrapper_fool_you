#!/bin/bash
source ${EDU_STSCI_SHUTIL_INCLUDE}/die.sh
source ${EDU_STSCI_SHUTIL_INCLUDE}/compat.sh
source ${EDU_STSCI_SHUTIL_INCLUDE}/conda.sh


shutil_conda_exists() {
    retval=0
    if ! type -p conda ; then
        retval=1
    elif [[ $(type -t conda) != function ]]; then
        retval=2
    fi
    echo ${retval}
}

shutil_conda_infect() {
    if [[ $(shutil_conda_exists) != 0 ]]; then
        shutil_die "shutil_conda_infect: cannot dump environment key pairs"
    fi
    printenv | sort
}

shutil_conda_installer() {
    local arch platform prefix retval script url version

    arch=$(uname -m)
    platform=$(uname -s)

    case "${arch}" in
        i[0-9]+)
            echo "shutil_conda_installer: caution: 32-bit architecture detected. Continue at your peril." >&2
            arch=x86
            ;;
        *)
            ;;
    esac

    case "${platform}" in
        Darwin)
            platform=MacOSX
            ;;
        *)
            ;;
    esac

    version="${1}"
    prefix="${2}"
    script="Miniconda3-${version}-${platform}-${arch}.sh"
    url="${_URL_CONTINUUMIO_MINICONDA}/${script}"

    if [[ ! -f ${script} ]]; then
        shutil_compat_fetch "${url}"
    fi

    if [[ -d ${prefix} ]]; then
        echo "shutil_conda_installer: warning: ${prefix} exists, installation skipped." >&2
        return
    fi

    bash ./"${script}" -b -p "${prefix}"
    retval=$?

    if [[ ${retval} != 0 ]]; then
        exit ${retval}
    fi
}

shutil_conda_withenv() {
    if [[ $(shutil_conda_exists) != 0 ]]; then
        shutil_die "shutil_conda_withenv: unable to execute: conda must be on \$PATH or activated via 'conda' function"
    fi
    local commands environ exe key
    environ=base
    commands=()

    while [[ $# != 0 ]]
    do
        key="${1}"
        case ${key} in
            -n|--name)
                environ="${2}"
                shift 2
                ;;
            *)
                commands+=("${1}")
                shift
                ;;
        esac
    done

    exe='source'
    if [[ $(type -t conda) == function ]]; then
        exe='conda'
    fi

    ${exe} activate "${environ}"
    "${commands[@]}"
}

shutil_conda_root() {
    if [[ $(shutil_conda_exists) != 0 ]]; then
        shutil_die "shutil_conda_root: cannot get root directory"
    fi
    local version
    version=$(shutil_conda_withenv conda --version)

    # Return version triplet without "conda"
    echo "${version#conda }"
}

shutil_conda_version() {
    if [[ $(shutil_conda_exists) != 0 ]]; then
        shutil_die "shutil_conda_version: cannot get version"
    fi
    local version
    version=$(shutil_conda_withenv conda --version)

    # Return version triplet without "conda"
    echo "${version#conda }"
}

shutil_conda_init_from_prefix() {
    local prefix profile target
    prefix="${1}"
    if [[ ! -d ${prefix}/bin ]]; then
        shutil_die "shutil_conda_init_from_prefix: expected conda root, but got '${prefix}'"
    fi

    profile="${prefix}"/etc/profile.d/conda.sh

    if [[ -f ${profile} ]]; then
        source "${profile}"
        conda activate
    else
        export PATH="${prefix}/bin:${PATH}"
        source activate base
    fi
}

shutil_conda_env_dump() {
    if [[ $(shutil_conda_exists) != 0 ]]; then
        shutil_die "shutil_conda_env_dump: unable to execute: conda must be on \$PATH or activated via 'conda' function"
    fi
    local commands environ key output use_yaml use_explicit
    environ=base
    output=environment
    commands=()

    while [[ $# != 0 ]]
    do
        key="${1}"
        case ${key} in
            -n|--name)
                environ="${2}"
                shift 2
                ;;
            -y|--yaml)
                use_yaml=1
                shift
                ;;
            -e|--explicit)
                use_explicit=1
                shift
                ;;
            -o|--output)
                output="${2}"
                shift 2
                ;;
            *)
                commands+=("${1}")
                shift
                ;;
        esac
    done

    local retval
    if [[ -n ${use_yaml} ]]; then
        shutil_conda_withenv -n "${environ}" conda env export --name "${environ}" --file "${output}".yml "${commands[@]}"
        retval=$?
        if [[ $? == 0 ]]; then
            sed -e '/^name:/d' -e '/^prefix:/d' <<< $(< ${output}.yml) > "${output}".yml
        fi
    elif [[ -n ${use_explicit} ]]; then
        shutil_conda_withenv -n "${environ}" conda list --name "${environ}" --explicit > "${output}".txt "${commands[@]}"
        retval=$?
    else
        shutil_die "shutil_conda_env_dump: unknown operation: ${commands[@]}"
    fi

    if [[ ${retval} != 0 ]]; then
        shutil_die "shutil_conda_env_dump: operation failed: ${@}"
    fi
}

set -x

shutil_conda_installer latest ~/Downloads/lesigh
shutil_conda_init_from_prefix ~/Downloads/lesigh
#shutil_conda_env_dump --yaml
#shutil_conda_env_dump --explicit
#cat environment.*
#export PATH=~/Downloads/miniconda3/bin:$PATH
#source ~/Downloads/miniconda3/etc/profile.d/conda.sh
#conda activate

#if [[ $(shutil_conda_exists) != 0 ]]; then
#    echo "nope"
#else
#    echo "exists"
#fi

#shutil_conda_withenv conda --help
#shutil_conda_version
#shutil_conda_infect
