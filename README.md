## Command line interface for embedded controllers based on RTEMS RTOS

### Based on the [ile-cli] project.

RTEMS (Real-Time Executive for Multiprocessor Systems [1],[2],[3]) is a
real-time operating system kernel used around the world and in space. RTEMS is a
free real-time operating system (RTOS) designed for deeply embedded systems such
as automobile electronics, robotic controllers, and on-board satellite instruments.

This example is the result of a study of this RTOS. I was interested in learning
how to build an image and create applications for it. At the moment, this project
is used as a base for creating embedded controller applications based on x86 CPU
and ARM-microcontrollers.

Perhaps this work will be interesting to someone and you will use this knowledge
to create your own systems.

![demonstration](https://raw.githubusercontent.com/maxpoliak/resources/master/rtems-ec-cli/demonstration.gif)

### Build

Use the following packages to build the project on Ubuntu:
```
sudo apt-get build-dep build-essential gcc-defaults g++ gdb git \
             unzip pax bison flex texinfo unzip python3-dev libpython-dev \
             libncurses5-dev zlib1g-dev wget
```
or use Docker:
```
./docker.sh [CONSOLE COMMANDS...]
```
```
./docker.sh ./build.sh help
```

Make some preparations once before start the building process:
```
git clone https://github.com/maxpoliak/rtems-ec-cli.git && ./rtems-ec-cli/preparations.sh
```

Print the help to see all available commands:
```
./build.sh help
```
```
Use ./build.sh [COMMANDS...]
  all         Build all: cross-compiler, RTEMS OS and ile-cli application
  rtems       Build RTEMS OS
  cross       Build cross-compiler
  cleanall    Clear all
  rebuild     Set rebuild flag
              Delete the application's object files before building it
  help        Print help
```

For the first build, use the build script with the "-a" or "all" option to build
all components of the project. As a result, you will build a cross compiler,
RTEMS OS and the ile-cli application itself.

```
./build.sh all
```

Build the application only, without rebuilding tools and RTEMS OS:
```
./build.sh
```
The Waf build system ([4],[5]) is used for the output executable file of the
application.

### Test

Test the result in [QEMU] using the script:

```
./run.sh
```

### Using GRUB2 to boot

The next step is to load the RTEMS and EC-CLI application from an external disk to
QEMU. To do this, you need to create a virtual image of the boot disk, install
grub on it and copy the exe file. You can do all this with create-boot-image.sh:
```
dd if=/dev/zero of=boot-disk.img bs=512 count=32130
```
```
sudo ./ci/ci-create-boot-image.sh --file boot-disk.img
```
After that you can test the result in QEMU:
```
qemu-system-i386 -m 128 -hda boot-disk.img -M q35 -nographic
```

### coreboot + seabios

The main and most interesting task of this project is to run the application on
real hardware. This task can be solved without any problems if you (like us) use
[coreboot] as BIOS and [seabios] as a payload in your x86 embedded systems.
Let's test this by building coreboot + seabios [image] for the "QEMU x86 q35/ich9"
machine and run it in QEMU with the virtual disk created at the previous stage:

```
qemu-system-i386 -m 128 -bios coreboot.rom -hda boot-disk.img -M q35 -nographic
```
You can also build coreboot for your board and run real-time applications on it.

![hello-logo-rtems-ec-cli](https://github.com/maxpoliak/resources/blob/master/rtems-ec-cli/hello-logo-rtems-ec-cli.jpg)

TODO: Try using ACRN hypervisor to run RTEMS with the Linux kernel

[1]: https://summerofcode.withgoogle.com/archive/2019/organizations/4579649638629376/
[2]: https://www.rtems.org/
[3]: https://en.wikipedia.org/wiki/RTEMS
[4]: https://en.wikipedia.org/wiki/Waf
[5]: https://devel.rtems.org/wiki/Docs/Build

[ACRN]: https://projectacrn.org/
[docker]: https://en.wikipedia.org/wiki/Docker_(software)
[ile-cli]: https://github.com/maxpoliak/ile-cli
[QEMU]: https://www.qemu.org/
[coreboot]: https://www.coreboot.org/
[seabios]: https://www.seabios.org/SeaBIOS
[image]: https://github.com/maxpoliak/rtems-ec-cli/releases/download/v1.0/rtems-ec-cli-release-v1.0.tar.gz
