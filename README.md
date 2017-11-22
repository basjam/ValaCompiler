# ValaCompiler
A simple GUI for the command line valac.

## Building and Installation

you'll need the following dependencies:
* cmake
* valac
* libgranite-dev
* libgtk-3-dev

  mkdir build
  cd build/

Run 'cmake' to configure the build environment and then 'make' to build

  cmake -DCMAKE_INSTALL_PREFIX=/usr ..
  make

To install, use 'make install'

  sudo make install

## Precautions

* This app will create a file named TEST in your source folder.
* This app will send a 'killall TEST' signal. Make sure that you do not have a running any application named 'TEST'.

