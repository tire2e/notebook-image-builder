# TIR Notebook Image Builder

## About
TIR's **Notebook Image Builder** is a utility tool to make your custom docker images compatible with E2E's TIR Platform, particularly TIR Notebooks. 

This is particularly useful for users who have custom images with them or want to build custom images and use these images to launch Notebooks on TIR.

TIR provides some pre-built images to users that they can choose to launch Notebooks. These include PyTorch, TensorFlow, Transformers, RAPIDS, and many more. 

But many a times, these images and their versions might not cater to your needs and requirements. You would rather want to use your own custom images or build a new image with your custom packages that you can use to launch TIR Notebooks. But directly using these images will not work for you as your custom image might not be compatible with TIR Notebooks. This is because TIR Notebooks require some basic modules, packages and custom configurations to run and work effectively.

Hence, for you to be able to use your own custom images to launch Notebooks, you need to make your images compatible to TIR using this **Notebook Image Builder** utility tool.


## Making images compatible with TIR Notebooks

### Prerequisites
* **Docker Engine**: Ensure you have Docker Engine installed on your local system
* **Make**: Ensure GNU make utility is installed on your local system
* A Docker Image that you want to make compatible with TIR Notebooks
* E2E Container Registry setup on TIR

### Steps to make your image compatible with TIR Notebooks
1. Clone this repository on your local system
    ```bash
    git clone https://github.com/tire2e/notebook-image-builder.git
    ```
    ```bash
    cd notebook-image-builder/
    ```

2. Generate a new TIR compatible Image and push it to E2E Container Registry
    - Run the ``generate_image.sh`` script to generate a new image that extends your custom image and is compatible with TIR Notebooks
        ```bash
        ./generate_image.sh -b BASE_IMAGE[:TAG] -i NEW_IMAGE_NAME -t IMAGE_TAG
        ```
        This builds a new TIR Compatible Image namely, NEW_IMAGE_NAME:IMAGE_TAG from your custom image, BASE_IMAGE:TAG.\
        You can list out the same using ``docker images`` command.

    - To build the image and also push it to your E2E Container Registry simultaneously,
        ```bash
        ./generate_image.sh -b BASE_IMAGE[:TAG] -i NEW_IMAGE_NAME -t IMAGE_TAG -P -u USERNAME
        ```
        Here, USERNAME is your username to the E2E Container Registry. ``-u`` flag can be omitted if you are already logged in to the E2E Container Registry. Ensure you include your registry namespace in the image repository name (i.e., NEW_IMAGE_NAME) to enable image push.

    - To see the list of available flags with their usage,
        ```bash
        ./generate_image.sh -h
        ```
        You will get an output similar to the one below:
        ```
        Usage: ./generate_image.sh [OPTIONS]

        -h,                            Display help

        -b,  <string>   (required)     Sets the base image repository (with tag) to be used, including the self-hosted registry path, if any. If the base image is in a self-hosted or private registry, ensure you are logged in to that registry to enable image pull

        -i,  <string>   (required)     Sets the name of the custom image repository being built.

        -t,  <string>                  Sets the tag for the custom image repository. Defaults to 'latest'

        -P,                            Pushes the image repository to your E2E Container Registry

        -u,  <string>                  Sets the username to the E2E Container Registry for login. Required if -P flag is set & you aren't logged in to your E2E Container Registry

        -n                             Disables the notebook & notebook specific features
        ```

3. That's it! Your TIR compatible image has been built and pushed to E2E Container Registry succesfully. Now this Image can be used to launch Notebooks on TIR Platform.

#### An example to show usage of TIR Notebook Image Builder

* You have a custom image with you, say **ubuntu:22.04** and want to make it TIR compatible.

* You want your new image to be named as **tir-custom-image** with tag **v1**

* After generating the new image, you want to push it to E2E Container Registry with namespace **my-project** & username **abc@xyz.com**

* So, command to generate your new image would be:
    ```bash
    ./generate_image.sh -b ubuntu:22.04 -i my-project/tir-custom-image -t v1 -P -u abc@xyz.com
    ```
    During the process, you will be prompted to enter the *Password* for your E2E Container Registry namespace. Once entered, the image will be pushed to your registry and you will be able to launch Notebook using your custom image on TIR.
