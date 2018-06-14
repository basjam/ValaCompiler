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

namespace ValaCompiler {
    public Settings settings;

    public class App : Granite.Application {
        public Window window;
        public Utils.OptionsManager options_manager;
        public Widgets.OptionsListBox options_list_box;

        construct {
            program_name = "ValaCompiler";
            exec_name = "com.github.basjam.ValaCompiler";
            application_id = "com.github.basjam.ValaCompiler";
        }

        public App () {
            settings = new Settings ();
            shutdown.connect (() => {
                window.shut_down ();
            });
        }

        private static App app;
        public static App get_instance (){
            if (app == null)
                app = new App ();
            return app;
        }

        public override void activate () {
            settings.project_location = "";
            window = Window.get_instance ();
            window.application = this;
            window.title = program_name;
            
        }
    }
}

public static void main (string[] args){
    var app = ValaCompiler.App.get_instance ();
    app.run (args);
 }
