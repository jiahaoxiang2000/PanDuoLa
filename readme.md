## msh

Use the `msh` shell to transmit data via UART. You can do this by running the following command in your terminal:

```shell
minicom -D /dev/ttyACM0
```

## Download the program 

- Start by using `scons` to create the CMake project. If you haven't installed `scons`, you can follow the instructions in this [link](https://github.com/RT-Thread/env).

```shell
scons --target=cmake
```
- Next, use `cmake` to build the project. For this step, we recommend using the Visual Studio Code CMake extension.
- Finally, use `openocd` to download the program to the board. If you haven't installed `openocd` yet, you can follow the instructions provided in this [link](https://github.com/openocd-org/openocd).

```shell
openocd -f st_b-l475e-iot01a.cfg -c "program build/rtthread.elf verify reset exit"
```
