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
    public class CompileReport : Gtk.ListBox{
        public static CompileReport instance = null;
        public static CompileReport get_instance () {
            if (instance == null) {
                instance = new CompileReport ();
            };
            return instance;
        }
        
        public CompileReport () {
            this.selection_mode = Gtk.SelectionMode.NONE;
        }
        
        public void populate (Utils.ErrorObject[] error_object_array) {
            int banana = 1;
            foreach (Utils.ErrorObject error_object in error_object_array) {
                string[] data = error_object.get_data ();
                message ("-----" + banana.to_string () + "-----");
                var compile_item = new Widgets.CompileItem (data);
                banana ++;
                this.prepend (compile_item);
            };
            this.show_all ();
        }
        
        public void clear_list () {
            debug ("IM HERE IM HERE IM HERE IM HERE IM HERE IM HERE ");
            this.get_children ().foreach ((child) => {
                child.destroy ();
            });
        }
    }
}
