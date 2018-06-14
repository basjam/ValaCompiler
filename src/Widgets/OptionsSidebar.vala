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
    public class OptionsSidebar : Gtk.Box {
        public Gtk.Box options_pane;
        public Gtk.Box options_checkbutton_box;
        public Gtk.Label options_label;
        public bool toggle_options_pane;
        public Gtk.Stack options_pane_stack;
        
        public Widgets.AddOptionsDialog add_options_dialog;
        public Widgets.OptionsListBox options_list_box;
        
        public Utils.OptionsManager options_manager;

        construct {
            this.orientation = Gtk.Orientation.VERTICAL;
            this.margin = 0;
            this.halign = Gtk.Align.END;
            this.valign = Gtk.Align.FILL;
            this.resize_mode = Gtk.ResizeMode.PARENT;
            
            
            options_pane_stack = new Gtk.Stack ();
            options_pane_stack.hexpand = true;
            options_pane_stack.transition_duration = 350;
            options_pane_stack.width_request = 1;
            
            var nothing_grid = new Gtk.Grid ();
            nothing_grid.width_request = 0;
            options_pane_stack.add_named (nothing_grid, "nothing");

            options_pane = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            options_pane.hexpand = true;
            options_pane.margin_right = 0;
            options_pane.pack_end (new Gtk.Separator (Gtk.Orientation.HORIZONTAL), false, false,0);
            
            options_checkbutton_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            options_checkbutton_box.hexpand = true;

            var options_label = new Gtk.Label (_("Options"));
            options_label.margin = 6;
            
            
            var add_option_button = new Gtk.Button.from_icon_name ("list-add", Gtk.IconSize.LARGE_TOOLBAR);
            add_option_button.relief = Gtk.ReliefStyle.NONE;
            add_option_button.hexpand = false;
            add_option_button.halign = Gtk.Align.END;
            add_option_button.tooltip_text = _("Add options");
            add_option_button.clicked.connect (() => {
                add_options ();
            });
            
            var clear_all_button = new Gtk.Button.from_icon_name ("edit-clear-all-symbolic",Gtk.IconSize.LARGE_TOOLBAR);
            clear_all_button.relief = Gtk.ReliefStyle.NONE;
            clear_all_button.hexpand = false;
            clear_all_button.halign = Gtk.Align.START;
            clear_all_button.tooltip_text = _("Clear all options");
            clear_all_button.clicked.connect (() => {
                clear_all_options ();
            });
            
            var button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            button_box.add (clear_all_button);
            button_box.pack_end (add_option_button, false, true, 0);
             
            options_checkbutton_box.pack_start (options_label, false, true, 0);
            options_checkbutton_box.pack_start (new Gtk.Separator (Gtk.Orientation.HORIZONTAL), false, true, 0);
            options_checkbutton_box.pack_end (button_box, false, true, 0);
                
            var options_scroll = new Gtk.ScrolledWindow (null, null);
            options_scroll.kinetic_scrolling = true;
            options_scroll.expand = true;
            options_scroll.vscrollbar_policy = Gtk.PolicyType.AUTOMATIC;
            options_scroll.hscrollbar_policy = Gtk.PolicyType.NEVER;
            options_list_box = Widgets.OptionsListBox.get_instance ();
            options_scroll.add (options_list_box);
            
            options_checkbutton_box.pack_start (options_scroll, false, true, 0);
            
            options_pane.pack_start (options_checkbutton_box, false, true, 0);
            
            var options_pane_hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);

            options_pane_hbox.get_style_context ().add_class (Gtk.STYLE_CLASS_BACKGROUND);
            options_pane_hbox.pack_start (new Gtk.Separator (Gtk.Orientation.VERTICAL), false, false, 0);
            options_pane_hbox.pack_end (options_pane, false, true, 0);
            options_pane_hbox.margin_bottom = 0;

            options_pane_stack.add_named (options_pane_hbox, "options");
            
            toggle_options_pane = settings.options_button;
            this.add (options_pane_stack);
            toggle_visibility ();
        }

        public string[] get_checkbuttons_status () {
            string[] options_string = {};
            return options_string;
        }

        public void toggle_visibility () {
            toggle_options_pane = settings.options_button;

            if (toggle_options_pane) {
                this.show_all ();
                options_pane_stack.set_visible_child_full ("options", Gtk.StackTransitionType.SLIDE_LEFT);
            } else {
                options_pane_stack.set_visible_child_full ("nothing", Gtk.StackTransitionType.SLIDE_RIGHT);
                this.width_request = options_pane_stack.width_request;
                
                //Trick from https://wiki.gnome.org/Projects/Vala/AsyncSamples to sleep until the stack transition finishes
                hide_options.begin (() => {
                    if (!settings.options_button) {
                        this.hide ();
                    };
                });
            };
        }
        
        private async void hide_options () {
            uint duration = options_pane_stack.transition_duration;
            yield transition_finished (duration);
        }
        
        public async void transition_finished (uint duration, int priority = GLib.Priority.DEFAULT) {
            GLib.Timeout.add (duration, () => {
                transition_finished.callback ();
                return false;
            }, priority);
            yield;
        }
        
        public void add_options () {
            add_options_dialog =  new Widgets.AddOptionsDialog ();
            add_options_dialog.signal_add_options.connect ((options_incoming) => {
                options_list_box.add_options (options_incoming);
            });
            add_options_dialog.show_all ();
        }
        
        public void clear_all_options () {
            options_list_box.set_options (null);
        }
    }
}
