## rtems-ec-cli

This is an example of using [ile-cli] for [RTEMS] RTOS based microcontrollers.

![][pic]

Build all:
```
./build.sh -a
```
Clear all:
```
./build.sh -c

```

Docker:
```
./build-docker.sh -a

./build-docker.sh -c
```

Test on Qemu:
```
./qemu-test.sh
```
or
```
./ci/ci-build-docker.sh ./qemu-test.sh
```

[pic]:qemu-rtems-ile-cli.png
[ile-cli]: https://github.com/maxpoliak/ile-cli
[RTEMS]: https://www.rtems.org/
[QEMU]: https://www.qemu.org/
