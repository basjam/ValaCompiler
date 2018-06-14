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
    public class AddOptionsDialog : Gtk.Dialog {
        private Gtk.Entry options_entry;
        private Gtk.Button add_options_button;

        public signal void signal_add_options (string[] options);
        
        public AddOptionsDialog () {
            this.border_width = 6;
            build_ui ();
        }

        public void build_ui () {
            var label = new Gtk.Label (_("Enter options separated by a space eg: --pkg=granite --pkg=gtk+-3.0"));

            options_entry = new Gtk.Entry ();
            options_entry.activate.connect (() => {
                add_options ();
            });
            
            add_options_button = new Gtk.Button.from_icon_name ("list-add", Gtk.IconSize.SMALL_TOOLBAR);
            add_options_button.relief = Gtk.ReliefStyle.NONE;
            add_options_button.tooltip_text = _("Add options");
            add_options_button.clicked.connect (() => {
                add_options ();
            });

            var box = get_content_area () as Gtk.Box;
            box.add (label);
            box.add (options_entry);

            var headerbar = new Gtk.HeaderBar ();
            //TODO figure out why headerbar.title does not work. Using subtitle for now.
            headerbar.subtitle = _("Add options");
            headerbar.show_close_button = true;
            headerbar.pack_end (add_options_button);

            this.set_titlebar (headerbar);
            
            var window = Window.get_instance ();
            this.set_transient_for (window);
        }

        private void add_options () {
            string[] options = parse_options (options_entry.text);;
            signal_add_options (options);
            destroy ();
        }

        private string[] parse_options (string text) {
            string[] options_temp = text.split (" ");
            string[] options = null;
            //next step is to remove items added accidentaly by a multiple spaces in a row
            foreach (string option in options_temp) {
                if (option != "") {
                    options += option;
                };
            };
            return options;
        }
    }
}
