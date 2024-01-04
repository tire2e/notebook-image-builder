#!/bin/bash

# make installation check
if !([[ $(command -v make) ]]); then
    echo -e "\nCommand 'make' not found. Kindly install it first and then continue\n"
    exit 1
fi

# script usage/help
usage() { 
cat << EOF

Usage: ./generate_image.sh [OPTIONS]

-h,                            Display help

-b,  <string>   (required)     Sets the base image repository (with tag) to be used, including the self-hosted registry path, if any. If the base image is in a self-hosted or private registry, ensure you are logged in to that registry to enable image pull

-i,  <string>   (required)     Sets the name of the custom image repository being built.

-t,  <string>                  Sets the tag for the custom image repository. Defaults to 'latest'

-P,                            Pushes the image repository to your E2E Container Registry

-u,  <string>                  Sets the username to the E2E Container Registry for login. Required if -P flag is set & you aren't logged in to your E2E Container Registry

-n                             Disables the notebook & notebook specific features

EOF
}

# build docker image
dockerBuild() {
    build_cmd="docker-build BASE_IMG=${base_img} IMAGE_NAME=${custom_img_name} TAG=${custom_img_tag}"
    if !([ -z "${registry}" ]); then
        build_cmd+=" REGISTRY=${registry}"
    fi
    if [ ${disable_notebook} = true ]; then
        build_cmd+=" DISABLE_NOTEBOOK=${disable_notebook}"
    fi
    make -C notebook-base-image/ -s ${build_cmd}
}

# push docker image
dockerPush() {
    push_cmd="docker-push IMAGE_NAME=${custom_img_name} TAG=${custom_img_tag}"
    if !([ -z "${registry}" ]); then
        push_cmd+=" REGISTRY=${registry}"
    fi
    make -C notebook-base-image/ -s ${push_cmd}
}


# define constants
E2E_CR_KEY=e2e_cr
E2E_CR_HOST=registry.e2enetworks.net

# initialise vars
custom_img_tag=latest
push_img_to_repo=false
registry=${E2E_CR_HOST}  # currently defaults to E2E CR
disable_notebook=false

# process input args
while getopts "b:i:t:Pu:nh" option; do
    case "${option}" in
        b)
            base_img=${OPTARG}
            ;;
        i)
            custom_img_name=${OPTARG}
            ;;
        t)
            custom_img_tag=${OPTARG}
            ;;
        P)
            push_img_to_repo=true
            ;;
        u)
            username=${OPTARG}
            ;;
        n)
            disable_notebook=true
            ;;
        h)
            usage
            exit 0
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${base_img}" ] || [ -z "${custom_img_name}" ]; then
    usage
    exit 1
fi

echo -e "\n\nProvided Base Image Repository = ${base_img}\n"


# perform actions
dockerBuild

if [ ${push_img_to_repo} = true ]; then
    if !([ -z "${username}" ]); then
        echo -e "\nEnter your Registry Credentials for Login...\nUsername: ${username}"
        docker login ${registry} -u ${username}
    fi
    dockerPush
fi
