# Build UrJTAG for Windows using the MinGW-w64 cross compiler
# Usage: ./build-windows.sh /path/to/ftd2xx

set -e

FTD2XX_PATH="$1"
if [ -z "$FTD2XX_PATH" ]; then
    echo "Usage: $0 /path/to/ftd2xx" >&2
    exit 1
fi

HOST=i686-w64-mingw32
PREFIX=$PWD/win32

cd urjtag
./autogen.sh
./configure --host=$HOST --prefix=$PREFIX --with-ftd2xx=$FTD2XX_PATH --with-inpout32
make
make install
