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
        public Gtk.Overlay overlay;
        public Widgets.OptionsSidebar options_sidebar;

        public static ProjectPage instance = null;
        public static ProjectPage get_instance () {
            if (instance == null) {
                instance = new ProjectPage ();
            };
            return instance;
        }        
        
        construct {
            this.instance = this;
            this.margin = 0;
            overlay = new Gtk.Overlay ();
            files_list_box = Widgets.FilesListBox.get_instance ();
            overlay.add (files_list_box);

            this.orientation = Gtk.Orientation.VERTICAL;
            this.pack_start (overlay, true, true, 0);
            
            options_sidebar = new Widgets.OptionsSidebar ();
            overlay.add_overlay (options_sidebar);
        }

        public void toggle_options () {
            options_sidebar.toggle_visibility ();
        }
    }
}

