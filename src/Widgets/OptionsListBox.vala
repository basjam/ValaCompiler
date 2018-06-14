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
    public class OptionsListBox : Gtk.Box {

        private Utils.Option[] options_object_array;
        
        public Utils.OptionsManager options_manager;

        public OptionsListBox () {
            this.orientation = Gtk.Orientation.VERTICAL;
            this.margin = 0;
            this.expand = true;
            
        }

        public static OptionsListBox instance = null;
        public static OptionsListBox get_instance () {
            if (instance == null) {
                instance = new OptionsListBox ();
            };
            return instance;
        }

        public void set_options (Utils.Option[]? options_incoming) {
            if (options_incoming == null) {
                this.options_object_array = {};
            } else {
                this.options_object_array = options_incoming;
            }
            refresh_list ();
        }

        private void refresh_list () {
            
            clear_list ();
            foreach (Utils.Option option in options_object_array) {
                //make & display a new row from each option in local Utils.option
                var option_row = new Widgets.OptionListRow (option);
                this.add (option_row);

                //Link change in row active state with local Utils.Option[] options
                option_row.active_changed.connect ((option, active) => {
                    option_active_change (option, active);
                });

                //Link row removal with local Utils.Option[] options
                option_row.option_removed.connect ((option_string) => {
                    remove_option (option_string);
                    option_row.destroy ();
                });
            };
            show_all ();
        }

        private void option_active_change (string option_incoming, bool active_incoming) {
//go through local Utils.Option and if strings match, match active_incoming
            foreach (Utils.Option option_sift in options_object_array) {
                if (option_sift.option == option_incoming) {
                    option_sift.active = active_incoming;
                };
            };
        }

        private void remove_option (string option_string_incoming) {
//go through local Utils.Option[]. If strings match, remove
            Utils.Option[] temp_options_object_array = {};
            foreach (Utils.Option option_sift in options_object_array) {
                if (option_sift.option != option_string_incoming) {
                    temp_options_object_array += option_sift;
                };
            };
            options_object_array = temp_options_object_array;
        }

        private void clear_list () {
            this.get_children ().foreach ((row) => {
                this.remove (row);
                row.destroy ();
            });
        }

        public Utils.Option[] get_options () {
            return options_object_array;
        }
        
        public void add_options (string[] options_incoming) {
            options_manager = Utils.OptionsManager.get_instance ();
            Utils.Option[] options_object_array_temp = options_manager.convert_to_objects (options_incoming);
            
            foreach (Utils.Option option in options_object_array_temp) {
                options_object_array += option;
            };
            
            set_options (options_object_array);
        }
    }
   }
