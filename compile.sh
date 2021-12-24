nasm -f bin -o first_stage.o first_stage.asm

nasm -f elf32 second_stage.asm -o second_stage.o
gcc -m32 -falign-functions=4 -ffreestanding -c helpers.c -o helpers.o
ld -melf_i386 --build-id=none -T link.ld helpers.o second_stage.o -o second_stage.elf
objcopy -O binary second_stage.elf second_stage.bin
rm helpers.o second_stage.o second_stage.elf

cat first_stage.o second_stage.bin > image.bin

rm second_stage.bin first_stage.o
