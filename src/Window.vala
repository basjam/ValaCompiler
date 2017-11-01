/***
  BEGIN LICENSE
  Copyright (C) 2017 Basem Kheyar<basjam@gmail.com>
  This program is free software: you can redistribute it and/or modify it
  under the terms of the GNU Lesser General Public License version 3, as
  published by the Free Software Foundation.

  This program is distributed in the hope that it will be useful, but
  WITHOUT ANY WARRANTY; without even the implied warranties of
  MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR
  PURPOSE.  See the GNU General Public License for more details.
  You should have received a copy of the GNU General Public License along
  with this program.  If not, see <http://www.gnu.org/licenses>
  END LICENSE
***/

using Granite;

namespace ValaCompiler {

    public class Window : Gtk.Window {

        private Gtk.Stack main_stack;
        private Gtk.HeaderBar header;
        private Widgets.WelcomePage welcome_page;
        private Widgets.ProjectPage project_page;
        //private Settings settings;
        private Widgets.NavigationButton navigation_button;
        public Utils.FilesManager files_manager;
        public App app;

        public Window () {
        }

        public static Window instance = null;
        public static Window get_instance () {
            if (instance == null) {
                instance = new Window ();
            };

            return instance;
        }

        construct {
            welcome_page = new Widgets.WelcomePage ();
            project_page = new Widgets.ProjectPage ();

            set_default_geometry (800, 680);

            header = new Gtk.HeaderBar ();
            header.set_show_close_button (true);
            header.get_style_context ().add_class ("compact");

            navigation_button = new Widgets.NavigationButton ();
            navigation_button.clicked.connect (() => {
                navigate_back ();
            });

            header.pack_start (navigation_button);

            set_titlebar (header);

            main_stack = new Gtk.Stack ();
            main_stack.expand = true;
            main_stack.add_named (welcome_page, "welcome");
            main_stack.add_named (project_page, "project");
            main_stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;


            var overlay = new Gtk.Overlay ();
            overlay.add (main_stack);

            add (overlay);
            show_all ();

            navigation_button.hide ();

            main_stack.set_visible_child_full ("welcome", Gtk.StackTransitionType.NONE);
            stdout.printf ("window: main_stack visible child is: " + main_stack.get_visible_child_name () + "\n");

            project_page.change_location.connect (() => {
                files_manager = Utils.FilesManager.get_instance ();
                files_manager.clear_files_array ();
                run_open_folder ();
            });

            project_page.compile.connect ((files) => {
                compile (files);
            });
        }

        public void run_open_folder () {
            var folder_chooser = new Gtk.FileChooserDialog (_("Select Project Folder"),
                this,
                Gtk.FileChooserAction.SELECT_FOLDER,
                _("Cancel"),
                Gtk.ResponseType.CANCEL,
                _("Open"),
                Gtk.ResponseType.ACCEPT);
           folder_chooser.set_transient_for (this);

           var vala_filter = new Gtk.FileFilter ();
           vala_filter.set_filter_name (_("Vala files"));
           vala_filter.add_pattern ("*.vala");

           var all_files_filter = new Gtk.FileFilter ();
           all_files_filter.set_filter_name (_("All Files"));
           all_files_filter.add_pattern ("*");


           folder_chooser.add_filter (all_files_filter);
           folder_chooser.add_filter (vala_filter);

           //folder_chooser.set_current_folder (settings.last_folder);
            if (folder_chooser.run () == Gtk.ResponseType.ACCEPT) {
                string project_location = folder_chooser.get_uri ();
                //Add a settings file
                //stdout.printf ("window: Selected folder is: " + project_location + " .\n");

                project_location = project_location.substring (7, (project_location.length - 7));
                project_location = project_location.replace ("%20", " ");

                //stdout.printf ("window: Sending folder address is: " + project_location + " .\n");

                start_project (project_location);
                //settings.last_folder = folder_chooser.get_current_folder ();
            }

            folder_chooser.destroy ();
        }

        public void start_project (string project_location) {

            navigation_button.show ();
            files_manager = Utils.FilesManager.get_instance ();
            files_manager.list_files (project_location);
            //settings.project_location = project_location;
            //stdout.printf (settings.project_location);

            main_stack.set_visible_child_full ("project", Gtk.StackTransitionType.SLIDE_LEFT);
            stdout.printf ("window: main_stack visible child is: " + main_stack.get_visible_child_name () + "\n");

        }

        public void navigate_back () {

            navigation_button.hide ();
            files_manager = Utils.FilesManager.get_instance ();
            files_manager.clear_files_array ();
            //project_page.clear_list_box ();

            main_stack.set_visible_child_full ("welcome", Gtk.StackTransitionType.SLIDE_RIGHT);
            stdout.printf ("window: main_stack visible child is: " + main_stack.get_visible_child_name () + "\n");
            return;
        }

        public void compile (List<string> files) {

            files_manager = Utils.FilesManager.get_instance ();
            files_manager.compile (files);
        }


    }
}
