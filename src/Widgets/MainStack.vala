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
    public class MainStack : Gtk.Stack {
        public Widgets.HeaderBar header;
        public Utils.FilesManager files_manager;
        public Widgets.WelcomePage welcome_page;
        public Widgets.ReportPage report_page;
        public App app;
        
        public static MainStack instance = null;
        public static MainStack get_instance () {
            if (instance == null) {
                instance = new MainStack ();
            }
            return instance;   
        }
        
        construct {
            header = Widgets.HeaderBar.get_instance ();
            
            this.expand = true;
            this.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
            
        }
        
        public void navigate (string instruction) {
            switch (instruction) {
                case "back":
                    switch (get_page ()) {
                        case "project":
                            show_welcome_page ();
                            break;
                        case "report":
                            show_project_page ();
                            break;
                    };
                    break;
                case "forward":
                    show_report_page (null);
                    break;
                case "compile-report":
                    show_report_page ("compile");
                    break;
                case "test-report":
                    show_report_page ("test");
                    break;
                
            };
        }
        
        public string get_page () {
            return this.get_visible_child_name ();
        }
        
        public void show_project_page () {
            this.set_visible_child_name ("project");
            header.update_buttons ();
        }


        public void show_report_page (string? panel) {
            this.set_visible_child_name ("report");
            report_page = Widgets.ReportPage.get_instance ();
            
            if (panel == "compile") {
                report_page.view_button.set_active (0);
            } else if (panel == "test") {
                report_page.view_button.set_active (1);
            }
            
            header.update_buttons ();
        }


        public void show_welcome_page () {
            this.set_visible_child_name ("welcome");
            header.update_buttons ();

            files_manager = Utils.FilesManager.get_instance ();
            files_manager.clear_files ();
            
            welcome_page = Widgets.WelcomePage.get_instance ();
            welcome_page.refresh ();

            app = App.get_instance ();
            header.title = app.program_name;
        }
        
    }
}
