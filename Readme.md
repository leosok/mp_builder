⚠️ **Currently untested. This was not used for around a year. It may not work. But most of it should!** ⚠️ 
# MicroPython Builder README 📖

⚠️ **Please note:** This setup is designed specifically for ESP32-based boards. If you plan to use this setup for other types of boards, adjustments may be needed in the Dockerfile, Docker Compose file, and the builder script accordingly.

This project was created as part of a personal effort to build a custom MicroPython firmware for a specific application. It provides an environment for building custom MicroPython firmware for ESP32-based boards, using Docker. This project has been used successfully to build firmware with the ST7789 display driver (available [here](https://github.com/russhughes/st7789_mpy)). It's a useful starting point for similar projects, and you're invited to fork and improve it.

The build process is automated through a Dockerfile, a Docker Compose file, and a builder script. 

## 🎯 Quick Start 

1. Ensure Docker and Docker Compose are installed on your system.

2. Clone the repository:
   ```
   git clone <repository_url>
   ```

3. Navigate into the cloned repository:
   ```
   cd mp_builder
   ```

4. Build the Docker image and start the Docker container:
   ```
   docker-compose build --progress=plain mpbuilder
   docker-compose up
   ```

## 🐳 Docker Compose 

The Docker Compose file sets up the MicroPython build environment. It allows you to specify details such as the IDF version, MicroPython version, and the MicroPython board to use for the build process.

## 📝 Dockerfile 

The Dockerfile outlines the steps to set up the build environment. It begins with a Debian image and proceeds to install the necessary tools and libraries. The file then clones the ESP-IDF and MicroPython repositories, compiles the MicroPython cross-compiler, and copies the custom modules into the MicroPython source directory.

## 🏗️ builder.sh 

The `builder.sh` script is the heart of the firmware building process. It copies board configuration files, sets environment variables, clones the ST7789 display driver, copies Python modules and fonts, and builds the firmware. Once built, the firmware binary is copied to the `firmware` directory in the mounted project directory.

You may need to grant execution permissions to the script using the following command:

```bash
chmod +x builder.sh
```

The `builder.sh` script is customizable according to your requirements, especially if you plan to add more modules, use a different display driver, or build for a different MicroPython board.

## ✏️ Customization

The `modules` and `boards` directories are key to customizing the firmware. To include specific Python files in the firmware, add them to the `modules` directory. If you want to use a custom board, add its configuration files to the `boards` directory.

This is a personal project that I hope will be a valuable resource for others. Feel free to fork this repository and contribute any enhancements you make back to the community!
