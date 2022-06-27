# no cudnn here
# FROM nvidia/cudagl:10.2-devel-ubuntu18.04
FROM ubuntu:18.04

ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt install -y apt-transport-https ca-certificates gnupg
RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse\n\
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse\n\
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse\n\
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse\n\
deb http://archive.ubuntu.com/ubuntu bionic main universe restricted multiverse\n\
deb [arch=amd64] https://packages.microsoft.com/ubuntu/18.04/prod bionic main\n\
" > /etc/apt/sources.list &&     apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EB3E94ADBE1229CF

ENV HTTP_PROXY="http://172.17.0.1:8889"
ENV HTTPS_PROXY="https://172.17.0.1:8889"
    # echo "deb [arch=amd64] https://packages.microsoft.com/ubuntu/18.04/prod bionic main" >> /etc/apt/sources.list && \
ENV CURL="curl -x ${HTTP_PROXY} "
RUN apt-get update && \
    apt-get install -y curl && \
    ${CURL} https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    env DEBIAN_FRONTEND=noninteractive && \
    echo 'libk4a1.3 libk4a1.3/accepted-eula-hash string 0f5d5c5de396e4fee4c0753a21fee0c1ed726cf0316204edda484f08cb266d76' | debconf-set-selections && \
    echo 'libk4a1.3 libk4a1.3/accept-eula boolean true' | debconf-set-selections && \
    apt-get install -y libk4a1.3 libk4a1.3-dev

    # # this does not work, so we have to accept eula manually
    # echo 'libk4abt1.0 libk4abt1.0/accepted-eula-hash string 0f5d5c5de396e4fee4c0753a21fee0c1ed726cf0316204edda484f08cb266d76' | debconf-set-selections && \
    # echo 'libk4abt1.0 libk4abt1.0/accept-eula boolean true' | debconf-set-selections && \
    # apt-get install -y libk4abt1.0 libk4abt1.0-dev

COPY install_k4abt.sh /opt/install_k4abt.sh
ENV HTTP_PROXY=""
ENV HTTPS_PROXY=""
WORKDIR /opt
