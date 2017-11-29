# project name
project (com.github.basjam.valacompiler)

# the oldest stable cmake version we support
cmake_minimum_required (VERSION 2.6)

# tell cmake where its modules can be found in our project directory
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/src)

# where we install data directory (if we have any)
set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")

# what to call that directory where we install data too
set (PKGDATADIR "${DATADIR}/com.github.basjam.valacompiler")

set (EXEC_NAME "com.github.basjam.valacompiler")
set (RELEASE_NAME "A GUI for valac.")
set (VERSION "0.1")
set (VERSION_INFO "functioning compiler")

# we're about to use pkgconfig to make sure dependencies are installed so let's find pkgconfig first
find_package(PkgConfig)

# now let's actually check for the required dependencies
pkg_check_modules(DEPS REQUIRED gtk+-3.0 granite)

add_definitions(${DEPS_CFLAGS})
add_definitions (-w)
link_libraries(${DEPS_LIBRARIES})
link_directories(${DEPS_LIBRARY_DIRS})

# make sure we have vala
find_package(Vala REQUIRED)
# make sure we use vala
include(ValaVersion)
# make sure it's the desired version of vala
ensure_vala_version("0.26.0" MINIMUM)

# files we want to compile
include(ValaPrecompile)
vala_precompile(VALA_C ${EXEC_NAME}
    src/Window.vala
    src/Application.vala
    src/Settings/Settings.vala
    src/Utils/FileLister.vala
    src/Utils/FilesManager.vala
    src/Utils/Files.vala
    src/Utils/ValaC.vala
    src/Utils/AppTester.vala
    src/Widgets/FilesListBottomBar.vala
    src/Widgets/FilesListBox.vala
    src/Widgets/FilesListRow.vala
    src/Widgets/NavigationButton.vala
    src/Widgets/ProjectPage.vala
    src/Widgets/WelcomePage.vala
    src/Widgets/ReportPage.vala

# tell what libraries to use when compiling
PACKAGES
    gtk+-3.0
    granite
)

# tell cmake what to call the executable we just made
add_executable(${EXEC_NAME} ${VALA_C})

# install the binaries we just made
install (TARGETS ${EXEC_NAME} RUNTIME DESTINATION bin)

# Translation files
set (GETTEXT_PACKAGE "${CMAKE_PROJECT_NAME}")
add_definitions (-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")
add_subdirectory (po)

#TESTING LINES FROM ELEMENTARY/VIDEOS
add_subdirectory (data)



