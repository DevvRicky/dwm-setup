#ifndef CONFIG_H
#define CONFIG_H

// String used to delimit block outputs in the status.
#define DELIMITER " | "

// Maximum number of Unicode characters that a block can output.
#define MAX_BLOCK_OUTPUT_LENGTH 128

// Control whether blocks are clickable.
#define CLICKABLE_BLOCKS 1

// Control whether a leading delimiter should be prepended to the status.
#define LEADING_DELIMITER 0

// Control whether a trailing delimiter should be appended to the status.
#define TRAILING_DELIMITER 0

// Define blocks for the status feed as X(icon, cmd, interval, signal).
#define BLOCKS(X)                                               \
    X("", "/home/fierzza/.local/bin/status/spotify", 1, 9)     \
    X("", "/home/fierzza/.local/bin/status/wifi", 5, 4)        \
    X("", "/home/fierzza/.local/bin/status/cpu", 2, 1)         \
    X("", "/home/fierzza/.local/bin/status/memory", 5, 2)      \
    X("", "/home/fierzza/.local/bin/status/disk", 60, 3)       \
    X("", "/home/fierzza/.local/bin/status/date", 60, 10)      \
    X("", "/home/fierzza/.local/bin/status/time", 1, 5)        \
    X("", "/home/fierzza/.local/bin/status/battery", 1, 6)     \
    X("", "/home/fierzza/.local/bin/status/audio", 1, 7)       \
    X("", "/home/fierzza/.local/bin/status/notifications", 0, 11) \
    X("", "/home/fierzza/.local/bin/status/distro", 0, 0)


#endif // CONFIG_H
