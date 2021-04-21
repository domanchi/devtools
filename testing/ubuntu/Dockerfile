FROM ubuntu:latest
RUN apt-get -y update
RUN apt-get -y install \
    python3 \
    sudo \
    git \
    curl

# Create a user, but allow it to access sudo without a password.
RUN useradd --create-home --shell /bin/bash -g users -G root domanchi
RUN echo '%root ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER domanchi:users
WORKDIR /home/domanchi
