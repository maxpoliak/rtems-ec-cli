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

Make some preparations once before start the building process:
```
git clone https://github.com/maxpoliak/rtems-ec-cli.git && ./rtems-ec-cli/preparations.sh
```

Use the help to print all the available commands:

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

Use the docker.sh scripts to run in the [docker] container.

```
./docker.sh ./build.sh all
```
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
sudo ./create-boot-image.sh --file boot-disk.img
```
After that you can test the result in QEMU:
```
qemu-system-i386 -m 128 -hda boot-disk.img -M q35 -nographic
```

### coreboot + seabios

To make testing similar to using real hardware, you can build [coreboot] with
[seabios] payload for "QEMU x86 q35/ich9" machine and run it together with
rtems-boot.img on QEMU:

```
qemu-system-i386 -m 128 -bios coreboot.rom -hda rtems-boot.img -M q35 -nographic
```

[1]: https://summerofcode.withgoogle.com/archive/2019/organizations/4579649638629376/
[2]: https://www.rtems.org/
[3]: https://en.wikipedia.org/wiki/RTEMS
[4]: https://en.wikipedia.org/wiki/Waf
[5]: https://devel.rtems.org/wiki/Docs/Build

[docker]: https://en.wikipedia.org/wiki/Docker_(software)
[ile-cli]: https://github.com/maxpoliak/ile-cli
[QEMU]: https://www.qemu.org/
[coreboot]: https://www.coreboot.org/
[seabios]: https://www.seabios.org/SeaBIOS
