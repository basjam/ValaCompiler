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

namespace ValaCompiler.Widgets {
    public class ProjectPage : Gtk.Box {
        public Widgets.FilesListBox files_list_box;
        public ValaCompiler.Utils.FilesManager files_manager;
        public Gtk.Box middle_box;
        public Widgets.BottomBar bottom_bar;
        public Window window;
        public Widgets.SettingsSidebar settings_sidebar;

        public signal void change_location ();
        public signal void compile (List<string> files);
        public signal void show_side_pane (bool show);

        public int preferred_width;
        public int nat_width;

        construct {
            middle_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 2);
            
            settings_sidebar = new Widgets.SettingsSidebar ();
            middle_box.pack_end (settings_sidebar, false, false, 5);

            bottom_bar = new BottomBar ();
            bottom_bar.change_location.connect (() => {
                this.change_location ();
            });
            bottom_bar.compile.connect ((custom_options) => {
                List<string> files;
                files_list_box = Widgets.FilesListBox.get_instance (false);
                files_list_box.get_files ().foreach ((item) => {
                    files.append (item);
                });
                
                //get checkbutton options
                string[] options_string = settings_sidebar.get_checkbuttons_status ();
                
                //combine bottom options with checkbuttons
                foreach (string item in custom_options) {
                    options_string += item;
                }
                //embed options in files
                foreach (string item in options_string) {
                    files.append (item);
                }
                compile (files);
            });

            this.orientation = Gtk.Orientation.VERTICAL;
            this.pack_start (middle_box, true, true, 2);

            this.pack_end (bottom_bar, false, false, 0);

            show_side_pane.connect ((show) => {
                toggle_options (show);
            });
        }

        public ProjectPage () {
            files_manager = ValaCompiler.Utils.FilesManager.get_instance ();
            files_manager.files_array_ready.connect (() =>{
                clear_list_box ();
                files_list_box = Widgets.FilesListBox.get_instance (true);
                files_list_box.populate (files_manager.get_files_array ());
                middle_box.pack_start (files_list_box, true, true, 5);
                this.show_all ();
            });
        }

        public void clear_list_box () {
           foreach (var item in middle_box.get_children ()) {
                if (item == files_list_box) {
                    middle_box.remove (item);
                }
            };
        }

        public void toggle_options (bool show) {
            settings_sidebar.toggle_visibility (show);
        }
    }
}

