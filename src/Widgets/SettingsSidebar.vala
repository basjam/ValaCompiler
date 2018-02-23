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
    public class SettingsSidebar : Gtk.Overlay {
        public Gtk.Box options_pane;
        public Gtk.Box options_checkbutton_box;
        public Gtk.CheckButton gtk_checkbutton;
        public Gtk.CheckButton granite_checkbutton;
        public Gtk.Label options_label;
        public Gtk.CheckButton show_c_warnings_checkbutton;
        public bool toggle_options_pane;
        public Gtk.Stack options_pane_stack;

        construct {
            options_pane_stack = new Gtk.Stack ();
            options_pane_stack.set_transition_type (Gtk.StackTransitionType.SLIDE_LEFT_RIGHT);
            options_pane_stack.homogeneous = false;
            options_pane_stack.transition_duration = 350;

            options_pane = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            options_pane.margin_right = 0;
            //options_pane.pack_start (new Gtk.Separator (Gtk.Orientation.HORIZONTAL), false, true, 0);
            options_pane.pack_end (new Gtk.Separator (Gtk.Orientation.HORIZONTAL), false, true,0);

            options_checkbutton_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

            var options_label = new Gtk.Label (_("Options"));
            options_label.margin = 6;
            options_checkbutton_box.pack_start (options_label, false, false,0);
            options_checkbutton_box.pack_start (new Gtk.Separator (Gtk.Orientation.HORIZONTAL), false, false, 0);

            gtk_checkbutton = new Gtk.CheckButton.with_label ("gtk+-3.0");
            gtk_checkbutton.active = settings.gtk;
            options_checkbutton_box.pack_start (gtk_checkbutton, false, false, 2);

            granite_checkbutton = new Gtk.CheckButton.with_label ("grante");
            granite_checkbutton.active = settings.granite;
            options_checkbutton_box.pack_start (granite_checkbutton, false, false, 2);

            show_c_warnings_checkbutton = new Gtk.CheckButton.with_label ("Report C Warnings");
            show_c_warnings_checkbutton.active = settings.show_c_warnings;
            options_checkbutton_box.pack_start (show_c_warnings_checkbutton, false, false, 2);

            options_pane.pack_start (options_checkbutton_box, true, true, 0);
            var nothing_grid = new Gtk.Grid ();
            nothing_grid.width_request = 0;
            options_pane_stack.add_named (nothing_grid, "nothing");


            var options_pane_hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            options_pane_hbox.pack_start (new Gtk.Separator (Gtk.Orientation.VERTICAL), false, false, 0);
            options_pane_hbox.pack_end (new Gtk.Separator (Gtk.Orientation.VERTICAL), false, false, 0);
            options_pane_hbox.pack_end (options_pane, false, false, 0);
            options_pane_hbox.margin_bottom = 0;

            options_pane_stack.add_named (options_pane_hbox, "options");

            this.add (options_pane_stack);
        }

        public string[] get_checkbuttons_status () {
            string[] options_string = {};
            if (gtk_checkbutton.active == true) {
                options_string += "--pkg=gtk+-3.0";
            };
            if (show_c_warnings_checkbutton.active == false) {
                options_string += "-X";
                options_string += "-w";
            };
            if (granite_checkbutton.active == true) {
                options_string += "--pkg=granite";
            }

            return options_string;
        }

        public void toggle_visibility (bool show) {
            toggle_options_pane = show;

            if (options_pane_stack.get_visible_child_name () == "nothing" && toggle_options_pane) {
                options_pane.show ();
                options_pane_stack.set_visible_child_full ("options", Gtk.StackTransitionType.SLIDE_LEFT);
            } else if (options_pane_stack.get_visible_child_name () == "options" && !toggle_options_pane) {
                options_pane_stack.width_request = options_pane_stack.get_allocated_width ();
                options_pane_stack.set_visible_child_full ("nothing", Gtk.StackTransitionType.SLIDE_RIGHT);

                options_pane.hide ();
                options_pane_stack.width_request = 0;
            };
        }
    }
}
