FROM ubuntu:18.04

ENV DEBIAN_FRONTEND nonineractive

RUN apt update && apt upgrade -y
RUN apt install software-properties-common -y
RUN add-apt-repository ppa:jonathonf/ffmpeg-4
RUN apt-get update && apt-get upgrade -y

RUN apt install python3 -y
RUN apt install python3-pip -y
RUN apt install python3-dev -y
RUN python3 -V
RUN pip3 -V
RUN pip3 install --upgrade pip
RUN pip -V


RUN apt install libopus-dev -y
RUN apt install libvpx-dev -y
RUN apt install libffi-dev -y
RUN apt install libssl-dev -y
RUN apt install libopencv-dev -y
RUN apt install libavdevice-dev -y
RUN apt install libavfilter-dev -y
RUN apt install pkg-config -y
#
# -- aiortc --
#
RUN apt install git -y

RUN mkdir /root/work 
WORKDIR /root/work/
RUN git clone https://github.com/jlaine/aiortc.git

RUN pip install aiohttp
RUN pip install aiortc 
RUN pip install opencv-python

#
# ------ yolo v3 ---
#

RUN apt install vim -y
RUN apt install wget -y
WORKDIR /root/work/
RUN git clone https://github.com/pjreddie/darknet.git
WORKDIR /root/work/darknet
RUN make
RUN wget https://github.com/dcs-aidojo/yolo/raw/master/yolov3.weights
RUN wget https://github.com/dcs-aidojo/yolo/raw/master/yolov3-tiny.weights
#RUN wget https://pjreddie.com/media/files/yolov3.weights
#RUN wget https://pjreddie.com/media/files/yolov3-tiny.weights

RUN ln -s /root/work/darknet/libdarknet.so /usr/lib/libdarknet.so

#-- copy darknet sample ---
WORKDIR /root/work/
RUN git clone https://github.com/mganeko/python3_yolov3.git
RUN cp /root/work/python3_yolov3/darknet-tiny-label.py /root/work/darknet/python/


# --- link ---
RUN ln -s /root/work/darknet/cfg /root/work/aiortc/examples/server/
RUN ln -s /root/work/darknet/data /root/work/aiortc/examples/server/
RUN ln -s /root/work/darknet/yolov3-tiny.weights /root/work/aiortc/examples/server/

#-- copy ---
WORKDIR /root/work/
RUN git clone https://github.com/mganeko/aiortc_yolov3.git
RUN cp /root/work/aiortc_yolov3/server_yolo.py /root/work/aiortc/examples/server/
RUN cp /root/work/aiortc_yolov3/index.html /root/work/aiortc/examples/server/
#COPY server_yolo.py /root/work/aiortc/examples/server/
#COPY index.html /root/work/aiortc/examples/server/


# --- for running --
EXPOSE 8080

WORKDIR /root/work/aiortc/examples/server/
CMD [ "python3", "server_yolo.py" ]

# ----
# memo
# ----

# -- to build --
# docker build -t mganeko/aiortc-yolov3 -f Dockerfile .
# 
# docker build --no-cache=true -t mganeko/aiortc-yolov3 -f Dockerfile .

# -- bash --
# docker run -it mganeko/aiortc-yolov3 bash

# -- run --
# docker run -d -p 8001:8080 --name aio mganeko/aiortc-yolov3

# -- stop & remove --
# docker stop aio

# -- remove ---
# docker rm aio

# -- remove stoped container ---
# docker rm $(docker ps -q -f status=exited)

# -- connect to running container ---
# docker exec -i -t {id or name} /bin/bash


