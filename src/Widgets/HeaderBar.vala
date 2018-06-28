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
    public class HeaderBar : Gtk.HeaderBar {
        public Gtk.Button forward_button;
        public Gtk.Button back_button;
        public Gtk.Button compile_button;
        public Gtk.Button test_button;
        public Gtk.Button kill_test_button;
        public Gtk.ToggleButton options_button; 
        
        public Widgets.MainStack main_stack;
        public Widgets.ProjectPage project_page;
        public Utils.AppTester app_tester;
        public Utils.CompileManager compile_manager;
        public Utils.ValaC valac;
        public Utils.ReportsManager reports_manager;
        
        public static HeaderBar instance = null;
        public static HeaderBar get_instance () {
            if (instance == null) {
                instance = new HeaderBar ();
            };
            return instance;   
        }
        
        
        
        construct {
            app_tester = Utils.AppTester.get_instance ();
            app_tester.test_done.connect (() => {
                update_buttons ();
            });
            compile_manager = Utils.CompileManager.get_instance ();
            valac = Utils.ValaC.get_instance ();
            valac.compile_done.connect (() => {
                check_test_ready ();
            });            
            project_page = Widgets.ProjectPage.get_instance ();
            reports_manager = Utils.ReportsManager.get_instance ();
            
            this.set_show_close_button (true);
            this.height_request = 47;
            
            back_button = new Gtk.Button.from_icon_name ("go-previous-symbolic", Gtk.IconSize.LARGE_TOOLBAR);
            back_button.clicked.connect (() => {
                navigate ("back");
            });
            this.pack_start (back_button);
            
            forward_button = new Gtk.Button.from_icon_name ("go-next-symbolic", Gtk.IconSize.LARGE_TOOLBAR);
            forward_button.clicked.connect (() => {
                navigate ("forward");
            });
            this.pack_start (forward_button);
            
            options_button = new Gtk.ToggleButton ();
            options_button.active = settings.options_button;
            options_button.image = new Gtk.Image.from_icon_name ("open-menu", Gtk.IconSize.LARGE_TOOLBAR);
            options_button.tooltip_text = _("Options");
            options_button.toggled.connect (() => {
                options_toggled ();
            });
            this.pack_end (options_button);
            
            compile_button = new Gtk.Button.from_icon_name ("applications-development-symbolic", Gtk.IconSize.LARGE_TOOLBAR);
            compile_button.clicked.connect (() => {
                compile ();
            });
            compile_button.tooltip_text = _("Compile");
            this.pack_end (compile_button);
            
            
            
            test_button = new Gtk.Button.from_icon_name ("media-playback-start-symbolic", Gtk.IconSize.LARGE_TOOLBAR);
            test_button.tooltip_text = _("Test the app");
            test_button.clicked.connect (() => {
                test_app ();
                navigate ("test-report");
            });
            
            this.pack_end (test_button);
           
            kill_test_button = new Gtk.Button.from_icon_name ("process-stop", Gtk.IconSize.LARGE_TOOLBAR);
            kill_test_button.tooltip_text = _("Kill all running tests");
            kill_test_button.clicked.connect (() => {
                kill_test ();
            });
            
            this.pack_start (kill_test_button);
        }
        
        public void navigate (string instruction) {
            main_stack = Widgets.MainStack.get_instance ();
            main_stack.navigate (instruction);
        }
        
        public void options_toggled () {
            settings.options_button = options_button.active;
            project_page.toggle_options ();
        }
        
        public void compile () {
            compile_manager.compile ();
            navigate ("compile-report");
        }
        
        public void test_app () {
            app_tester.test_app.begin ();
            update_buttons ();
            navigate ("test-report");
        }
        
        public void kill_test () {
            app_tester.kill_test ();
            update_buttons ();
        }
        
        public void update_buttons () {         
            app_tester = Utils.AppTester.get_instance ();
            kill_test_button.visible = app_tester.check_test_running ();
            kill_test_button.sensitive = app_tester.check_test_running ();
            
            test_button.sensitive = app_tester.check_test_exists ();
            
            main_stack = Widgets.MainStack.get_instance ();
            string page = main_stack.get_page ();
            switch (page) {
                case "welcome":
                    subtitle = null;
                    back_button.hide ();
                    forward_button.hide ();
                    compile_button.hide ();
                    test_button.hide ();
                    options_button.hide ();
                    break;
                case "project":
                    subtitle = "(" + settings.project_location + ")";
                    back_button.show ();
                    back_button.tooltip_text = _("Welcome Page");
                    forward_button.show ();
                    forward_button.tooltip_text = _("Report Page");
                    forward_button.sensitive = true;
                    compile_button.show ();
                    compile_button.sensitive = true;
                    check_test_ready ();
                    options_button.show ();
                    break;
                case "report":
                    subtitle = "(" + settings.project_location + ")";
                    back_button.tooltip_text = _("Project Page");
                    back_button.show ();
                    forward_button.show ();
                    forward_button.sensitive = false;
                    forward_button.tooltip_text = "";
                    check_test_ready ();
                    options_button.hide ();
                    break;                
           };
        }
        
        public void check_test_ready () {
            app_tester = Utils.AppTester.get_instance ();
            test_button.sensitive = app_tester.check_test_exists ();
            test_button.visible = app_tester.check_test_exists ();
        }
    }
}
