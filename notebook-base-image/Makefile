# ---------- arguments ----------

BASE_IMG ?= nvcr.io/nvidia/cuda:12.2.2-base-ubuntu22.04

TAG ?= latest
IMAGE_NAME ?= tir-custom-image
REGISTRY ?=
DISABLE_NOTEBOOK ?= false

PLATFORM_ARCH = linux/amd64


# ---------- helpers ----------

ifdef REGISTRY
IMAGE = ${REGISTRY}/${IMAGE_NAME}:${TAG}
else
IMAGE = ${IMAGE_NAME}:${TAG}
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


docker-push:
	@echo "\nPushing docker image: ${IMAGE} ... \n"
	@docker push ${IMAGE}
	@echo "\nSuccessfully pushed the docker image: ${IMAGE}\n"
