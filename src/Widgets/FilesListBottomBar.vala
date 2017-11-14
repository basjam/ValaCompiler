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
    public class BottomBar : Gtk.Box {

        public signal void change_location ();
        public signal void compile (string[] custom_options);
        public Gtk.Entry custom_options_entry;


        construct {
            //height_request = 25;
            this.margin = 0;
            //this.get_style_context ().add_class (Granite.STYLE_CLASS_CARD);
            var change_location_button = new Gtk.Button ();
            change_location_button.image = new Gtk.Image.from_icon_name ("folder-open",Gtk.IconSize.DND);
            change_location_button.halign = Gtk.Align.START;
            change_location_button.tooltip_text = _("Change source folder");
            change_location_button.margin = 5;

            change_location_button.clicked.connect (() => {
                change_location ();
            });
            this.pack_start (change_location_button, false, false, 10);

            var middle_box = new Gtk.Box (Gtk.Orientation.VERTICAL,2);
            var entry_label = new Gtk.Label (_("Custom valac options"));
            middle_box.add (entry_label);
            middle_box.margin_bottom = 5;

            custom_options_entry = new Gtk.Entry ();
            if (settings.custom_compile_options == "") {
                custom_options_entry.placeholder_text = "Options separated a space eg: --pkg=granite --pkg=gtk+-3.0";
            } else {
                custom_options_entry.text = settings.custom_compile_options;
            };
            middle_box.add (custom_options_entry);

            this.pack_start (middle_box, true, true, 5);
            middle_box.hide ();

            var compile_button = new Gtk.Button.with_label (_("Compile"));
            compile_button.tooltip_text = _("Compile");
            compile_button.margin = 5;

            compile_button.clicked.connect (() => {
                settings.custom_compile_options = custom_options_entry.text;
                string custom_option_string = custom_options_entry.get_text ();
                string[] custom_options_array = custom_option_string.split_set (" ");
                compile (custom_options_array);
            });

            this.pack_end (compile_button, false, false, 10);
        }
    }
}
