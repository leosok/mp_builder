# Please run this Dockerfile with docker-compose up, to get all ARGS

FROM debian:latest
ARG micropython_version_tag
ARG idf_version_tag
ARG idf_build_platforms
ARG idf_target

RUN  apt-get update && apt-get install -y git wget flex bison gperf python3 python3-pip python3-setuptools cmake ninja-build ccache libffi-dev libssl-dev dfu-util libusb-1.0-0


WORKDIR /mpbuilder
# Installing ESP-IDF
RUN mkdir -p esp && \
cd esp && \
git clone --single-branch -b $idf_version_tag --recurse-submodules  https://github.com/espressif/esp-idf.git ./esp-idf

RUN cd esp/esp-idf && \
./install.sh $idf_build_platforms

# Clone Micropython
RUN git clone --branch $micropython_version_tag https://github.com/micropython/micropython.git micropython_src

# Build Micropython Cross-Compiler
RUN cd micropython_src &&\
    make -C mpy-cross

# backup original modules
RUN mkdir /modules_original
COPY /mpbuilder/micropython_src/ports/esp32/modules /modules_original

# copy modules
COPY ./modules /mpbuilder/micropython_src/ports/esp32/modules

# Build Submodules & Firmware
ENTRYPOINT chmod +x /build/builder.sh && /build/builder.sh

