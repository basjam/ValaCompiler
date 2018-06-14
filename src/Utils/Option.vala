/***
  BEGIN LICENSE
  Copyright (C) 2018 Basem Kheyar<basjam@gmail.com>
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

namespace ValaCompiler.Utils {
    public class Option {
        public string option {set; get;}
        public bool active {set; get;}
        
        public Option (string option_incoming, bool active_incoming) {
            this.option = option_incoming;
            this.active = active_incoming;
        }
    }
}
