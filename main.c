/*
 * mail.c
 */

#include <bsp.h>
#include <rtems.h>
#include <rtems/bspIo.h>
#include <stdlib.h>
#include <stdio.h>
#include <ile-cli-core.h>
#include <ile-cli-api.h>
#include <ile-cli-config.h>

#include <rtems/shell.h>
#include <rtems/termiostypes.h>

/*
 * my_test_exec()
 */
static int my_test_exec(node_t self, const int argc, char **const argv)
{
  if (argc) {
    for(register int i = 1; i < argc && strcmp(argv[i], "<echo>"); ++i) {
      cli_info_print(ILE_CLI_WHITE_COLOUR, "%s ", argv[i]);
    }
  }
  return 0;
}

/*
 * ile_cli_cmd_tree_build()
 */
int ile_cli_cmd_tree_build(void)
{
  unsigned int i;
  node_t root = ile_command_root_node_get();
  node_t node, echo = ile_cli_cmd_exec_node_add(root, "echo", "echo", my_test_exec);
  for (i = 0, node = echo; node && i < ILE_CLI_MAX_NUM_ARGS; ++i) {
    node = ile_cli_cmd_exec_node_flags_add(node, "<echo>", "<echo>", my_test_exec,
                                           ILE_CMD_FLAG(UNCHECKED));
  }
  if (!node) {
    return -1;
  }
  return 0;
}

/*
 * change_serial_settings()
 * @fd
 * @term
 */
static rtems_status_code change_serial_settings(int fd, struct termios *term)
{
  rtems_status_code sc = RTEMS_UNSATISFIED;
  int rv = tcgetattr(fd, term);

  if (rv == 0) {
    struct termios new_term = *term;

    new_term.c_iflag &= ~(IGNBRK | BRKINT | PARMRK | ISTRIP | INLCR | IGNCR | ICRNL | IXON);
    new_term.c_lflag &= ~(ECHO | ECHONL | ICANON | ISIG | IEXTEN);
    new_term.c_cflag &= ~(CSIZE | PARENB);
    new_term.c_cflag |= CS8;

    new_term.c_cc [VMIN]  = 0;
    new_term.c_cc [VTIME] = 10;

    rv = tcsetattr(fd, TCSANOW, &new_term);
    if (rv == 0) {
      sc = RTEMS_SUCCESSFUL;
    }
  }

  return sc;
}

/*
 * restore_serial_settings()
 * @fd
 * @term
 */
static rtems_status_code restore_serial_settings(int fd, struct termios *term)
{
  int rv = tcsetattr(fd, TCSANOW, term);
  return rv == 0 ? RTEMS_SUCCESSFUL : RTEMS_UNSATISFIED;
}


/*
 * test_linux_char_get()
 */
unsigned short ile_cli_char_get(void)
{
  struct termios oldt, newt;
  unsigned char c;
  tcgetattr(STDIN_FILENO, &oldt);
  newt = oldt;
  newt.c_lflag &= ~(ICANON | ECHO);
  tcsetattr(STDIN_FILENO, TCSANOW, &newt);
  while (read(STDIN_FILENO, &c, sizeof(c)) <= 0);
  tcsetattr(STDIN_FILENO, TCSANOW, &oldt);
  return c;
}

/*
 * test_linux_console_output()
 * @text
 */
void ile_cli_console_output(const char* text)
{
  printf("%s", text);
  fflush(stdout);
}

/*
 * driver_op()
 */

struct ile_cli_operations ops = {
  .char_get    = ile_cli_char_get,
  .char_output = ile_cli_console_output,
  .tree_build  = ile_cli_cmd_tree_build,
};

struct termios term;

/*
 * Init()
 */
rtems_task Init(
  rtems_task_argument ignored
)
{
  ile_cli_console_output("RTEMS & ile-cli. Please any key to continue...\n");

  cli_vterm_init(&ops);
  change_serial_settings(STDIN_FILENO, &term);
  ile_cli_char_get();
  restore_serial_settings(STDIN_FILENO, &term);

  cli_vterm_char_proc();
  exit(0);
}
