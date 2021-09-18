## rtems-ec-cli

This is an example of using [ile-cli] for [RTEMS] RTOS based microcontrollers.

Follow these steps to build cross-compilers to build the project:
```
(user)$ export WORKSPACE=$(pwd)/rtems-project
(user)$ mkdir -p $WORKSPACE; cd $WORKSPACE

(user)$ git clone git://git.rtems.org/rtems-source-builder.git -b 5.1
(user)$ cd rtems-source-builder
(user)$ source-builder/sb-check

RTEMS Source Builder - Check, 5 (46e9d4911f09 modified)
Environment is ok

(user)$ cd rtems
(user)$ ../source-builder/sb-set-builder --list-bsets
(user)$ ../source-builder/sb-set-builder --log=log-i386.txt --prefix=$WORKSPACE/rtems-exe 5/rtems-i386.bset
(user)$ export PATH=$WORKSPACE/rtems-exe/bin:$PATH
(user)$ export PATH=$WORKSPACE/rtems/rtems-exe/i386-rtems5/bin:$PATH
```
Build RTEMS for [QEMU]:
```
(user)$ cd $WORKSPACE
(user)$ git clone git://git.rtems.org/rtems.git -b 5.1
(user)$ cd rtems
(user)$ export LC_ALL="en_US.UTF-8"
(user)$ ./bootstrap -h
(user)$ ./bootstrap -c && ./bootstrap -H && $WORKSPACE/rtems-source-builder/source-builder/sb-bootstrap

(user)$ mkdir -p $WORKSPACE/out; cd $WORKSPACE/out
(user)$ $WORKSPACE/rtems/rtems-bsps
(user)$ $WORKSPACE/rtems/configure --help
(user)$ $WORKSPACE/rtems/configure --target=i386-rtems5 \
   --prefix=$INSTALL --disable-multiprocessing \
   --disable-cxx --disable-rdbg \
   --enable-maintainer-mode --enable-tests \
   --enable-networking --enable-posix \
   --disable-itron --disable-deprecated \
   --disable-ada --disable-expada \
   --enable-rtemsbsp=pc386 \
   USE_COM1_AS_CONSOLE=1 BSP_PRESS_KEY_FOR_RESET=0
(user)$ make all
```
Test the result:
```
qemu-system-i386 -kernel ./i386-rtems5/c/pc386/testsuites/samples/hello.exe -nographic
```


[ile-cli]: https://github.com/maxpoliak/ile-cli
[RTEMS]: https://www.rtems.org/
[QEMU]: https://www.qemu.org/
