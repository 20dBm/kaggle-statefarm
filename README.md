# kaggle-statefarm
[detecting distracted drivers](https://www.kaggle.com/c/state-farm-distracted-driver-detection)

# Set up
## Note
* The following instructions have been tested on an AWS g2.2xlarge instance running ubuntu 14.04
* We will set up a __notebook server__ listening to port 8888 for incoming __https__ requests

## Download and Install NVIDIA Driver
Read this [article](http://tleyden.github.io/blog/2014/10/25/cuda-6-dot-5-on-aws-gpu-instance-running-ubuntu-14-dot-04/) for details. In short run the following in order
```sh
# install dependencies
sudo apt-get update
sudo apt-get install build-essential linux-image-extra-virtual

# download and extract the nvidia installer
wget http://developer.download.nvidia.com/compute/cuda/6_5/rel/installers/cuda_6.5.14_linux_64.run
chmod +x cuda_6.5.14_linux_64.run
mkdir nvidia_installers
./cuda_6.5.14_linux_64.run -extract=`pwd`/nvidia_installers
cd nvidia_installers

# run nvidia installer and follow the instruction (press Enter to accept the default settings)
sudo ./NVIDIA-Linux-x86_64-340.29.run
sudo modprobe nvidia
sudo ./cuda-linux64-rel-6.5.14-18749181.run
sudo ./cuda-samples-linux-6.5.14-18745345.run

# verify the installation
cd /usr/local/cuda/samples/1_Utilities/deviceQuery
sudo make
./deviceQuery
# you should see "Result = PASS" at the end of the command line output
```

## Install Docker
For detailed instructions see this [article](https://docs.docker.com/engine/installation/linux/ubuntulinux/). In short run the following in order
```sh
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
# http://askubuntu.com/questions/103643/cannot-echo-hello-x-txt-even-with-sudo
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-get install linux-image-extra-$(uname -r) apparmor
sudo apt-get install docker-engine
sudo usermod -aG docker ubuntu
exit
ssh ...
```

## Run the docker container
You can simply pull this [docker container](https://hub.docker.com/r/evau23/kaggle-statefarm/) that has everything set, by running `docker pull evau23/kaggle-statefarm`
* run_jupyter.sh is shell script to help with running the notebook server in a docker container. You can find the original script [here](https://github.com/ipython/docker-notebook/blob/master/notebook/notebook.sh)

Or build the container yourself by running
```sh
git clone https://github.com/alireza-a/kaggle-statefarm.git
cd ./kaggle-statefarm
docker build -t name:tag . # make sure to change the name and tag in the following steps
```
Now you can run the container by running the following
```sh
# http://tleyden.github.io/blog/2014/10/25/running-caffe-on-aws-gpu-instance-via-docker/
DOCKER_NVIDIA_DEVICES="--device /dev/nvidia0:/dev/nvidia0 --device /dev/nvidiactl:/dev/nvidiactl --device /dev/nvidia-uvm:/dev/nvidia-uvm"

docker run $DOCKER_NVIDIA_DEVICES -d -p 8888:8888 -e "PASSWORD=your_password" --name statefarm evau23/kaggle-statefarm bash /run_jupyter.sh
```
__Fantastic, now you have a notebook server with all the dependencies running__

# Fine tuning Caffe_Net
The [Caffe_net.ipynb](https://github.com/alireza-a/kaggle-statefarm/blob/master/src/fine_tune_caffe_net.ipynb) has been adopted from the [02-fine-tuning.ipynb](https://github.com/BVLC/caffe/blob/master/examples/02-fine-tuning.ipynb). In short we will do the followings

__some set up__

1. Import the required libraries
2. load pretrained weights, labels, and mean image
3. load StateFarm data
  - download StateFarm data
    - make sure you have read the README file under data directory
  - define train and valid sets

__some definitions__

1. define caffenet
  - to define caffeNet architecture
2. define solver
  - to initialize caffe solver for training the model
3. define kaggle_net
  - to initialize caffenet for our dataset
4. define run_solver
  - a wrapper to step the model

__train the model__

1. initialize and run the solver
  - specify the number of iterations
2. visualize the loss and accuracy

__extract probabilities__

1. define helper functions
  - to initialize a transformer
  - to preprocess a batch of images
  - to extract probabilities from the batch of images
  - to write the extracted probabilities into a file
2. extract probabilities for each batch of images and write it to a file
