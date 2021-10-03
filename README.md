## This is an example of using [ile-cli] for [RTEMS] RTOS.

RTEMS (Real-Time Executive for Multiprocessor Systems)  is a real-time operating
system kernel used around the world and in space. RTEMS is a free real-time
operating system (RTOS) designed for deeply embedded systems such as automobile
electronics, robotic controllers, and on-board satellite instruments ([1],[2]).

This example is the result of a study of this OS. I was interested in learning how
to build an image and create applications for it. In addition, I wanted to develop
my own user-friendly command-line interface for managing and debugging a device
based on the [LPC1768] microcontroller.

Perhaps this work will be interesting to someone and you will use this knowledge to
create your own systems.

![](build-rtems-and-run-on-qemu.gif)

### Build

Use the help to find out all the available options:

```
(ubuntu-user)$ ./build.sh -h
Use ./build.sh [OPTIONS...]
    -a Build all: cross-compiler, RTEMS OS and ile-cli application
    -c Clear all
    -r Delete the application's object files before building it
    -h Print help
```

For the first build, use the build script with the -a option to build all the tools
and RTEMS object files. This will be located in the ./rtems-rtos folder.

```
(user)$ ./build.sh -a
```

Build the application only, without rebuilding tools and RTEMS OS:
```
(ubuntu-user)$ ./build.sh
```
The Waf build system ([3],[4]) is used for the output executable file of the application.

Use the docker.sh scripts to run in the [docker] container.

```
(user)$ ./docker.sh ./build.sh -h
```
### Test

Test the result in [QEMU] using the script:

```
(user)$ ./run.sh
```

[1]: https://summerofcode.withgoogle.com/archive/2019/organizations/4579649638629376/
[2]: https://en.wikipedia.org/wiki/RTEMS
[3]: https://en.wikipedia.org/wiki/Waf
[4]: https://devel.rtems.org/wiki/Docs/Build

[LPC1768]: https://www.nxp.com/products/processors-and-microcontrollers/arm-microcontrollers/general-purpose-mcus/lpc1700-cortex-m3:MC_1403790745385#/
[docker]: https://en.wikipedia.org/wiki/Docker_(software)
[ile-cli]: https://github.com/maxpoliak/ile-cli
[RTEMS]: https://www.rtems.org/
[QEMU]: https://www.qemu.org/
