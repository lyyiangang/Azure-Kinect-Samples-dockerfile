# no cudnn here
# warning: base image name hardcoded, check it matches NAME_02 from source.sh
FROM azure_kinect:02_eula

RUN apt-get update && apt-get install -y \
    build-essential \
    rsync \
    curl \
    wget \
    htop \
    git \
    openssh-server \
    nano \
    cmake  \
    pkg-config \
    ninja-build \
    doxygen \
    clang \
    gcc-multilib \
    g++-multilib \
    python3 \
    git-lfs \
    nasm \
    cmake \
    libgl1-mesa-dev \
    libsoundio-dev \
    libvulkan-dev \
    libx11-dev \
    libxcursor-dev \
    libxinerama-dev \
    libxrandr-dev \
    libusb-1.0-0-dev \
    libssl-dev \
    libudev-dev \
    mesa-common-dev \
    uuid-dev \
        build-essential cmake pkg-config unzip yasm git checkinstall \
        libturbojpeg0-dev \
        libavcodec-dev libavformat-dev libswscale-dev libavresample-dev \
        libjpeg-dev libpng-dev libtiff-dev \
        libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
        libxvidcore-dev x264 libx264-dev libfaac-dev libmp3lame-dev libtheora-dev \
        libfaac-dev libmp3lame-dev libvorbis-dev \
        libgtk-3-dev \
        libtbb-dev \
        libatlas-base-dev gfortran \
        libprotobuf-dev protobuf-compiler \
        libgoogle-glog-dev libgflags-dev \
        libgphoto2-dev libeigen3-dev libhdf5-dev doxygen

    # lyy
    # freeglut3-dev

# fixuid to allow user to set container's user/group id
# don't forget to set ENTRYPOINT and/or CMD
ARG USERNAME=docker
# RUN apt-get update && apt-get install -y sudo curl && \
#     addgroup --gid 1000 $USERNAME && \
#     adduser --uid 1000 --gid 1000 --disabled-password --gecos '' $USERNAME && \
#     adduser $USERNAME sudo && \
#     echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
#     USER=$USERNAME && \
#     GROUP=$USERNAME && \
#     curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.4/fixuid-0.4-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
#     chown root:root /usr/local/bin/fixuid && \
#     chmod 4755 /usr/local/bin/fixuid && \
#     mkdir -p /etc/fixuid && \
#     printf "user: $USER\ngroup: $GROUP\n" > /etc/fixuid/config.yml

# conda
RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda3-py37_4.8.3-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc
# this version of miniconda's /opt/conda/bin provides pip = pip3 = pip3.7, python = python3 = python3.7
ENV PATH /opt/conda/bin:$PATH
ENV PIPINSTALL "pip install -i  https://pypi.doubanio.com/simple/  --trusted-host pypi.doubanio.com  "
RUN ${PIPINSTALL} --upgrade pip && ${PIPINSTALL} numpy==1.19.2

# azure sdk
RUN git config --global https.proxy "https://172.17.0.1:8889" && git config --global http.proxy "http://172.17.0.1:8889"


ENV HTTP_PROXY="http://172.17.0.1:8889"
ENV HTTPS_PROXY="https://172.17.0.1:8889"

RUN cd /opt && \
    wget -O opencv.zip https://github.com/opencv/opencv/archive/4.2.0.zip && \
    wget -O opencv_contrib.zip https://github.com//opencv/opencv_contrib/archive/4.2.0.zip && \
    unzip opencv.zip && \
    unzip opencv_contrib.zip

COPY VTK-8.2.0.zip /
RUN apt-get install -y libxt-dev && cd / && unzip VTK-8.2.0.zip && mkdir -p VTK-8.2.0/build && cd VTK-8.2.0/build && cmake .. && make -j3 install

# just to fix the bug in https://github.com/opencv/opencv_contrib/issues/1301
ENV CURL="curl -x ${HTTP_PROXY} "
RUN mkdir -p /opt/opencv-4.2.0/.cache/xfeatures2d/  && mkdir -p /opt/opencv-4.2.0/.cache/vgg && \
    cd /opt/opencv-4.2.0/.cache/xfeatures2d/ && \
    mkdir boostdesc && cd boostdesc &&\
    ${CURL} https://raw.githubusercontent.com/opencv/opencv_3rdparty/34e4206aef44d50e6bbcd0ab06354b52e7466d26/boostdesc_lbgm.i > 0ae0675534aa318d9668f2a179c2a052-boostdesc_lbgm.i &&\
    ${CURL} https://raw.githubusercontent.com/opencv/opencv_3rdparty/34e4206aef44d50e6bbcd0ab06354b52e7466d26/boostdesc_binboost_256.i > e6dcfa9f647779eb1ce446a8d759b6ea-boostdesc_binboost_256.i &&\
    ${CURL} https://raw.githubusercontent.com/opencv/opencv_3rdparty/34e4206aef44d50e6bbcd0ab06354b52e7466d26/boostdesc_binboost_128.i > 98ea99d399965c03d555cef3ea502a0b-boostdesc_binboost_128.i &&\
    ${CURL} https://raw.githubusercontent.com/opencv/opencv_3rdparty/34e4206aef44d50e6bbcd0ab06354b52e7466d26/boostdesc_binboost_064.i > 202e1b3e9fec871b04da31f7f016679f-boostdesc_binboost_064.i &&\
    ${CURL} https://raw.githubusercontent.com/opencv/opencv_3rdparty/34e4206aef44d50e6bbcd0ab06354b52e7466d26/boostdesc_bgm_hd.i > 324426a24fa56ad9c5b8e3e0b3e5303e-boostdesc_bgm_hd.i &&\
    ${CURL} https://raw.githubusercontent.com/opencv/opencv_3rdparty/34e4206aef44d50e6bbcd0ab06354b52e7466d26/boostdesc_bgm_bi.i > 232c966b13651bd0e46a1497b0852191-boostdesc_bgm_bi.i &&\
    ${CURL} https://raw.githubusercontent.com/opencv/opencv_3rdparty/34e4206aef44d50e6bbcd0ab06354b52e7466d26/boostdesc_bgm.i > 0ea90e7a8f3f7876d450e4149c97c74f-boostdesc_bgm.i &&\
    mkdir -p ../vgg  && cd ../vgg &&\
    ${CURL} https://raw.githubusercontent.com/opencv/opencv_3rdparty/fccf7cd6a4b12079f73bbfb21745f9babcd4eb1d/vgg_generated_120.i > 151805e03568c9f490a5e3a872777b75-vgg_generated_120.i &&\
    ${CURL} https://raw.githubusercontent.com/opencv/opencv_3rdparty/fccf7cd6a4b12079f73bbfb21745f9babcd4eb1d/vgg_generated_64.i > 7126a5d9a8884ebca5aea5d63d677225-vgg_generated_64.i &&\
    ${CURL} https://raw.githubusercontent.com/opencv/opencv_3rdparty/fccf7cd6a4b12079f73bbfb21745f9babcd4eb1d/vgg_generated_48.i > e8d0dcd54d1bcfdc29203d011a797179-vgg_generated_48.i &&\
    ${CURL} https://raw.githubusercontent.com/opencv/opencv_3rdparty/fccf7cd6a4b12079f73bbfb21745f9babcd4eb1d/vgg_generated_80.i > 7cd47228edec52b6d82f46511af325c5-vgg_generated_80.i 

