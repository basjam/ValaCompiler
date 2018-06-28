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
    public class ReportPage : Gtk.Box {
        public Widgets.CompileReport compile_report;
        public Granite.Widgets.ModeButton view_button;
        
        public static ReportPage instance = null;
        public static ReportPage get_instance () {
            if (instance == null) {
                instance = new ReportPage ();
            };
            return instance;
        }
        
        public ReportPage () {
            compile_report = Widgets.CompileReport.get_instance ();
            
            var compile_scroll = new Gtk.ScrolledWindow (null, null);
            compile_scroll.hscrollbar_policy = Gtk.PolicyType.NEVER;
            compile_scroll.add (compile_report);
            
            
            
            var stack = new Gtk.Stack ();
            stack.add (compile_scroll);
            
            this.orientation = Gtk.Orientation.VERTICAL;
            this.pack_start (stack);
            
            view_button = new Granite.Widgets.ModeButton ();
        }
    }
}
