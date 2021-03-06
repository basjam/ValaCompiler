<p align="center">
    <img src="https://github.com/basjam/ValaCompiler/blob/master/data/icons/128/com.github.basjam.valacompiler.svg" alt="logo"> <br>
</p>

<div>
  <h1 align="center">ValaCompiler</h1>
  <h3 align="center">A simple GUI for the command line valac.</h3>
</div>

<p align="center">
    <img src="https://github.com/basjam/ValaCompiler/blob/master/screenshots/ValaCompiler-ProjectPage(ScreenShot).png" alt="Screenshot"> <br>
    <img src="https://github.com/basjam/ValaCompiler/blob/master/screenshots/ValaCompiler-CompilerReport(ScreenShot).png" alt="Screenshot"> <br>
    <img src="https://github.com/basjam/ValaCompiler/blob/master/screenshots/ValaCompiler-TestReport(ScreenShot).png" alt="Screenshot"> <br>
</p>


## What the application does
1-Select your project source folder, and create a "valacompiler" folder in it.

2-Scan the folder for valac compilable files and view them in a toggle list.

3-Modify the compile instructions by adding user selected options (eg:- pkg=gtk+3.0 pkg=granite .....), and add a "valacompiler.options" file in the "/valacompiler" folder.

4-Compile by using the command line (valac) + toggled files + options from step 3 + output a test file "valacompiler.test" in the "/valacompiler" inside the source folder.

5-Live report compile output.

6-Test run the output file "valacompiler.test".

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

## Arch Linux
Arch Linux users can find ValaCompiler under the name [valacompiler-git](https://aur.archlinux.org/packages/valacompiler-git/) in the **AUR**:

`$ aurman -S valacompiler-git`

## Precautions

* This app will create a folder named "valacompiler" in your source folder.
