ARG BASE_IMG
ARG PLATFORM_ARCH
FROM --platform=${PLATFORM_ARCH} ${BASE_IMG}

USER root

ARG DISABLE_NOTEBOOK
ARG MINIO_CLIENT_ARCH="linux-amd64"
ARG S6_ARCH="amd64"
ARG S6_VERSION=v2.2.0.3

# common environment variables
ENV DISABLE_NB ${DISABLE_NOTEBOOK}
ENV HOME /home/jovyan
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV NB_PREFIX /
ENV SHELL /bin/bash
ENV TF_CPP_MIN_LOG_LEVEL 2

# ports
ENV GRADIO_PORT 7860
ENV JUPYTERLAB_PORT 8888
ENV SSH_PORT 22
ENV TENSORBOARD_PORT 6006


# set shell to bash
SHELL ["/bin/bash", "-c"]

RUN mkdir -p ${HOME}

RUN export DEBIAN_FRONTEND=noninteractive \
   && apt-get -yq update \
   && apt-get -yq install --no-install-recommends \
      apt-transport-https \
      bash \
      bzip2 \
      ca-certificates \
      curl \
      ffmpeg \
      git \
      gnupg \
      gnupg2 \
      locales \
      lsb-release \
      nano \
      python3-pip \
      s3cmd \
      software-properties-common \
      tzdata \
      unzip \
      vim \
      wget \
      zip \
   && apt-get clean \
   && rm -rf /var/lib/apt/lists/*


# set locale configs
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
   && locale-gen


# install - s6 overlay
RUN curl -sL "https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-${S6_ARCH}-installer" -o /tmp/s6-overlay-${S6_VERSION}-installer \
   && chmod +x /tmp/s6-overlay-${S6_VERSION}-installer \
   && /tmp/s6-overlay-${S6_VERSION}-installer / \
   && rm /tmp/s6-overlay-${S6_VERSION}-installer


# install and configure - open ssh
RUN echo "**** install open ssh dependencies ****" \
   && apt-get update \
   && apt-get install  --upgrade --assume-yes curl logrotate netcat-openbsd nano sudo \
   && echo "**** install openssh-server ****" \
   && apt-get install --assume-yes openssh-server openssh-client openssh-sftp-server \
   && echo "**** setup openssh environment ****" \
   && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config  \
   && sed -i 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config \
   && echo "*** restart sshd ****" \
   && /etc/init.d/ssh restart


# direct users to /home/jovyan on doing ssh as root user
RUN echo -e "\n# direct users to ${HOME} on doing ssh as root user" >> /root/.bashrc \
   && echo -e "cd ${HOME}" >> /root/.bashrc


# install - MinIO Client (mc)
RUN curl -sL "https://dl.min.io/client/mc/release/${MINIO_CLIENT_ARCH}/mc" -o /usr/local/bin/mc \
   && chmod +x /usr/local/bin/mc


# install - requirements.txt
RUN pip3 install --upgrade pip
COPY requirements.txt /tmp/requirements.txt
COPY nb_requirements.txt /tmp/nb_requirements.txt

RUN python3 -m pip install -r /tmp/requirements.txt --quiet --no-cache-dir

RUN \
   if [ ${DISABLE_NB} = false ]; then \
      python3 -m pip install -r /tmp/nb_requirements.txt --quiet --no-cache-dir \
      && jupyter nbextension enable --py widgetsnbextension \
   ; fi

RUN rm -f /tmp/requirements.txt \
   && rm -f /tmp/nb_requirements.txt


COPY s6/ /etc

EXPOSE ${JUPYTERLAB_PORT} ${SSH_PORT} ${TENSORBOARD_PORT} ${GRADIO_PORT}
WORKDIR ${HOME}
ENTRYPOINT ["/init"]
