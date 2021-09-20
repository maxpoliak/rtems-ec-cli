## rtems-ec-cli

This is an example of using [ile-cli] for [RTEMS] RTOS based microcontrollers.

![][pic]

```
(ubuntu-user)$ ./build.sh -h | or | ./build-docker.sh -h
Use ./build.sh [OPTIONS...]
    -a Build all: cross-compiler, RTEMS OS and ile-cli application
    -c Clear ile-cli application
    -h Print help
```
or don't set options when using the script to rebuild the ile-cli only
```
(ubuntu-user)$ ./build.sh
```

Run [RTEMS] OS with [ile-cli] application on [QEMU]
```
./run.sh | or | run-docker.sh
```

[pic]:qemu-rtems-ile-cli.png
[ile-cli]: https://github.com/maxpoliak/ile-cli
[RTEMS]: https://www.rtems.org/
[QEMU]: https://www.qemu.org/
