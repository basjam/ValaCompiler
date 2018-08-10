## project name and programming language
project('com.github.basjam.valacompiler', 'vala', 'c')

# Include the translations module
i18n = import('i18n')

# Set our translation domain
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

# Create a new executable, list the files we want to compile, list the dependencies we need, and install

executable(
    meson.project_name(),
    'src/Window.vala',
    'src/Application.vala',
    'src/Settings/Settings.vala',
    'src/Utils/FileLister.vala',
    'src/Utils/FilesManager.vala',
    'src/Utils/ValaC.vala',
    'src/Utils/AppTester.vala',
    'src/Utils/OptionsManager.vala',
    'src/Utils/Option.vala',
    'src/Utils/CompileManager.vala',
    'src/Utils/ReportsManager.vala',
    'src/Utils/File.vala',
    'src/Widgets/FilesListBox.vala',
    'src/Widgets/FilesListRow.vala',
    'src/Widgets/ProjectPage.vala',
    'src/Widgets/WelcomePage.vala',
    'src/Widgets/ReportPage.vala',
    'src/Widgets/OptionsSidebar.vala',
    'src/Widgets/OptionsListBox.vala',
    'src/Widgets/OptionsListRow.vala',
    'src/Widgets/AddOptionsDialog.vala',
    'src/Widgets/HeaderBar.vala',
    'src/Widgets/MainStack.vala',
    dependencies: [
        dependency('gtk+-3.0'),
        dependency('granite'),
    ],
    install: true
)

#Translate and install our .desktop file
i18n.merge_file(
    input: join_paths('data', meson.project_name() + '.desktop.in'),
    output: meson.project_name() + '.desktop',
    po_dir: join_paths(meson.source_root(), 'po'),
    type: 'desktop',
    install: true,
    install_dir: join_paths(get_option('datadir'), 'applications')
)

#Translate and install our .appdata file
i18n.merge_file(
    input: join_paths('data', meson.project_name() + '.appdata.xml.in'),
    output: meson.project_name() + '.appdata.xml',
    po_dir: join_paths(meson.source_root(), 'po'),
    install: true,
    install_dir: join_paths(get_option('datadir'), 'metainfo')
)

subdir('po')
subdir('data')
meson.add_install_script('meson/post_install.py')
