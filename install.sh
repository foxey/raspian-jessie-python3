#!/usr/bin/bash

PYTHON_VERSION=${PYTHON_VERSION:-3.8.3}

echo "Installing prerequisites for Python ${PYTHON_VERSION} installation"

sudo apt-key adv --recv-key --keyserver keyserver.ubuntu.com 8B48AD6246925553
sudo apt-key adv --recv-key --keyserver keyserver.ubuntu.com 7638D0442B90D010

sudo sh -c 'echo deb http://archive.debian.org/debian jessie-backports main contrib non-free > /etc/apt/sources.list.d/jessie-backports.list'
sudo sh -c 'echo Acquire::Check-Valid-Until \"false\"\; > /etc/apt/apt.conf.d/01allowexpired'

sudo apt update
sudo apt-get install -y make build-essential zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncurses5-dev  libncursesw5-dev xz-utils tk-dev

sudo apt-get install -t jessie-backports -y openssl libssl-dev

if [ "${INSTALL_PYTHON}" = "manual" ]; then
    echo "Downloading Python ${PYTHON_VERSION} sources"
    wget -qO - https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz |tar xzf -
    cd Python-${PYTHON_VERSION}
    echo "Building Python ${PYTHON_VERSION}"
    ./configure --enable-optimizations
    make -j4
    echo 'Install with "sudo make altinstall"'
else
    echo "Getting pyenv from Github"
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    echo "Activating pyenv in .bashrc"
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc && echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    echo "Building Python ${PYTHON_VERSION}"
    pyenv install ${PYTHON_VERSION}
    pyenv versions
fi