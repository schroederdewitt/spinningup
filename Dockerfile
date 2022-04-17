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

# Other system level tools
RUN apt-get install -y htop iotop

# Mujoco I
RUN apt install -y libosmesa6-dev libgl1-mesa-glx libglfw3
RUN ln -s /usr/lib/x86_64-linux-gnu/libGL.so.1 /usr/lib/x86_64-linux-gnu/libGL.so
RUN apt install -y unzip patchelf

#### -------------------------------------------------------------------
#### install mujoco
#### -------------------------------------------------------------------
RUN yes | pip3 uninstall enum34

# Make sure you have a license key, otherwise comment it out
COPY ./mjkey.txt /tf/mjkey.txt

RUN wget https://mujoco.org/download/mujoco210-linux-x86_64.tar.gz -O /tf/mujoco.tar.gz \
    && tar -xvzf /tf/mujoco.tar.gz \
    && rm /tf/mujoco.tar.gz 
    
ENV LD_LIBRARY_PATH /tf/mujoco210/bin:${LD_LIBRARY_PATH}
ENV MUJOCO_PY_MJKEY_PATH /tf/mjkey.txt
ENV MUJOCO_PY_MUJOCO_PATH /tf/mujoco210

RUN MUJOCO_PY_MUJOCO_PATH=/tf/mujoco210 pip3 install mujoco-py
RUN echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/tf/mujoco210/bin" >> ~/.bashrc
RUN echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/tf/mujoco210/bin" >> ~/.profile
RUN export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/tf/mujoco210/bin && \
    export MUJOCO_PY_MUJOCO_PATH=/tf/mujoco210 && python3 -c "import mujoco_py"
RUN chmod 777 -R /usr/local/lib/python3.6/dist-packages/mujoco_py

# set python path
RUN echo "export PYTHONPATH=~/entryfolder" >> ~/.bashrc
RUN echo "export PYTHONPATH=~/entryfolder" >> ~/.profile

RUN pip3 install gym==0.10.8

# make sure virtualenv is activated by default
RUN echo "source ~/venv/bin/activate" >> ~/.bashrc
RUN echo "source ~/venv/bin/activate" >> ~/.profile

EXPOSE 8888
WORKDIR /spinningup


