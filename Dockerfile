# to build: "docker build -t mpbuilder ."
# to run "docker build -t mpbuilder ."

FROM debian:latest
RUN  apt-get update && apt-get install -y git wget flex bison gperf python3 python3-pip python3-setuptools cmake ninja-build ccache libffi-dev libssl-dev dfu-util libusb-1.0-0

# Installing ESP-IDF
RUN mkdir -p ~/esp && \
cd ~/esp && \
#git clone -b v4.3.1 --recursive https://github.com/espressif/esp-idf.git && \
git clone --single-branch -b v4.3.1 --recurse-submodules  https://github.com/espressif/esp-idf.git ./esp-idf

RUN cd ~/esp/esp-idf && \
./install.sh esp32, esp32s2

# At the End this fails, but should be fine, it's after the "happy message"
ENTRYPOINT  export IDF_PATH=~/esp/esp-idf &&\
            . ~/esp/esp-idf/export.sh


#WORKDIR /~
#COPY . .