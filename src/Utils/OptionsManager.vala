/***
  BEGIN LICENSE
  Copyright (C) 2018 Basem Kheyar<basjam@gmail.com>
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
    public class OptionsManager {
        public string location;
        public Widgets.OptionsListBox options_list_box;
        
        private Utils.Option[] options_object_array;
        private string[] options_string_array;

        public static OptionsManager instance = null;
        public static OptionsManager get_instance () {
            if (instance == null) {
                instance = new OptionsManager ();
            };
            return instance;
        }

        public OptionsManager () {
        }

        public void start_project () {
            location = settings.project_location;
            options_list_box = Widgets.OptionsListBox.get_instance ();
            options_list_box.set_options (load_options ());
        }
        
        private Utils.Option[] load_options () {
            string[] processed_options = {};
            string options_raw = "";
            
            if (FileUtils.test (location + "/valacompiler/valacompiler.options",
             GLib.FileTest.EXISTS)) {
                try {
                    FileUtils.get_contents (location +
                     "/valacompiler/valacompiler.options", out options_raw);
                    processed_options = process_options (options_raw);
                } catch (FileError e){
                    debug (e.message);
                }
            } else {
                debug (location +
                  "\nOptionsManager: there is no valacompiler.options file.\n");
            }
            options_object_array = convert_to_objects (processed_options);
            return options_object_array;
        }
        
        private string[] process_options (string raw) {
            //clean up the raw string
            string raw_temp = raw.strip ();
            raw_temp = raw_temp.escape ();
            //split into items by comma "," and save them in the local
            return raw_temp.split (",");
        }
        
        public Utils.Option[] convert_to_objects (string[] options_incoming) {
            //read options so that "<<<NOTACTIVE>>>" means option not active.
            Utils.Option[] temp_options_object_array = null;
            foreach (string option_string in options_incoming) {
                bool active = true;
                //Check and remove "&&" if it exists
                if (option_string.has_prefix ("<<<NOTACTIVE>>>")) {
                    active = false;
                    option_string = option_string.replace ("<<<NOTACTIVE>>>", "");
                };
                
                Utils.Option option_object = new Utils.Option (option_string, active);
                temp_options_object_array += option_object;
            };
            return temp_options_object_array;
        }
        
        public string[] convert_to_string (Utils.Option[] options_incoming) {
            string[] temp_options_string_array = null;
            foreach (Utils.Option option_incoming in options_incoming) {
                string temp_option_string = null;
                //Add "&&" for not compilable files
                if (!option_incoming.active) {
                    temp_option_string = "<<<NOTACTIVE>>>" + option_incoming.option;
                } else {
                    temp_option_string = option_incoming.option;
                };
                temp_options_string_array += temp_option_string;
            };
            return temp_options_string_array;
        }
        
        public void clear_options_list () {
            options_string_array = {};
            options_object_array = {};
            options_list_box.set_options (null);
            location = "";
        }
            
        public void save_options () {
            //Build the string_array from objects_array from options_list_box
            options_list_box = Widgets.OptionsListBox.get_instance ();
            options_object_array = options_list_box.get_options ();
            options_string_array = convert_to_string (options_object_array);
            string to_be_saved = string.joinv (",", options_string_array);
            
            DirUtils.create_with_parents (location + "/valacompiler", 509 );
            
            try {
                FileUtils.set_contents (location + "/valacompiler/valacompiler.options", to_be_saved);
            } catch (FileError e) {
                debug ("Banana" + e.message);
            };
        }
        
        public string[] get_options () {
            save_options ();
            string[] active_options_string_array = {};
            foreach (string option in options_string_array) {
                if (!option.has_prefix ("<<<NOTACTIVE>>>")) {
                    active_options_string_array += option;
                };
            }
            return active_options_string_array;
        }
    }
}
