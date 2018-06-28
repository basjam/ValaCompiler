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
    public class CompileParser {
        public Utils.FilesManager files_manager;
        
        private string last_report;
        
        private string[] return_data;
        
        
        public static CompileParser instance = null;
        public static CompileParser get_instance () {
            if (instance == null) {
                instance = new CompileParser ();
            };
            return instance;
        }
        
        public CompileParser () {
            files_manager = Utils.FilesManager.get_instance ();
        }
        
        public ErrorObject[] parse (string report) {
            string[] lines = report.split ("\n");
            int line_number = 1;
            
            ErrorObject[] error_object_array = {};
            
            string[] current_object_items = {};
            
            string[] files = files_manager.get_files ();
            
            foreach (string line in lines) {
                if (line_number == 1) {
                    foreach (string file in files) {
                        if (line.contains (file)) {
                            string[] line_split = line.split (":");
                            //string file_name = line_split[0];
                            //string error_location = line_split[1];
                            //string type = line_split[2];
                            //string content = line_split[3];
                            
                            current_object_items += line_split[0];
                            current_object_items += line_split[1];
                            current_object_items += line_split[2].strip ();
                            current_object_items += line_split[3].strip ();
                        };
                    };
                };
                
                if (line_number == 2) {
                    string quoted_text = line;
                    current_object_items += quoted_text;
                };
                
                if (line_number == 3) {
                    string highlighted_text = line;
                    current_object_items += highlighted_text;
                    var error_object = make_object (current_object_items);
                    if (error_object != null) {
                        error_object_array += error_object;
                    };
                };
                
                if (line_number < 3) {
                    line_number ++;
                } else {
                    line_number = 1;
                    current_object_items = {};
                };
            };
            
            return error_object_array;
        }
        
        private ErrorObject make_object (string[] items) {
            if (items != null) {
                return new ErrorObject (items);
            }
            return null;
        }
    }
}
