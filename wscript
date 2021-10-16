#
# Waf script
#
from __future__ import print_function

rtems_version = "5"

try:
    import rtems_waf.rtems as rtems
except:
    print('error: no rtems_waf git submodule')
    import sys
    sys.exit(1)

def init(ctx):
    rtems.init(ctx, version = rtems_version, long_commands = True)

def bsp_configure(conf, arch_bsp):
    # Add BSP specific configuration checks
    pass

def options(opt):
    rtems.options(opt)

def configure(conf):
    rtems.configure(conf, bsp_configure = bsp_configure)

def build(bld):
    rtems.build(bld)
    bld.env.CFLAGS += ['-g', '-O2']

    bld(features = 'c cprogram',
        target = 'rtems-ec-cli.exe',
        includes = 'ile-cli/includes .',
        source = ['main.c',
                  'init.c',
                  'ile-cli/src/ile-cli-cmd-tree.c',
                  'ile-cli/src/ile-cli-core.c',
                  'ile-cli/src/ile-debug.c',
                  'ile-cli/src/ile-history.c',
                  'ile-cli/src/ile-vterm.c'
                  ])
