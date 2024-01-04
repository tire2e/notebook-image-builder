# ---------- arguments ----------

BASE_IMG ?= nvcr.io/nvidia/cuda:12.2.2-base-ubuntu22.04

TAG ?= latest
IMAGE_NAME ?= tir-custom-image
REGISTRY ?=
DISABLE_NOTEBOOK ?= false

PLATFORM_ARCH = linux/amd64


# ---------- helpers ----------

IMAGE = ${IMAGE_NAME}:${TAG}

ifdef REGISTRY
IMAGE_TO_PUSH = ${REGISTRY}/${IMAGE}
else
IMAGE_TO_PUSH = ${IMAGE}
endif


# ---------- make rules ----------

docker-build:
	@echo "\nBuilding docker image: ${IMAGE} ... \n"
	@docker build \
		--platform=${PLATFORM_ARCH} \
		--build-arg BASE_IMG=${BASE_IMG} \
		--build-arg DISABLE_NOTEBOOK=${DISABLE_NOTEBOOK} \
		--build-arg PLATFORM_ARCH=${PLATFORM_ARCH} \
		-t ${IMAGE} \
		-f Dockerfile .
	@echo "\nSuccessfully built the docker image: ${IMAGE}\n"


--docker-tag:
	@docker tag ${IMAGE} ${IMAGE_TO_PUSH}


docker-push: --docker-tag
	@echo "\nPushing docker image: ${IMAGE_TO_PUSH} ... \n"
	@docker push ${IMAGE_TO_PUSH}
	@echo "\nSuccessfully pushed the docker image: ${IMAGE_TO_PUSH}\n"
