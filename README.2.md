## Build cross-compilers, [RTEMS] OS and [ile-cli] project:

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
Build RTEMS for [QEMU]
```
(user)$ cd $WORKSPACE
(user)$ git clone git://git.rtems.org/rtems.git -b 5.1
(user)$ cd rtems
(user)$ export LC_ALL="en_US.UTF-8"
(user)$ ./bootstrap -h
(user)$ ./bootstrap -c && ./bootstrap -H && $WORKSPACE/rtems-source-builder/source-builder/sb-bootstrap

(user)$ mkdir -p $WORKSPACE/tmp; cd $WORKSPACE/tmp
(user)$ $WORKSPACE/rtems/rtems-bsps
(user)$ $WORKSPACE/rtems/configure --help
(user)$ $WORKSPACE/rtems/configure --target=i386-rtems5 \
   --prefix=$WORKSPACE/build --disable-multiprocessing \
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
qemu-system-i386 -kernel ./i386-rtems5/c/pc386/testsuites/samples/hello.exe -nographic -append "--console=/dev/com1"
```
```
SeaBIOS (version 1.13.0-1ubuntu1.1)


iPXE (http://ipxe.org) 00:03.0 CA00 PCI2.10 PnP PMM+07F8C8B0+07ECC8B0 CA00



Booting from ROM..i386: isr=0 irr=1
i386: isr=0 irr=1


*** BEGIN OF TEST HELLO WORLD ***
*** TEST VERSION: 5.0.0.61ccb9c05dcd695114541960aa6bfc1315f30514
*** TEST STATE: EXPECTED_PASS
*** TEST BUILD: RTEMS_NETWORKING RTEMS_POSIX_API
*** TEST TOOLS: 7.5.0 20191114 (RTEMS 5, RSB 5 (46e9d4911f09 modified), Newlib 7947581)
Hello World

*** END OF TEST HELLO WORLD ***
```

Let's build ile-cli project for our RTEMS image
```
(user)$ cd $WORKSPACE/tmp
(user)$ make install
(user)$ cd ..
(user)$ git clone https://github.com/maxpoliak/rtems-ec-cli.git
(user)$ cd rtems-ec-cli
(user)$ git submodule update --init --checkout
```
It is necessary to configure the waf build system correctly
```
(user)$ curl https://waf.io/waf-2.0.19 > waf
(user)$ chmod +x waf
```
```
(user)$ ./waf configure --rtems=$WORKSPACE/build --rtems-tools=$WORKSPACE/rtems-exe --rtems-bsps=i386/pc386
Setting top to                           : /home/build/projects/rtems-project/rtems-ec-cli
Setting out to                           : /home/build/projects/rtems-project/rtems-ec-cli/build
RTEMS Version                            : 5
Architectures                            : i386-rtems5
Board Support Package (BSP)              : i386-rtems5-pc386
Show commands                            : no
Long commands                            : no
Checking for program 'i386-rtems5-gcc'   : /home/build/projects/rtems-project/rtems-exe/bin/i386-rtems5-gcc
Checking for program 'i386-rtems5-g++'   : /home/build/projects/rtems-project/rtems-exe/bin/i386-rtems5-g++
Checking for program 'i386-rtems5-gcc'   : /home/build/projects/rtems-project/rtems-exe/bin/i386-rtems5-gcc
Checking for program 'i386-rtems5-ld'    : /home/build/projects/rtems-project/rtems-exe/bin/i386-rtems5-ld
Checking for program 'i386-rtems5-ar'    : /home/build/projects/rtems-project/rtems-exe/bin/i386-rtems5-ar
Checking for program 'i386-rtems5-nm'    : /home/build/projects/rtems-project/rtems-exe/bin/i386-rtems5-nm
Checking for program 'i386-rtems5-objdump' : /home/build/projects/rtems-project/rtems-exe/bin/i386-rtems5-objdump
Checking for program 'i386-rtems5-objcopy' : /home/build/projects/rtems-project/rtems-exe/bin/i386-rtems5-objcopy
Checking for program 'i386-rtems5-readelf' : /home/build/projects/rtems-project/rtems-exe/bin/i386-rtems5-readelf
Checking for program 'i386-rtems5-strip'   : /home/build/projects/rtems-project/rtems-exe/bin/i386-rtems5-strip
Checking for program 'i386-rtems5-ranlib'  : /home/build/projects/rtems-project/rtems-exe/bin/i386-rtems5-ranlib
Checking for program 'rtems-ld'            : /home/build/projects/rtems-project/rtems-exe/bin/rtems-ld
Checking for program 'rtems-tld'           : /home/build/projects/rtems-project/rtems-exe/bin/rtems-tld
Checking for program 'rtems-syms'          : /home/build/projects/rtems-project/rtems-exe/bin/rtems-syms
Checking for program 'rtems-bin2c'         : /home/build/projects/rtems-project/rtems-exe/bin/rtems-bin2c
Checking for program 'tar'                 : /bin/tar
Checking for program 'gcc, cc'             : /home/build/projects/rtems-project/rtems-exe/bin/i386-rtems5-gcc
Checking for program 'ar'                  : /home/build/projects/rtems-project/rtems-exe/bin/i386-rtems5-ar
Checking for program 'g++, c++'            : /home/build/projects/rtems-project/rtems-exe/bin/i386-rtems5-g++
Checking for program 'ar'                  : /home/build/projects/rtems-project/rtems-exe/bin/i386-rtems5-ar
Checking for program 'gas, gcc'            : /home/build/projects/rtems-project/rtems-exe/bin/i386-rtems5-gcc
Checking for program 'ar'                  : /home/build/projects/rtems-project/rtems-exe/bin/i386-rtems5-ar
Checking for c flags '-MMD'                : yes
Checking for cxx flags '-MMD'              : yes
Compiler version (i386-rtems5-gcc)         : 7.5.0 20191114 (RTEMS 5, RSB 5 (46e9d4911f09 modified), Newlib 7947581)
Checking for a valid RTEMS BSP installation : yes
Checking for RTEMS_DEBUG                    : no
Checking for RTEMS_MULTIPROCESSING          : no
Checking for RTEMS_NEWLIB                   : yes
Checking for RTEMS_POSIX_API                : yes
Checking for RTEMS_SMP                      : no
Checking for RTEMS_NETWORKING               : yes
'configure' finished successfully (3.460s)
```
Now we can build an RTEMS image with the ile-cli application
```
(user)$ ./waf
Waf: Entering directory `/home/build/projects/rtems-project/rtems-ec-cli/build/i386-rtems5-pc386'
[1/8] Compiling ile-cli/src/ile-vterm.c
[2/8] Compiling ile-cli/src/ile-cli-cmd-tree.c
[3/8] Compiling ile-cli/src/ile-history.c
[4/8] Compiling main.c
[5/8] Compiling init.c
[6/8] Compiling ile-cli/src/ile-debug.c
[7/8] Compiling ile-cli/src/ile-cli-core.c
[8/8] Linking build/i386-rtems5-pc386/ile-cli-test.exe
Waf: Leaving directory `/home/build/projects/rtems-project/rtems-ec-cli/build/i386-rtems5-pc386'
'build-i386-rtems5-pc386' finished successfully (0.981s)
```
and run it on [QEMU]
```
(user)$ qemu-system-i386 -kernel ./build/i386-rtems5-pc386/ile-cli-test.exe -nographic -append "--console=/dev/com1"
```
Good luck!

[waf]: https://waf.io/
[RTEMS]: https://www.rtems.org/
[QEMU]: https://www.qemu.org/
[ile-cli]: https://github.com/maxpoliak/ile-cli
