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
    public class ReportsManager {
        //public Widgets.CompileReport compile_report;
        public Utils.CompileParser compile_parser;
        
        public Utils.ValaC valac;
        public Utils.AppTester app_tester;
        
        public Widgets.CompileReport compile_report;
        
        public string[] error_string_array;
        
        public static ReportsManager instance = null;
        public static ReportsManager get_instance () {
            if (instance == null) {
                instance = new ReportsManager ();
            };
            return instance;
        }

        public ReportsManager () {
            //compile_report = Widgets.CompileReport.get_instance ();
            compile_parser = Utils.CompileParser.get_instance ();
            app_tester = Utils.AppTester.get_instance ();
            
            app_tester.test_line_out.connect ((line) => {
                test_line_out (line);
            });
            
            valac = Utils.ValaC.get_instance ();
            valac.compile_line_out.connect ((report) => {
                compile_line_out (report);
            });
            valac.starting.connect (() => {
                clear_list ();
            });
            
            compile_report = Widgets.CompileReport.get_instance ();
        }
        
        public void clear_list () {
            compile_report.clear_list ();
        } 
        
        public void compile_line_out (string report) {
            parse_compile_report (report);
        }

        public void test_line_out (string line) {
        }
        
        public void parse_compile_report (string report) {
            ErrorObject[] error_object_array = compile_parser.parse (report);
            /*For debug
            int object_number = 1;
            foreach (ErrorObject error_object in error_object_array) {
                message ("------" + object_number.to_string () + "---------");
                foreach (string item in error_object.content) {
                    message (item);
                };
                object_number ++;
            };*/
            compile_report.populate (error_object_array);
        }
    }
}
