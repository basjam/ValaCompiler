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
    public class CompileItem : Gtk.Box {
        public Gtk.Box main_box;
        public Gtk.Box inner_box;
        public Gtk.Button show_more_button;
        public Gtk.Image type_image;
        public Gtk.Label file_name;
        public Gtk.Label content;
        
        public Gtk.Revealer revealer;
        
        public string[] data;
        public bool show_more_bool = false;
        
        public CompileItem (string[] data_incoming) {
            this.data = data_incoming;
            foreach (string banana in data) {
                debug (banana);
            };
            this.get_style_context ().add_class (Granite.STYLE_CLASS_CARD);
            
            this.orientation = Gtk.Orientation.HORIZONTAL;
            this.spacing = 0;
            this.margin_top = 0;
            this.margin_bottom = 3;
            this.can_focus = false;
            
            inner_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            
            show_more_button = new Gtk.Button.from_icon_name ("pan-down-symbolic", Gtk.IconSize.LARGE_TOOLBAR);
            show_more_button.relief = Gtk.ReliefStyle.NONE;
            show_more_button.xalign = 0;
            show_more_button.valign = Gtk.Align.START;
            show_more_button.clicked.connect (() => {
                toggle_show_more ();
            });
            
            type_image = new Gtk.Image.from_icon_name ("dialog-warning", Gtk.IconSize.LARGE_TOOLBAR);
            if (data[2] != null) {
                if (data[2].contains ("error")) {
                    type_image.set_from_icon_name ("dialog-error",Gtk.IconSize.LARGE_TOOLBAR);
                    this.get_style_context ().add_class (Granite.STYLE_CLASS_SOURCE_LIST);
                }
            };
            type_image.valign = Gtk.Align.START;
            type_image.margin = 4;
            type_image.can_focus = false;
            

            file_name = new Gtk.Label ("BANANANANA");
            if (data.length > 1) {
                file_name.label = (data[1] + " " + data[0]);
            };
            file_name.halign = Gtk.Align.START;
            file_name.margin_top = 5;
            file_name.margin_bottom = 5;
            file_name.can_focus = false; 
            
            content = new Gtk.Label ("ANOTHER BANANANANANA");
            if (data.length > 5) {
                content.label = data[3] 
                                + "\n" + data[4]
                                + "\n" + data[5];
            };
            content.halign = Gtk.Align.START;
            content.can_focus = false;
            
            revealer = new Gtk.Revealer ();
            revealer.transition_type = Gtk.RevealerTransitionType.SLIDE_DOWN;
            revealer.add (content);
            revealer.can_focus = false;
            
            inner_box.pack_start (file_name, true, true, 0);
            inner_box.pack_end (revealer, false, false, 0);
            inner_box.can_focus = false;
            
            content.visible = show_more_bool;
            
            this.pack_start (type_image, false, false, 0);
            this.pack_start (inner_box, true, true, 0);
            this.pack_end (show_more_button, false, false, 0);
            
        }
        
        public void toggle_show_more () {
            if (!show_more_bool) {
                revealer.set_reveal_child (true);
                show_more_bool = true;
            } else {
                revealer.set_reveal_child (false);
                show_more_bool = false;
            }
        }
    }
}
