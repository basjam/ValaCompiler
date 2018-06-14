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
    public class OptionListRow : Gtk.Box {
        public Gtk.Button remove_button;
        public Gtk.ToggleButton toggle_button;
        public Gtk.Image active_icon;
        private string option;
        private bool active;

        public signal void option_removed (string option);
        public signal void active_changed (string option, bool active);
        
        public OptionListRow (Utils.Option option_incoming) {
            this.active = option_incoming.active;
            this.margin_top = 0;
            this.margin_bottom = 3;
            this.get_style_context ().add_class (Granite.STYLE_CLASS_CARD);
            this.orientation = Gtk.Orientation.HORIZONTAL;
            this.spacing = 0;
            this.hexpand = true;
            this.option = option_incoming.option;
            
            
            remove_button = new Gtk.Button.from_icon_name ("list-remove", Gtk.IconSize.LARGE_TOOLBAR);
            remove_button.margin_top = 1;
            remove_button.margin_bottom = 2;
            remove_button.relief = Gtk.ReliefStyle.NONE;
            remove_button.tooltip_text = _("Remove option");
            remove_button.clicked.connect (() => {
                option_removed (option);
            });


            active_icon = new Gtk.Image ();
            check_active_icon ();
            active_icon.halign = Gtk.Align.START;

            toggle_button = new Gtk.ToggleButton.with_mnemonic (option);
            toggle_button.active = option_incoming.active;
            toggle_button.xalign = 0;
            toggle_button.draw_indicator = true;
            toggle_button.image = active_icon;
            toggle_button.always_show_image = true;
            toggle_button.tooltip_text = _("Click to toggle option");
            toggle_button.toggled.connect (() => {
                this.active = toggle_button.active;
                active_changed (option, active);
                check_active_icon ();
            });

            this.pack_start (toggle_button, true, true, 0);
            this.pack_end (remove_button, false, false, 0);
            this.width_request = 180;
           
        }
        
        public bool get_active () {
            return this.active;
        }
        
        public string get_option () {
            return this.option;
        }
        
        public void check_active_icon () {
            if (active) {
                active_icon.set_from_icon_name ("user-available", Gtk.IconSize.DND);
            } else {
                active_icon.set_from_icon_name ("user-busy", Gtk.IconSize.DND);
            };
        }
    }
}
