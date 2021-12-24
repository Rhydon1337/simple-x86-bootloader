HOME_DIRECTORY="~"
GDBINIT_PATH=$HOME_DIRECTORY/.gdbinit

./compile.sh > /dev/null

if pgrep "qemu" > /dev/null
then
    pkill -9 qemu
fi

echo "[+] running QEMU emulation"
setsid qemu-system-i386 -boot c -hda image.bin -serial mon:stdio -s -S &

echo "[+] creating a new .gdbinit file"
rm -f $GDBINIT_PATH
touch $GDBINIT_PATH

echo "set architecture i8086" >> $GDBINIT_PATH
echo "target remote localhost:1234" >> $GDBINIT_PATH

# start debugging from second_stage
echo "br *0x7e00" >> $GDBINIT_PATH
echo "c" >> $GDBINIT_PATH

gdb
