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
    public class ProjectPage : Gtk.Box {
        public Widgets.FilesListBox files_list_box;
        public ValaCompiler.Utils.FilesManager files_manager;
        public Gtk.Box middle_box;
        public Widgets.BottomBar bottom_bar;
        public Gtk.Box options_pane;
        public Gtk.CheckButton gtk_checkbutton;
        public Gtk.Box options_checkbutton_box;
        public Gtk.CheckButton granite_checkbutton;
        public Gtk.Label options_label;
        public Gtk.CheckButton show_c_warnings_checkbutton;
        public bool toggle_options_pane;
        public Window window;
        public Gtk.Stack options_pane_stack;

        public signal void change_location ();
        public signal void compile (List<string> files);
        public signal void show_side_pane (bool show);

        public int preferred_width;
        public int nat_width;

        construct {
            middle_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 2);

            options_pane_stack = new Gtk.Stack ();
            options_pane_stack.set_transition_type (Gtk.StackTransitionType.SLIDE_LEFT_RIGHT);
            options_pane_stack.homogeneous = false;
            options_pane_stack.transition_duration = 250;

            options_pane = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            options_pane.margin_right = 0;

            options_checkbutton_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 4);

            gtk_checkbutton = new Gtk.CheckButton.with_label ("gtk+-3.0");
            gtk_checkbutton.active = settings.gtk;
            gtk_checkbutton.get_style_context ().add_class (Granite.STYLE_CLASS_CARD);
            options_checkbutton_box.pack_end (gtk_checkbutton, false, false, 2);

            show_c_warnings_checkbutton = new Gtk.CheckButton.with_label ("Report C Warnings");
            show_c_warnings_checkbutton.active = settings.show_c_warnings;
            options_checkbutton_box.pack_end (show_c_warnings_checkbutton, false, false, 3);

            options_pane.pack_start (options_checkbutton_box, true, true, 3);
            var nothing_grid = new Gtk.Grid ();
            nothing_grid.width_request = 0;
            options_pane_stack.add_named (nothing_grid, "nothing");
            options_pane_stack.add_named (options_pane, "options");
            middle_box.pack_end (options_pane_stack, false, false, 5);

            bottom_bar = new BottomBar ();
            bottom_bar.change_location.connect (() => {
                this.change_location ();
            });
            bottom_bar.compile.connect ((custom_options) => {
                List<string> files;
                files_list_box = Widgets.FilesListBox.get_instance (false);
                files_list_box.get_files ().foreach ((item) => {
                    files.append (item);
                });

                //Parsing options
                string[] options_string = {};
                if (gtk_checkbutton.active == true) {
                    options_string += "--pkg=gtk+-3.0";
                };
                if (show_c_warnings_checkbutton.active == false) {
                    options_string += "-X";
                    options_string += "-w";
                };
                foreach (string item in custom_options) {
                    options_string += item;
                }

                //embed options in files
                foreach (string item in options_string) {
                    files.append (item);
                }
                compile (files);
            });

            this.orientation = Gtk.Orientation.VERTICAL;
            this.pack_start (middle_box, true, true, 2);

            this.pack_end (bottom_bar, false, false, 0);

            //sidepane
            //window = Window.get_instance ();
            show_side_pane.connect ((show) => {
                toggle_options_pane = show;
                //print ("ProjectPage: toggle_options_pane has changed to: " + toggle_options_pane.to_string () + "\n");
                toggle_options ();
            });
        }

        public ProjectPage () {
            files_manager = ValaCompiler.Utils.FilesManager.get_instance ();
            files_manager.files_array_ready.connect (() =>{
                clear_list_box ();
                files_list_box = Widgets.FilesListBox.get_instance (true);
                files_list_box.populate (files_manager.get_files_array ());
                middle_box.pack_start (files_list_box, true, true, 5);
                this.show_all ();
            });
        }

        public void clear_list_box () {
           foreach (var item in middle_box.get_children ()) {
                if (item == files_list_box) {
                    middle_box.remove (item);
                }
            };
        }

        public void toggle_options () {
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

