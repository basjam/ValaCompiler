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
    public class FilesListBox : Gtk.Box {
        public Utils.FilesManager files_manager;
        public Widgets.ProjectPage project_page;
        public Widgets.FilesListRow row;
        public Gtk.Label file_title;
        public Gtk.Box files_list_box;

        private string[] files_string_array;
        private Utils.File[] files_object_array;
        
        public static FilesListBox instance = null;
        public static FilesListBox get_instance () {
            if (instance == null) {
                instance = new FilesListBox ();
            };
            return instance;
        }
        
        construct {
        }

        public FilesListBox () {
            this.orientation = Gtk.Orientation.VERTICAL;
        }
        //instance retriever with a boolean to create a new instance
        

        public void populate (string[] files_string_array_incoming) {
            files_string_array = files_string_array_incoming;
            build_ui ();
        }

        public void build_ui () {
            this.margin = 0;
            //row_list = new List<Widgets.FilesListRow> ();

            //var event_box = new Gtk.EventBox ();
           
            
            //TOP TITLE REGION;
            file_title = new Gtk.Label (_("Files"));
            file_title.tooltip_text = _("Toggle files to be compiled");
            file_title.halign = Gtk.Align.START;
            file_title.margin = 6;
            file_title.margin_left = 50;
            file_title.ellipsize = Pango.EllipsizeMode.END;

            //FILES REGION
            files_list_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            
            var files_scroll = new Gtk.ScrolledWindow (null, null);
            files_scroll.expand = true;
            files_scroll.kinetic_scrolling = true;
            files_scroll.add (files_list_box);
            files_scroll.get_style_context ().add_class (Gtk.STYLE_CLASS_BACKGROUND);

            //BOTTOM PART
            this.pack_start (file_title, false, false, 0);
            this.pack_start (new Gtk.Separator (Gtk.Orientation.HORIZONTAL), false, false, 0);
            this.pack_start (files_scroll, true, true, 0);
            
            populate_row_list ();
            
            var change_location_button = new Gtk.Button.from_icon_name ("folder-symbolic", Gtk.IconSize.LARGE_TOOLBAR);
            change_location_button.relief = Gtk.ReliefStyle.NONE;
            change_location_button.hexpand = false;
            change_location_button.halign = Gtk.Align.START;
            change_location_button.tooltip_text = _("Change source folder");
            change_location_button.clicked.connect (() => {
                var window = Window.get_instance ();
                window.run_open_folder ();
            });
            
            
            var button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            button_box.pack_start (change_location_button, false, true, 0);
            
            //FINISHING
            this.pack_end (button_box, false, true, 0);         
            this.show_all();
        }

        public void populate_row_list () {
            foreach (string file in files_string_array) {
                var files_list_row = new Widgets.FilesListRow (file);
                files_list_row.active_changed.connect ((file_incoming, active_incoming) => {
                    active_changed (file_incoming, active_incoming);
                });
                
                
                files_object_array += new Utils.File (file, true);
                
                
                files_list_box.add (files_list_row);
            };
        }
        
        public void active_changed (string file_incoming, bool active_incoming) {
            foreach (Utils.File file in files_object_array) {
                if (file.get_file() == file_incoming) {
                    file.set_active (active_incoming);
                };
            }
        }
        
        public Utils.File[] get_files () {
            return this.files_object_array;
        }
        
        public void clear_files () {
            this.get_children ().foreach ((child) => {
                child.destroy ();
            });
            
            files_object_array = {};
            files_string_array = {};
        }
    }
}





