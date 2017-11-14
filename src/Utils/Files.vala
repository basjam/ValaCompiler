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

    public class Files : GLib.Object{
        public Utils.FileLister files_lister;
        public List<string> files_array;
        public List<string> cleaned_files_array;
        public Window window;

        public signal void files_array_ready ();

        public static Files instance = null;
        public static Files get_instance () {
            if (instance == null) {
                instance = new Files ();
            };
            return instance;
        }

        construct {
            List<string> files_array = new List<string> ();
            List<string> cleaned_files_array = new List<string> ();
            files_lister = Utils.FileLister.get_instance ();
            files_lister.found_a_file.connect ((file) => {
                add_file (file);  
            });

            files_lister.listing_files_done.connect (() => {
                clean_up_list ();
            });
        }

        public void add_file (string file){
            files_array.append (file);
            return;
        }

        public void clear_files_array () {
            files_array.foreach ((item) => {
                files_array.remove (item);
            });

            cleaned_files_array.foreach ((item) => {
                cleaned_files_array.remove (item);
            });
        }

        public string get_file_array_length () {
            return files_array.length ().to_string ();
        }

        public void clean_up_list () {
            string parent_folder = "";
            int count = 0;
            string item_temp = "";
            List<string> temp1_files_array = new List<string> ();
            List<string> temp2_files_array = new List<string> ();

            //Removes un-printable elements eg.(enter/new line) symbols
            files_array.foreach ((item) =>{
                temp1_files_array.append (item.strip ());
            });

            //Remove uneccessarry items <--Bad spelling, intentional.
            temp1_files_array.foreach ((item) => {
                if (item.has_suffix ("*") || item.has_suffix (".:") || item.has_suffix ("/") || item == ""){
                    temp1_files_array.remove (item);
                }
            });

            //Arrange items into hierarchy & Remove parents from list` <--Bad spelling, probably??.
            temp1_files_array.foreach ((item) => {
                if (item.has_prefix ("./")){
                    temp1_files_array.remove (item);
                    parent_folder = item.slice (2,item.length - 1) + "/";
                } else {
                    item_temp = parent_folder + item;
                    temp2_files_array.append (item_temp);
                }
            });

            //Only keep .vala, .vapi, .gs, and .c files <-- compilable by valac
            temp2_files_array.foreach ((item) => {
                if (item.has_suffix (".vala") || item.has_suffix (".vapi")
                    || item.has_suffix (".gs") || item.has_suffix (".c")) {
                    cleaned_files_array.append (item);
                }
             });
            files_array_ready ();
        }

        public List<string> get_files_array () {
            return cleaned_files_array.copy ();
        }
    }
}