ENV HTTP_PROXY=""
ENV HTTPS_PROXY=""
        # -D VTK_DIR=/home/bst/lyy/ \
RUN cd /opt/opencv-4.2.0 && \
    mkdir -p build && cd build && \
    cmake \
        -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D INSTALL_PYTHON_EXAMPLES=OFF \
        -D INSTALL_C_EXAMPLES=OFF \
        -D WITH_TBB=ON \
        -D WITH_CUDA=OFF \
        -D BUILD_opencv_cudacodec=OFF \
        -D ENABLE_FAST_MATH=1 \
        -D CUDA_FAST_MATH=1 \
        -D WITH_CUBLAS=0 \
        -D WITH_V4L=ON \
        -D WITH_QT=OFF \
        -D WITH_VTK=ON \
        -D BUILD_opencv_viz=ON \
        -D BUILD_opencv_rgbd=ON \
        -D WITH_OPENGL=ON \
        -D BUILD_TESTS=OFF \
        -D OPENCV_GENERATE_PKGCONFIG=ON \
        -D OPENCV_PC_FILE_NAME=opencv.pc \
        -D OPENCV_ENABLE_NONFREE=ON \
        -D BUILD_opencv_java=OFF \
        -D BUILD_opencv_python2=OFF \
        -D BUILD_opencv_python3=OFF \
        -D PYTHON_INCLUDE_DIR=$(python -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
        -D PYTHON_LIBRARY=$(python -c "from distutils.sysconfig import get_python_lib, get_python_version; import os.path as osp; lib_dp=osp.abspath(osp.join(get_python_lib(), '..', '..')); lib_fp=osp.join(lib_dp, f'libpython{get_python_version()}m.so'); print(lib_fp);") \
        -D PYTHON_PACKAGES_PATH=$(python -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
        -D OPENCV_PYTHON_INSTALL_PATH=$(python -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
        -D PYTHON_EXECUTABLE=$(which python) \
        -D OPENCV_EXTRA_MODULES_PATH="../../opencv_contrib-4.2.0/modules" \
        -D BUILD_EXAMPLES=OFF \
        .. && \
        make -j3 && make install

# nlohmann_json for pyk4a
RUN cd /opt && \
    git clone --recursive https://github.com/nlohmann/json ./nlohmann_json && \
    cd nlohmann_json && \
    mkdir build && cd build && \
    cmake .. && \
    cmake --build . -- -j$(nproc) && \
    make install
# # pyk4a: python wrapper for azure kinect streaming
# COPY extern/pyk4a /opt/extern/pyk4a
# RUN cd /opt/extern/pyk4a && ./setup.sh
# RUN apt install -y usbutils
# # prevent 100% cpu utilization bug when using kinect body tracking
# ENV OMP_WAIT_POLICY Passive

# # multiprocessing_pipeline to run blocks in parallel processes
# COPY extern/multiprocessing_pipeline /opt/multiprocessing_pipeline
# RUN cd /opt/multiprocessing_pipeline && ./setup.sh

ENV HTTP_PROXY="http://172.17.0.1:8889"
ENV HTTPS_PROXY="https://172.17.0.1:8889"
RUN git clone --recursive https://github.com/microsoft/Azure-Kinect-Sensor-SDK.git /opt/azure-sdk && \
    cd /opt/azure-sdk && \
    git checkout 17b644560ce7b4ee7dd921dfff0ae811aa54ede6 && \
    mkdir -p /etc/udev/rules.d && \
    cp ./scripts/99-k4a.rules /etc/udev/rules.d/ && \
    mkdir build && cd build && \
    cmake .. -GNinja && \
    ninja

############## Install from extern folder ##############


# USER $USERNAME:$USERNAME
# ENTRYPOINT ["fixuid", "-q"]
# CMD ["fixuid", "-q", "bash"]
ENV HTTP_PROXY=""
ENV HTTPS_PROXY=""

WORKDIR /src
