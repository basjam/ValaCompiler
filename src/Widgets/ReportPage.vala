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
    public class ReportPage : Gtk.Box {

        public Utils.AppTester app_tester;
        public Utils.ReportsManager reports_manager;
        public Gtk.Box bottom_box;
        public Gtk.Button clear_button;
        public string clear_target;
        public bool compile_failed;
        public Gtk.TextView compile_report;
        public string compile_report_string;
        public Gtk.Stack report_stack;
        public bool test_available;
        public Gtk.TextView test_report;
        public string test_report_string;
        public Gtk.Button undo_button;
        public bool undo_chance_compile;
        public bool undo_chance_test;
        public Utils.ValaC valac;
        public Gtk.ScrolledWindow compile_scroll;
        public Gtk.ScrolledWindow test_scroll;

        public Granite.Widgets.ModeButton view_button;
        
        public static ReportPage instance = null;
        public static ReportPage get_instance () {
            if (instance == null) {
                instance = new ReportPage ();
            };
            return instance;
        }

        construct {
            reports_manager = Utils.ReportsManager.get_instance ();
            this.orientation = Gtk.Orientation.VERTICAL;
            this.spacing = 12;
            this.margin = 0;

            //Granite.Widgets.ModeButton setup
            view_button = new Granite.Widgets.ModeButton ();
            view_button.append_text (_("Compile Report"));
            view_button.append_text (_("Live Test Report"));
            view_button.halign = Gtk.Align.CENTER;

            //Reports View setup
            compile_report_string = "";
            test_report_string = "";

            compile_report = new Gtk.TextView ();
            compile_report.monospace = true;
            compile_report.editable = false;

            test_report = new Gtk.TextView ();
            test_report.monospace = true;
            test_report.editable = false;
            test_report.wrap_mode = Gtk.WrapMode.WORD;

            compile_scroll = new Gtk.ScrolledWindow (null, null);
            compile_scroll.add (compile_report);

            var compile_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);
            compile_box.pack_start (compile_scroll, true, true, 0);

            test_scroll = new Gtk.ScrolledWindow (null, null);
            test_scroll.add (test_report);

            report_stack = new Gtk.Stack ();
            report_stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
            report_stack.add_named (compile_box, "compile");
            report_stack.add_named (test_scroll, "test");

            //Setup bottom_box
            clear_target = "compile";
            clear_button = new Gtk.Button.from_icon_name ("edit-clear-symbolic", Gtk.IconSize.LARGE_TOOLBAR);
            clear_button.relief = Gtk.ReliefStyle.NONE;
            clear_button.tooltip_text = _("Clear Report");
            clear_button.sensitive = target_contains_text ();

            undo_chance_test = false;
            undo_chance_compile = false;
            undo_button = new Gtk.Button.from_icon_name ("edit-undo-symbolic", Gtk.IconSize.LARGE_TOOLBAR);
            undo_button.relief = Gtk.ReliefStyle.NONE;
            undo_button.tooltip_text = _("Undo Last Clear");
            if (undo_chance_compile) {
                undo_button.sensitive = true;
            } else {
                undo_button.sensitive = false;
            };

            bottom_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
            bottom_box.pack_end (clear_button, false, false, 0);
            bottom_box.pack_end (undo_button, false, false, 0);

            //Add stuff to Report Page
            this.pack_start (view_button,false, false, 0);
            this.pack_start (report_stack, true, true, 0);
            this.pack_end (bottom_box, false, false, 0);

            //Setup event listeners
            view_button.mode_changed.connect (() => {
                switch (view_button.selected) {
                    case 0:
                        report_stack.set_visible_child_full ("compile", Gtk.StackTransitionType.SLIDE_RIGHT);
                        clear_button.tooltip_text = _("Clear Report");
                        clear_target = "compile";
                        clear_button.sensitive = target_contains_text ();
                        undo_button.tooltip_text = _("Undo Last Clear");
                        if (undo_chance_compile) {
                            undo_button.sensitive = true;
                        } else {
                            undo_button.sensitive = false;
                        };
                        break;
                    case 1:
                        report_stack.set_visible_child_full ("test", Gtk.StackTransitionType.SLIDE_LEFT);
                        clear_button.tooltip_text = _("Clear Report");
                        clear_target = "test";
                        clear_button.sensitive = target_contains_text ();
                        undo_button.tooltip_text = _("Undo Last Clear");
                        if (undo_chance_test) {
                            undo_button.sensitive = true;
                        } else {
                            undo_button.sensitive = false;
                        };

                        break;
                };
            });

            test_available = false;
            compile_failed = false;
            valac = Utils.ValaC.get_instance ();
            valac.compile_done.connect (() => {
                if (!compile_failed) {
                    test_available = true;
                };
            });

            valac.compile_line_out.connect ((line) => {
                //check for test button
                if (line.contains ("Compilation failed")) {
                    compile_failed = true;
                };

                if (compile_report.buffer.text == "") {
                    compile_report_string = ""; // removes the undo chance
                };
                compile_report_string += " - ";
                compile_report_string += line;
                undo_chance_compile =false;
                undo_button.sensitive = undo_chance_compile;
                clear_button.sensitive = target_contains_text ();
                refresh_compile ();
            });

            app_tester = Utils.AppTester.get_instance ();
            app_tester.test_line_out.connect ((line) => {
                if (test_report.buffer.text == "") {
                    test_report_string = "";  // removes the undo chance
                };
                test_report_string += " - ";
                test_report_string += line;
                undo_chance_test = false;
                undo_button.sensitive = undo_chance_test;
                clear_button.sensitive = target_contains_text ();
                refresh_test ();
            });

            clear_button.clicked.connect (() => {
                switch (clear_target) {
                    case "compile":
                        compile_report.buffer.text = "";  //gives a chance for undo
                        undo_chance_compile = true;
                        break;
                    case "test":
                        test_report.buffer.text = "";  //give a chance for undo
                        undo_chance_test = true;
                        break;
                };
                undo_button.sensitive = true;
                clear_button.sensitive = target_contains_text ();
            });

            undo_button.clicked.connect (() => {
                switch (clear_target) {
                    case "compile":
                        refresh_compile ();
                        break;
                    case "test":
                        refresh_test ();
                        break;
                }
                undo_button.sensitive = false;
                clear_button.sensitive = target_contains_text ();
            });
        }

        public bool target_contains_text () {
            switch (clear_target) {
                case "compile":
                    if (compile_report.buffer.text == "") {
                        return false;
                    } else {
                        return true;
                    };
                case "test":
                    if (test_report.buffer.text == "") {
                        return false;
                    } else {
                        return true;
                    };
            };
            return false; //to be able to compile
        }

        public void refresh_compile () {
            Gtk.TextIter iter;
            compile_report.buffer.text = compile_report_string;
            compile_report.buffer.get_end_iter (out iter);
            compile_report.scroll_to_iter (iter, 0, true ,0 ,0);
        }

        public void refresh_test () {
            Gtk.TextIter iter;
            test_report.buffer.text = test_report_string;
            test_report.buffer.get_end_iter (out iter);
            test_report.scroll_to_iter (iter, 0, true ,0 ,0);

        }

        public void clear_compile_report () {
            compile_report_string = "";
            refresh_compile ();
        }

        public void clear_test_report () {
            test_report_string = "";
            refresh_test ();
        }
    }
}

