# simple-x86-bootloader
Simple legacy boot x86 bootloader

MBR -> real mode to protected mode transition -> print some file data to serial port

Why using linker script?

1. The first stage loads the second stage and therefore the second stage must be the first section. By using the linker script we can control the code sections order.
2. With a linker script we can define the starting address (the address that the second stage is loaded to).

DONE!!!
