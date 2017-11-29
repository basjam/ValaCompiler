# ValaCompiler
A simple GUI for the command line valac.

## What the application does
1-Select your project source folder.

2-Scan the folder for valac compilable files and view them in a toggle list.

3-Modify the compile instructions by adding user selected options (eg:- pkg=gtk+3.0 pkg=granite .....).

4-Compile by using the command line (valac) + toggled files + options from step 3 + output a test file (TEST) in the source folder.

5-Live report compile output.

6-Test run the output file (TEST).

7-Live report the test run output.

## Building and Installation

you'll need the following dependencies:
* cmake
* valac
* libgranite-dev
* libgtk-3-dev

It is recommended to create a clean build environment

    mkdir build
    cd build/

Run 'cmake' to configure the build environment and then 'make' to build

    cmake -DCMAKE_INSTALL_PREFIX=/usr ..
    make

To install, use 'make install'

    sudo make install

## Precautions

* This app will create a file named TEST in your source folder.
* This app will send a 'killall TEST' signal. Make sure that you do not have any running application named 'TEST'.

