urjtag-st7xxx
=============

UrJtag repository clone patched specifically with HUDI support. HUDI is a specific Hitachi debug protocol used in 
the ST7xxx SOCs which will allow to use peek/poke commands within urJtag.

Primary purpose of this repository is to use it on the Telenet ADB-DC2000 digicorder for nagravision key extraction.

To compile use following commands (Ubuntu 12.10 64 bit)

* install libftd2xxx (download from http://www.ftdichip.com/Drivers/D2XX.htm)
```
     sudo cp ftd2xxx.h /usr/include/
     sudo ln -s /usr/local/include/ftd2xx.h /usr/include/ftd2xx.h
     sudo cp libftd2xx.so.1.1.12 /usr/local/lib/
     sudo ln -s /usr/local/lib/libftd2xx.so.1.1.12 /usr/lib/libftd2xx.so
```
* compile urjtag
```
     sudo apt-get install libdwb1 libdw-dev elfutils libelf-dev libftdi-dev
     autoreconf -vis
     export LDFLAGS="-L/usr/lib/x86_64-linux-gnu/libelf.so -lelf" && ./configure --enable-jedec-exp --disable-nls --with-ftd2xx
     make V=1
```
* start urjtag
```
    src/apps/jtag/jtag
    cable arduiggler
    detect
```
* get offset address of stmc overlays (st peek/poke assembly)
```    
    nm /opt/STM/STLinux-2.3/devkit/sh4/microprobe/bin/sh4stdi.mc2 | grep overlays
    00516e48 d overlays
```
*  load stmc2 stdi file for st40 debugger and bypass to st40 tap
```
    tapmux stdi file /opt/STM/STLinux-2.3/devkit/sh4/microprobe/bin/sh4stdi.mc2 00516e48
    tapmux bypass 1
```
* attach stdi to st40
```
    tapmux stdi attach
```    

18-10-2014: Added arduiggler patch. One can use an arduino to jtag a hudi target now. Patch taken from latest commit on https://gitorious.org/urjtag-arduiggler/urjtag-arduiggler/


Have fun!

## FT2232 USB cable support

This tree retains upstream support for FTDI FT2232 based cables. When
linking against either **libftdi** or **ftd2xx** the following cable
drivers become available:

```
  cable ft2232
  cable ft2232_gnice
  cable ft2232_flyswatter
  ...
```

Make sure the appropriate driver library is installed and use
`--with-ftdi` or `--with-ftd2xx` when running `configure`.

## Building on Windows

UrJTAG can be compiled for Windows using either MinGW or Cygwin.  The
quickest method is to use the MinGW‑w64 cross compiler on a Linux host.
This repository provides a helper script `build-windows.sh` which
invokes `autogen.sh` and configures the build automatically:

```
./build-windows.sh /path/to/ftd2xx
```

The script uses the `i686-w64-mingw32` toolchain and installs the
resulting files under `win32/`.  This produces a `jtag.exe` that uses
`FTD2XX.DLL` for FT2232 access.  See `doc/UrJTAG.txt` for more details.
