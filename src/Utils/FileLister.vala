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

namespace ValaCompiler.Utils {

    public class FileLister {
        public signal void found_a_file (string file);
        public signal void listing_files_done ();

        public ValaCompiler.Utils.FilesManager files_manager;

        public static FileLister instance = null;
        public static FileLister get_instance () {
            if (instance == null) {
                instance = new FileLister ();
            };
            return instance;
        }

        public async void scan_files (string location) {
            //stdout.printf ("check: begin scan_files \n");
            try {
                string[] spawn_args = {"ls", "-B", "-R", "--file-type"};
                string[] spawn_env = Environ.get ();
                Pid child_pid;

                int standard_error;
                int standard_output;
                int standard_input;

                Process.spawn_async_with_pipes (
                    location,
                    spawn_args,
                    spawn_env,
                    SpawnFlags.SEARCH_PATH | SpawnFlags.DO_NOT_REAP_CHILD,
                    null,
                    out child_pid,
                    out standard_input,
                    out standard_output,
                    out standard_error);

                // stdout:
                IOChannel output = new IOChannel.unix_new (standard_output);
                output.add_watch (IOCondition.IN | IOCondition.HUP, (channel, condition) => {
                    return process_line (channel, condition, "stdout");
                });

                // stderr:
                IOChannel error = new IOChannel.unix_new (standard_error);
                error.add_watch (IOCondition.IN | IOCondition.HUP, (channel, condition) => {
                    return process_line (channel, condition, "stderr");
                });

                ChildWatch.add (child_pid, (pid, status) => {
                    Process.close_pid (pid);
                });
            } catch (SpawnError e) {
                stdout.printf ("Error:  %s\n", e.message);
            }
            return;
        }

        public bool process_line (IOChannel channel, IOCondition condition, string stream_name) {
            if (condition == IOCondition.HUP) {

                //stdout.printf ("%s: The fd has been closed.\n", stream_name);
                if (stream_name == "stdout"){
                    listing_files_done ();
                };
                //stdout.printf ("check 2 \n");
                return false;
            }

            try {
                string line;
                channel.read_line (out line, null, null);
                //stdout.printf ("%s: %s", stream_name, line);
                found_a_file (line.to_string ());
                } catch (IOChannelError e) {
                    stdout.printf ("%s: IOChannelError: %s\n", stream_name, e.message);
                    return false;
                } catch (ConvertError e) {
                    stdout.printf ("%s: ConvertError: %s\n", stream_name, e.message);
                    return false;
                }
            return true;
        }
    }
}
