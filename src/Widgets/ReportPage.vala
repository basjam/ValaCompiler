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

        public Gtk.Stack report_stack;
        public Gtk.TextView compile_report;
        public Gtk.TextView test_report;
        public string compile_report_string;
        public string test_report_string;
        public Utils.ValaC valac;


        construct {
            this.orientation = Gtk.Orientation.VERTICAL;
            this.spacing = 2;
            this.margin = 6;
            var view_button = new Granite.Widgets.ModeButton ();
            view_button.append_text (_("Compile Report"));
            view_button.append_text (_("Live Test Report"));
            this.add (view_button);
            compile_report_string = "";
            test_report_string = "";

            compile_report = new Gtk.TextView ();
            compile_report.monospace = true;
            compile_report.editable = false;
            compile_report.buffer.text = compile_report_string;

            test_report = new Gtk.TextView ();
            test_report.monospace = true;
            test_report.editable = false;
            test_report.buffer.text = test_report_string;

            var compile_scroll = new Gtk.ScrolledWindow (null, null);
            compile_scroll.add (compile_report);

            var compile_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);
            compile_box.pack_start (compile_scroll, true, true, 0);


            var test_scroll = new Gtk.ScrolledWindow (null, null);
            test_scroll.add (test_report);

            report_stack = new Gtk.Stack ();
            report_stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
            report_stack.add_named (compile_box, "compile");
            report_stack.add_named (test_scroll, "test");

            this.pack_start (report_stack, true, true, 0);

            view_button.mode_changed.connect (() => {
                switch (view_button.selected) {
                    case 0:
                        report_stack.set_visible_child_full ("compile", Gtk.StackTransitionType.SLIDE_RIGHT);
                        break;
                    case 1:
                        report_stack.set_visible_child_full ("test", Gtk.StackTransitionType.SLIDE_LEFT);
                        break;
                };
            });

            valac = Utils.ValaC.get_instance ();
            valac.compile_line_out.connect ((line) => {
                compile_report_string += line.to_string ();
                //print ("this is a line: " + line);
                refresh ();
            });

        }

        public void refresh () {
            test_report.buffer.text = test_report_string;
            compile_report.buffer.text = compile_report_string;
        }

        public void clear_compile_report () {
            compile_report_string = "";
            refresh ();
        }

        public void clear_test_report () {
            test_report_string = "";
            refresh ();
        }
    }
}
