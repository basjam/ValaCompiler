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

        public Utils.ValaC valac;
        public Utils.AppTester app_tester;

        public static ReportsManager instance = null;
        public static ReportsManager get_instance () {
            if (instance == null) {
                instance = new ReportsManager ();
            };
            return instance;
        }

        public ReportsManager () {
            app_tester = Utils.AppTester.get_instance ();
            app_tester.test_line_out.connect ((line) => {
                test_line_out (line);
            });
            valac = Utils.ValaC.get_instance ();
            valac.compile_line_out.connect ((line) => {
                 compile_line_out (line);
            });
        }

        public void compile_line_out (string line) {
            parse_compile_line (line);
        }

        public void test_line_out (string line) {
            debug ("test-line-out: %s", line);
        }
        
        public void parse_compile_line (string line) {
            
        }
        
        

    }
}
