FROM windriver/ubuntu1804_64

USER root

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && locale-gen \
  && apt-get update -y \
  && apt-get install -y libelf-dev bison flex bc kmod xmlstarlet jq libssl-dev

RUN usermod -l jenkins wrlbuild
