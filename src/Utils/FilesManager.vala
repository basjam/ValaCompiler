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

namespace ValaCompiler.Utils {
    public class FilesManager : GLib.Object {
        private string location = null;
        public signal void start_project (string location);
        public signal void files_array_ready ();

        public Utils.FileLister file_lister;
        public Utils.Files files;
        public Utils.ValaC valac;

        public List<string> files_array;

        public static FilesManager instance = null;
        public static FilesManager get_instance () {
            if (instance == null) {
                instance = new FilesManager ();
            };
            return instance;
        }

        private FilesManager () {
            file_lister = Utils.FileLister.get_instance ();
            files = Utils.Files.get_instance ();
            files.files_array_ready.connect (() => {
                this.files_array_ready ();
            });

        }

        public void list_files (string location) {
            file_lister = Utils.FileLister.get_instance ();
            file_lister.scan_files.begin (location);
            this.location = location;
        }

        public void add_file (string file){
            files_array.append (file);
            return;
        }

        public string get_file_array_length () {
            return files_array.length ().to_string ();
        }

        public List<string> get_files_array () {
            files = Utils.Files.get_instance ();
            var list = files.get_files_array ();
            return list;
        }

        public void clear_files_array () {
            files = Utils.Files.get_instance ();
            files.clear_files_array ();
        }

        public void compile (List<string> compile_list) {
            string[] compile_list_sending = null;
            foreach (string item in compile_list) {
                compile_list_sending += item;
            }

            valac = Utils.ValaC.get_instance ();
            valac.compile_files.begin (location, compile_list_sending);
        }
    }
}
