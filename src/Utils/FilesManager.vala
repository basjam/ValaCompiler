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
        public signal void compile_done ();

        public Utils.FileLister file_lister;
        
        public Widgets.FilesListBox files_list_box;
        
        private string[] dirty_files_string_array = {};
        private string[] files_string_array = {};
        
        

        public static FilesManager instance = null;
        public static FilesManager get_instance () {
            if (instance == null) {
                instance = new FilesManager ();
            };
            return instance;
        }

        public FilesManager () {
            file_lister = Utils.FileLister.get_instance ();
            file_lister.found_a_file.connect ((file_string) => {
                add_file (file_string);
            });
            file_lister.listing_files_done.connect (() => {
                clean_up_files_list ();
            });
            
            files_list_box = Widgets.FilesListBox.get_instance ();
        }
        
        public void clean_up_files_list () {
            
            string[] temp_files_string_array = {};
            string[] temp2_files_string_array = {};
            string parent_folder = "";
            string temp_file_string = "";
            
            //Remove empty and unecessary strings
            foreach (string file_string in dirty_files_string_array) {
                file_string = file_string.strip ();
                if (!(file_string.has_suffix ("*") ||
                 file_string.has_suffix (".:") ||
                 file_string.has_suffix ("/") || file_string == "")) {
                    temp_files_string_array += file_string;
                };
            };
            
            //Arrange files inro hierarchy & Remove parents from list
            foreach (string file_string in temp_files_string_array) {
                if (file_string.has_prefix ("./")) {
                    
                    parent_folder = file_string.slice (2, file_string.length - 1) + "/";
                } else {
                   temp_file_string = parent_folder + file_string;
                   temp2_files_string_array += temp_file_string;
                };
            };
            
            //Only keep .vala .vapi .gs. and .c files
            foreach (string file_string in temp2_files_string_array) {
                if (file_string.has_suffix (".vala") || 
                 file_string.has_suffix (".vapi") ||
                 file_string.has_suffix (".gs") ||
                 file_string.has_suffix (".c")) {
                    files_string_array += file_string;
                };
            };
            
            dirty_files_string_array = {};
            populate_files_list_box ();
        }
        
        public void populate_files_list_box () {
            files_list_box = Widgets.FilesListBox.get_instance ();
            files_list_box.populate (files_string_array);
        }
        
        public void add_file (string file){
            dirty_files_string_array += file;
            return;
        }

        public void list_files () {
            location = settings.project_location;
            debug ("starting file_lister.scan");
            file_lister.scan_files.begin (location);
        }

        public string[] get_files () {
            return convert_to_string (files_list_box.get_files ());
        }
        
        public string[] convert_to_string (Utils.File[] file_objects) {
            string[] converted = {};
            foreach (Utils.File file in file_objects) {
                if (file.get_active ()) {
                    converted += file.get_file ();
                };
            };
            
            return converted;
        }

        public void clear_files () {
            files_list_box = Widgets.FilesListBox.get_instance ();
            files_list_box.clear_files ();
            
            dirty_files_string_array = {};
            files_string_array = {};
        }

        public void compile () {
        }
    }
}
