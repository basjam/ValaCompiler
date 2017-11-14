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

namespace ValaCompiler {

    public class Window : Gtk.Window {
        private Gtk.Stack main_stack;
        private Gtk.HeaderBar header;
        private Widgets.WelcomePage welcome_page;
        private Widgets.ProjectPage project_page;
        private Widgets.ReportPage report_page;
        private Widgets.NavigationButton navigation_button;
        public Gtk.ToggleButton options_button;
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
            report_page = new Widgets.ReportPage ();

            set_default_geometry (800, 680);

            header = new Gtk.HeaderBar ();
            header.set_show_close_button (true);
            header.height_request = 47;

            navigation_button = new Widgets.NavigationButton ();
            navigation_button.clicked.connect (() => {
                navigate_back ();
            });
            header.pack_start (navigation_button);

            options_button = new Gtk.ToggleButton ();
            options_button.image = new Gtk.Image.from_icon_name ("open-menu", Gtk.IconSize.LARGE_TOOLBAR);
            header.pack_end (options_button);

            set_titlebar (header);

            main_stack = new Gtk.Stack ();
            main_stack.expand = true;
            main_stack.add_named (welcome_page, "welcome");
            main_stack.add_named (project_page, "project");
            main_stack.add_named (report_page, "report");
            main_stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;

            var overlay = new Gtk.Overlay ();
            overlay.add (main_stack);

            add (overlay);
            show_all ();

            navigation_button.hide ();
            options_button.hide ();

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

            options_button.toggled.connect (() => {
                project_page.show_side_pane (options_button.active);
                //print ("Window: just changed project_page.toggle_options_pane to : " + project_page.toggle_options_pane.to_string () + "\n");
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

            if (folder_chooser.run () == Gtk.ResponseType.ACCEPT) {
                string project_location = folder_chooser.get_uri ();
                //stdout.printf ("window: Selected folder is: " + project_location + " .\n");
                project_location = project_location.substring (7, (project_location.length - 7));
                project_location = project_location.replace ("%20", " ");
                //stdout.printf ("window: Sending folder address is: " + project_location + " .\n");
                start_project (project_location);
                settings.last_folder = folder_chooser.get_current_folder ();
            }
            folder_chooser.destroy ();
        }

        public void start_project (string project_location) {
            navigation_button.show ();
            options_button.show ();
            header.title = header.title + " (" + project_location + ")";
            files_manager = Utils.FilesManager.get_instance ();
            files_manager.list_files (project_location);
            settings.project_location = project_location;
            //stdout.printf (settings.project_location);
            main_stack.set_visible_child_full ("project", Gtk.StackTransitionType.SLIDE_LEFT);
            stdout.printf ("window: main_stack visible child is: " + main_stack.get_visible_child_name () + "\n");
            //ProjectPage sidepane

        }

        public void navigate_back () {
            navigation_button.hide ();
            options_button.hide ();
            files_manager = Utils.FilesManager.get_instance ();
            files_manager.clear_files_array ();
            welcome_page.refresh ();
            app = App.get_instance ();
            header.title = app.program_name;

            switch (main_stack.get_visible_child_name ()) {
                case "project":
                    main_stack.set_visible_child_full ("welcome", Gtk.StackTransitionType.SLIDE_RIGHT);
                    break;
                case "report":
                    main_stack.set_visible_child_full ("project", Gtk.StackTransitionType.SLIDE_RIGHT);
                    break;
            }
            //stdout.printf ("window: main_stack visible child is: " + main_stack.get_visible_child_name () + "\n");
            return;
        }

        public void compile (List<string> files) {

            files_manager = Utils.FilesManager.get_instance ();
            files_manager.compile (files);
            main_stack.set_visible_child_full ("project", Gtk.StackTransitionType.SLIDE_RIGHT);
        }
    }
}
