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
    public class CompileManager {
        public Utils.ValaC valac;
        public FilesManager files_manager;
        public OptionsManager options_manager;
        public bool test_exists = false;


        public static CompileManager instance = null;
        public static CompileManager get_instance () {
            if (instance == null) {
                instance = new CompileManager ();
            };
            return instance;
        }
        public CompileManager () {
            valac = Utils.ValaC.get_instance ();
            files_manager = Utils.FilesManager.get_instance ();
            options_manager = Utils.OptionsManager.get_instance ();
        }

        
        public void compile () {
            string[] files = files_manager.get_files ();
            string[] options = options_manager.get_options ();
            string[] args = {};
            foreach (string file in files) {
                args += file;
            };
            foreach (string option in options) {
                args += option;
            };
            debug ("Beginning compile process");
            valac.compile.begin (args);
        }
    }
}
