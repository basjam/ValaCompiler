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
        public Widgets.MainStack main_stack;
        public Widgets.HeaderBar header;
        public Widgets.WelcomePage welcome_page;
        public Widgets.ProjectPage project_page;
        public Widgets.ReportPage report_page;
        public Widgets.OptionsListBox options_list_box;
        public Utils.FilesManager files_manager;
        public Utils.ValaC valac;
        public Utils.AppTester app_tester;
        public Utils.OptionsManager options_manager;
        public App app;

        public static Window instance = null;
        public static Window get_instance () {
            if (instance == null) {
                instance = new Window ();
            };
            return instance;
        }

        construct {
            main_stack = Widgets.MainStack.get_instance ();
            welcome_page = Widgets.WelcomePage.get_instance ();
            project_page = Widgets.ProjectPage.get_instance ();
            report_page =  Widgets.ReportPage.get_instance ();

            set_default_geometry (600, 600);
            
            header = Widgets.HeaderBar.get_instance ();
            set_titlebar (header);
            
            main_stack.add_named (welcome_page, "welcome");
            main_stack.add_named (project_page, "project");
            main_stack.add_named (report_page, "report");
            
            add (main_stack);
            main_stack.set_visible_child_full ("welcome", Gtk.StackTransitionType.NONE);
            
            show_all ();
            header.update_buttons ();
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
                string project_location = "";

                try {
                    project_location = Filename.from_uri (folder_chooser.get_uri ());
                } catch (ConvertError e) {
                    debug (e.message);
                };

                start_project (project_location);
                settings.last_folder = folder_chooser.get_current_folder ();
            }
            folder_chooser.destroy ();
        }
        
        public void start_project (string project_location) {
            settings.project_location = project_location;
            
            main_stack.show_project_page ();
            
            files_manager = Utils.FilesManager.get_instance ();
            files_manager.clear_files ();
            files_manager.list_files ();

            options_manager = Utils.OptionsManager.get_instance ();
            options_manager.start_project ();
        }
        
        public void shut_down () {
            options_manager.save_options();
        }
    }
 }