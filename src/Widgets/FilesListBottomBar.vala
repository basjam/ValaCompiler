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
        public signal void compile ();

        construct {
            //height_request = 25;
            this.margin_bottom = 2;
            var change_location_button = new Gtk.Button ();
            change_location_button.image = new Gtk.Image.from_icon_name ("folder-open",Gtk.IconSize.DND);
            change_location_button.halign = Gtk.Align.START;
            change_location_button.tooltip_text = _("Change source folder");

            change_location_button.clicked.connect (() => {
                change_location ();
            });
            this.pack_start (change_location_button, false, false, 10);

            var compile_button = new Gtk.Button.from_icon_name ("user-available", Gtk.IconSize.DND);
            compile_button.tooltip_text = "Compile";
            compile_button.clicked.connect (() => {
                compile ();
            });

            this.pack_end (compile_button, false, false, 10);


        }

    }

}
