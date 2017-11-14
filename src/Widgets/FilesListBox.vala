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
        public Widgets.FilesListRow files_list_row;
        public ValaCompiler.Utils.FilesManager files_manager;
        public Widgets.ProjectPage project_page;
        public Widgets.FilesListRow row;
        public Gtk.Label file_title;

        Gtk.ListBox files_list_box;
        List<string> files;

        construct {
        }

        public FilesListBox () {
        }
        //instance retriever with a boolean to create a new instance
        public static FilesListBox instance = null;
        public static FilesListBox get_instance (bool new_instance) {
            if (instance == null || new_instance == true) {
                instance = new FilesListBox ();
            };
            return instance;
        }

        public void populate (List<string> files_incoming) {
            foreach (string item in files_incoming) {
                files.append (item);
            }
            build_ui ();
            show_files ();
        }

        public void build_ui () {
            this.can_focus = false;
            //this.width_request = 300;
            this.margin = 5;

            var content = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            content.spacing = 5;
            content.orientation = Gtk.Orientation.VERTICAL;

            var event_box = new Gtk.EventBox ();
            //event_box.button_press_event.connect (show_context_menu); //need to check this

            //TOP TITLE REGION;
            file_title = new Gtk.Label (_("Files"));
            file_title.tooltip_text = _("Highlight the files you wish to compile");
            file_title.halign = Gtk.Align.START;
            file_title.margin_left = 12;
            file_title.ellipsize = Pango.EllipsizeMode.END;
            event_box.add (file_title);

            //FILES REGION
            files_list_box = new Gtk.ListBox ();
            files_list_box.selection_mode = Gtk.SelectionMode.NONE;
            files_list_box.activate_on_single_click = true;

            var files_scroll = new Gtk.ScrolledWindow (null, null);
            files_scroll.expand = true;
            files_scroll.kinetic_scrolling = true;

            files_scroll.add (files_list_box);

            //FINISHING
            content.pack_start (event_box, false, false, 0);
            content.pack_start (new Gtk.Separator (Gtk.Orientation.HORIZONTAL), false, false, 0);
            content.pack_start (files_scroll, true, true, 0);

            this.add (content);
            this.show_all();
        }

        private void toggle_file () {
        //TODO changing of green light to signify compile to a row && color red to signify compile error
        }

        public void show_files () {
            this.files_list_box.unselect_all ();
            this.files.foreach ((item) => {
                add_file (item);
            });
        }

        public void add_file (string file) {
            row = new ValaCompiler.Widgets.FilesListRow (file);
            this.files_list_box.add (row);
            row.show_all ();
        }

        public List<string> get_files () {
            List<string> files_to_be_sent = new List<string> ();
            foreach (string item in files) {
                files_to_be_sent.append (item);
            };
            return files_to_be_sent;
            /*TODO Make it return a List Array of (1 & 0) that indicate whether a file at the same
            location is to be compiled (maybe by implementing FilesListRow.get_file_address ()??)*/
        }
    }
}
