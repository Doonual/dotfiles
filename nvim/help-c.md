# Getting C/C++ syntax highlighting working

You need either a compile_commands.json file or a .ccls file.
compile_commands.json file is preferred and usually easier to get.

## compile_commands.json

**From make**
 - Install `bear`
 - Run `bear -- make` to generate compile_commands.json

**Platformio**
 - Run `platformio run -t compiledb`
