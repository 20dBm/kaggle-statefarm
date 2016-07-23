FROM tleyden5iwx/caffe-gpu-master

RUN apt-get update
RUN apt-get install -yqq build-essential
RUN apt-get install -yqq python-pip

RUN pip install ipykernel
RUN pip install jupyter

# import src
RUN mkdir /home/kaggle
ADD ./src /home/kaggle

ADD run_jupyter.sh /

EXPOSE 8888

