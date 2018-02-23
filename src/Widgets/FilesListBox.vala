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
        public List<Widgets.FilesListRow> row_list;
        public Gtk.Label file_title;

        public Gtk.ListBox files_list_box;
        public List<string> files;

        public const string FILES_LIST_BOX_STYLESHEET = """
            files-list-box {
                background-color: white;
                color: white;
            }
        """;
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
            populate_row_list ();
            show_files ();
        }

        public void build_ui () {
             Gtk.CssProvider files_list_box_style_provider = new Gtk.CssProvider ();

             try {
                 files_list_box_style_provider.load_from_data (FILES_LIST_BOX_STYLESHEET, -1);
             } catch (Error e) {
                 print ("Styling files-list-box failed: %s", e.message);
             }

            var style_context = this.get_style_context ();
            style_context.add_provider (files_list_box_style_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
            style_context.add_class ("file-list-box");

            this.can_focus = false;
            this.margin = 0;
            row_list = new List<Widgets.FilesListRow> ();

            var content = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

            var event_box = new Gtk.EventBox ();
            //event_box.button_press_event.connect (show_context_menu); //need to check this

            //TOP TITLE REGION;
            file_title = new Gtk.Label (_("Files - Click To Exclude qqpp Files"));
            file_title.tooltip_text = _("Toggle files wish not to compile");
            file_title.halign = Gtk.Align.CENTER;
            file_title.margin = 6;
            file_title.ellipsize = Pango.EllipsizeMode.END;
            event_box.add (file_title);

            //FILES REGION
            files_list_box = new Gtk.ListBox ();
            files_list_box.selection_mode = Gtk.SelectionMode.BROWSE;
            files_list_box.activate_on_single_click = true;
            files_list_box.row_activated.connect ((r) => {
                var row = (Widgets.FilesListRow)r;
                toggle_file (row);
            });


            var files_scroll = new Gtk.ScrolledWindow (null, null);
            files_scroll.expand = true;
            files_scroll.kinetic_scrolling = true;

            files_scroll.add (files_list_box);

            //FINISHING
            content.pack_start (event_box, false, false, 0);
            content.pack_start (new Gtk.Separator (Gtk.Orientation.HORIZONTAL), false, false, 0);
            content.pack_start (files_scroll, true, true, 0);
            content.pack_end (new Gtk.Separator (Gtk.Orientation.HORIZONTAL), false, false, 0);

            this.add (content);
            this.show_all();
        }

        private void toggle_file (Widgets.FilesListRow row) {
        //TODO changing of green light to signify compile to a row && color red to signify compile error
            row.toggle ();
        }

        public void populate_row_list () {
            this.files.foreach ((item) => {
                row_list.append (new Widgets.FilesListRow (item));

            });
        }

        public void show_files () {
            row_list.foreach ((row) => {
                files_list_box.add (row);
            });

        }

        public void clear_row_list () {
            row_list.foreach ((item) => {
                row_list.remove (item);
            });
        }


        public List<string> get_files () {
            List<string> files_to_be_sent = new List<string> ();
            string file_to_be_added = "";

            foreach (var r in row_list) {
                var row = (Widgets.FilesListRow)r;
                if (row.compile_this_file) {
                    file_to_be_added = row.file;
                    //print (row.file + "\n");
                    files_to_be_sent.append (file_to_be_added);
                };
            };

            return files_to_be_sent;
        }
    }
}





