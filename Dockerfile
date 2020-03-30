FROM ubuntu:18.04
MAINTAINER HoriThe3rd

RUN apt update && apt install -y \
	build-essential \
	cmake \
	wget \
	doxygen \
    libgtk-3-dev \
    python-dev \
    python-numpy \
    ffmpeg \
    libwebp-dev \
    pkg-config \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libtbb2 \
    libtbb-dev \
    libdc1394-22 \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libdc1394-22-dev \
	&& apt clean \
	&& rm -rf /var/lib/apt/lists/*

# Download opencv sources
RUN mkdir -p /usr/local/src/opencv
WORKDIR /usr/local/src/opencv
RUN wget -O ./opencv-3.4.3.tar.gz https://github.com/opencv/opencv/archive/3.4.3.tar.gz && \
	tar -xzf ./opencv-3.4.3.tar.gz && \
	rm /usr/local/src/opencv/opencv-3.4.3.tar.gz && \
	wget -O ./opencv_contrib-3.4.3.tar.gz https://github.com/opencv/opencv_contrib/archive/3.4.3.tar.gz && \
	tar -xzf ./opencv_contrib-3.4.3.tar.gz && \
	rm /usr/local/src/opencv/opencv_contrib-3.4.3.tar.gz

# For eigen
RUN mkdir -p /usr/local/src/opencv/eigen
WORKDIR /usr/local/src/opencv/eigen
RUN wget -O ./3.3.5.tar.gz http://bitbucket.org/eigen/eigen/get/3.3.5.tar.gz && \
	mkdir -p /usr/local/src/opencv/eigen/eigen3.3.5 && \
	tar -xzf ./3.3.5.tar.gz -C ./eigen3.3.5 --strip-components 1 && \
	rm /usr/local/src/opencv/eigen/3.3.5.tar.gz
	
# Build OpenCV with Eigen
RUN mkdir /usr/local/src/opencv/opencv-3.4.3/build
WORKDIR /usr/local/src/opencv/opencv-3.4.3/build
RUN cmake -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-3.4.3/modules/ \
    -DWITH_TBB=ON \
    -DWITH_FFMPEG=ON \
    -DWITH_EIGEN=ON \
    -DEIGEN_INCLUDE_PATH=../../eigen/eigen3.3.5/ \
    .. && \
	make -j1 && make install && ldconfig
RUN rm -rf /usr/local/src/opencv/opencv-3.4.3 && rm -rf /usr/local/src/opencv/opencv_contrib-3.4.3