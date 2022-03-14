FROM tensorflow/tensorflow:1.15.5-gpu-jupyter
MAINTAINER ANONYMOUS

# CUDA includes
ENV CUDA_PATH /usr/local/cuda
ENV CUDA_INCLUDE_PATH /usr/local/cuda/include
ENV CUDA_LIBRARY_PATH /usr/local/cuda/lib64

# Ubuntu Packages
RUN apt-get update -y && apt-get install software-properties-common -y && \
    add-apt-repository -y multiverse && apt-get update -y && apt-get upgrade -y && \
    apt-get install -y apt-utils nano vim man build-essential wget sudo && \
    rm -rf /var/lib/apt/lists/*

# Install curl and other dependencies
RUN apt-get update -y && apt-get install -y curl libssl-dev openssl libopenblas-dev \
    libhdf5-dev hdf5-helpers hdf5-tools libhdf5-serial-dev libprotobuf-dev protobuf-compiler git \
    libsm6 libxext6 libxrender-dev

RUN apt install -y libopenmpi-dev
RUN pip3 install cloudpickle==1.2.1 gym[atari,box2d,classic_control]~=0.15.3 ipython joblib
RUN pip3 install matplotlib==3.1.1 mpi4py numpy pandas pytest psutil scipy seaborn==0.8.1 torch tqdm
RUN /usr/bin/python3 -m pip install --upgrade pip

WORKDIR /spinningup


