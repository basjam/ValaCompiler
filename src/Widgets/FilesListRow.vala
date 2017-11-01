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

    public class FilesListRow : Gtk.ListBoxRow{

        //ValaCompiler.Utils.FilesManager files_manager;

        public string file;

        public Gtk.Box content;
        public Gtk.Image icon;
        public Gtk.Label file_title;

        construct {


        }

        public FilesListRow (string incoming_file) {
            this.file = incoming_file;

            build_ui ();
        }

        public void build_ui (){
            this.tooltip_text = _("Click to toggle compiling");

            var event_box = new Gtk.EventBox ();
            content = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            content.margin = 12;
            content.spacing = 12;

            content.margin_top = content.margin_bottom = 6;
            content.halign = Gtk.Align.FILL;
            event_box.add (content);

            icon = new Gtk.Image ();
            icon.get_style_context ().add_class ("card");
            icon.halign = Gtk.Align.CENTER;
            icon.tooltip_text = _("Click to toggle compiling");
            icon.set_from_icon_name ("user-available", Gtk.IconSize.DND);

            content.pack_end (icon, false, false, 0);

            file_title = new Gtk.Label (this.file);
            file_title.xalign = 0;
            file_title.ellipsize = Pango.EllipsizeMode.START;
            content.pack_start (file_title, true, true, 0);

            this.add (event_box);
            this.halign = Gtk.Align.FILL;

        }

        public string get_file_address () {
            return file;
        }


    }
}
