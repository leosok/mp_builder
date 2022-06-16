#!/bin/bash

# copy board declarations:
set -x
cp -R /build/boards/* /mpbuilder/micropython_src/ports/esp32/boards/
ls /mpbuilder/micropython_src/ports/esp32/boards
set +x

# Export
export IDF_PATH=/mpbuilder/esp/esp-idf/ && \
. /mpbuilder/esp/esp-idf/export.sh

# Enter the build directory
cd /mpbuilder/micropython_src/ports/esp32
idf.py set-target $idf_target
make submodules

############################
#       BUILD COMMANDS     #
############################
echo "Cloning Display-Driver st7789_mpy"
rm -rf /mpbuilder/st7789_mpy
git clone https://github.com/russhughes/st7789_mpy.git /mpbuilder/st7789_mpy
# Need to do this because of breaking changes to micropython
cd /mpbuilder/st7789_mpy
git reset --hard 786d78d4c71cd43e8fe3e9b1f36c8a3f92dbe6a3

# clean modules directory + reload modules:
# backup original modules:


# cd /mpbuilder/micropython_src/ports/esp32/modules
#rm -rf *
cp -rf /build/modules/* /mpbuilder/micropython_src/ports/esp32/modules
# Copy Fonts here:
cp -rf /mpbuilder/st7789_mpy/fonts/vector/romand.py /mpbuilder/micropython_src/ports/esp32/modules/
cp -rf /mpbuilder/st7789_mpy/fonts/vector/meteo.py /mpbuilder/micropython_src/ports/esp32/modules/

# copy fonts:
echo "Copying Fonts to modules"
#cp -r /mpbuilder/st7789_mpy/fonts/vector/* /mpbuilder/micropython_src/ports/esp32/modules/
cp -r /mpbuilder/st7789_mpy/fonts/vector/romand.py /mpbuilder/micropython_src/ports/esp32/modules/
#cp -r /mpbuilder/st7789_mpy/fonts/bitmap/* /mpbuilder/micropython_src/ports/esp32/modules/

# YOUR build command is here:
cd /mpbuilder/micropython_src/ports/esp32
idf.py -D MICROPY_BOARD="$MICROPY_BOARD" -D USER_C_MODULES=/mpbuilder/st7789_mpy/st7789/micropython.cmake build
#idf.py -D MICROPY_BOARD="$MICROPY_BOARD" build

# END OF YOUR COMMANDS #

BUILD_DIR="/mpbuilder/micropython_src/ports/esp32/build"

#copy what is done
#cp -r $BUILD_DIR/* /build/done/

# build the firmware
python3 makeimg.py \
        $BUILD_DIR/sdkconfig \
        $BUILD_DIR/bootloader/bootloader.bin \
        $BUILD_DIR/partition_table/partition-table.bin \
        $BUILD_DIR/micropython.bin \
        $BUILD_DIR/firmware.bin

cp $BUILD_DIR/firmware.bin /build/firmware/firmware_$idf_target.bin