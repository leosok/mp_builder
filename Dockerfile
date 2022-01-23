# to build: "docker build -t mpbuilder ."
# to run "docker build -t mpbuilder ."

FROM debian:latest
ARG micropython_src_url
ARG idf_build_platforms
ARG port_to_build

RUN  apt-get update && apt-get install -y git wget flex bison gperf python3 python3-pip python3-setuptools cmake ninja-build ccache libffi-dev libssl-dev dfu-util libusb-1.0-0


WORKDIR /mpbuilder
# Installing ESP-IDF
RUN mkdir -p esp && \
cd esp && \
git clone --single-branch -b v4.3.1 --recurse-submodules  https://github.com/espressif/esp-idf.git ./esp-idf

RUN cd esp/esp-idf && \
./install.sh $idf_build_platforms

# Download Micropython
RUN wget -c $micropython_src_url -O - | tar -xJ -C $(pwd)

# Build Micropython Cross-Compiler
RUN mv $(basename $micropython_src_url .tar.xz) "micropython_src"
RUN cd micropython_src &&\
    make -C mpy-cross

COPY ./modules /mpbuilder/micropython_src/ports/esp32/modules

# Build Submodules & Firmware
RUN cd micropython_src/ports/$port_to_build && \
    export IDF_PATH=/mpbuilder/esp/esp-idf/ && \
    . /mpbuilder/esp/esp-idf/export.sh && \
    #make submodules &&\
    make

#RUN cp /mpbuilder/micropython_src/ports/$port_to_build/build-GENERIC/firmware.bin /build/bla.bin #ok11
CMD ["cp", "/mpbuilder/micropython_src/ports/esp32/build-GENERIC/firmware.bin", "/build/firmware"]