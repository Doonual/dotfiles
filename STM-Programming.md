Use STM32CubeMX to generate config code
Switch toolchain to Makefile

run `bear -- make` to make a compile_commands.json

use make to build it
if you are getting errors, do
```
sudo pacman -S arm-none-eabi-newlib
```

uploading
```
STM32_Programmer_CLI -c port=SWD -w <path-to-binary> 0x08000000 -v -rst
```

Ccls not finding standard libs
Create a .ccls file write this into it

```
# First line: tell ccls to use compile_commands.json
%compile_commands.json

# Then add extra include paths for standard libraries
-isystem/usr/include
```
