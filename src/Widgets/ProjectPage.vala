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
        public Widgets.BottomBar bottom_bar;

        public signal void change_location ();
        public signal void compile (List<string> files);

        construct {
            bottom_bar = new BottomBar ();
            bottom_bar.change_location.connect (() => {
                this.change_location ();
            });
            bottom_bar.compile.connect (() => {
                //TODO add a list array of (1 & 0) to indicate which files are to be compiled
                List<string> files;
                files_list_box = Widgets.FilesListBox.get_instance (false);
                files_list_box.get_files ().foreach ((item) => {
                    files.append (item);
                });
                compile (files);
            });

            this.orientation = Gtk.Orientation.VERTICAL;
            this.pack_end (bottom_bar, false, false, 0);
        }

        public ProjectPage () {
            files_manager = ValaCompiler.Utils.FilesManager.get_instance ();
            files_manager.files_array_ready.connect (() =>{
                clear_list_box ();
                files_list_box = Widgets.FilesListBox.get_instance (true);
                files_list_box.populate (files_manager.get_files_array ());
                this.add (files_list_box);
                this.show_all ();
            });
        }

        public void clear_list_box () {
            this.get_children ().foreach ((item) => {
                if (item == files_list_box) {
                    this.remove (item);
                }
            });
        }
    }
}

