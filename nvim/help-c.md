# Getting C/C++ syntax highlighting working

You need either a compile_commands.json file or a .ccls file.
compile_commands.json file is preferred and usually easier to get.

## compile_commands.json
**From make**
 - Install `bear`
 - Run `bear -- make` to generate compile_commands.json

**Platformio**
 - Run `platformio run -t compiledb`


## .ccls
If for some reason you cant get a compile_commands.json file, a .ccls file will do

 - Create a file in your project root directory called `.ccl`
 - Enter in relative paths to include directories 
     - `-I../../../../../opt/rocm-6.3.0/include` for "" includes
     - `-isystem../../../../../usr/include` for <> includes
 - Find these paths by running make with the verbose flag `-v`


