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
    public class AppTester {
        public signal void test_line_out (string line);
        public signal void test_done ();
        public signal void kill_test_signal (string kill_report);
        private string test_pids = "";

        public static AppTester instance = null;
        public static AppTester get_instance () {
            if (instance == null) {
                instance = new AppTester ();
            };
            return instance;
        }

        public async void test_app (string location) {
            try {
                string[] spawn_args = {"./TEST"};
                string[] spawn_env = Environ.get ();
                Pid child_pid;

                int standard_input;
                int standard_output;
                int standard_error;

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

                    test_pids += child_pid.to_string () + " ";

                    IOChannel output = new IOChannel.unix_new (standard_output);
                    output.add_watch (IOCondition.IN | IOCondition.HUP, (channel, condition) => {
                        return process_line (channel, condition, "stdout");
                    });

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
                if (stream_name == "stdout"){
                    test_done();
                    //print ("ValaC: " + stream_name + " is done. \n");
                };
                if (stream_name == "stderr"){
                    //print ("ValaC: " + stream_name + " is done.\n");
                }
                return false;
            }

            try {
                string line;
                channel.read_line (out line, null, null);
                test_line_out (line);
                //print ("ValaC: " + stream_name + ": " + line );
            } catch (IOChannelError e) {
                stdout.printf ("%s: IOChannelError: %s\n", stream_name, e.message);
            } catch (ConvertError e) {
                stdout.printf ("%s: ConvertError: %s\n", stream_name, e.message);
            }
        return true;
        }

        public void kill_test () {
            if (check_test_running ()) {
                kill_test_signal (" - TEST was Killed.\n");
            } else {
                kill_test_signal (" - There are no instances of TEST to kill. \n");
            }
            
            string command = "kill " + test_pids;
            string stdout;
            string stderr;
            int status;

            try {
                Process.spawn_command_line_sync (
                    command,
                    out stdout,
                    out stderr,
                    out status
                );
            } catch (SpawnError e) {
                print ("Error: %s\n", e.message);
            }

            test_pids = "";
        }

        public bool check_test_running () {
            string[] pids = test_pids.split (" ");
            
            string stdout;
            string stderr;
            int status;

            try {
                Process.spawn_command_line_sync (
                    "ps -e",
                    out stdout,
                    out stderr,
                    out status
                );
            } catch (SpawnError e) {
                print ("Error: %s\n", e.message);
            }

            foreach (string pid in pids) {
                if (stdout.contains (pid) && pid != "") {
                    return true;
                }
            }
            return false;
        }
    }
}
