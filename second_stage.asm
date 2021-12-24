[bits 32]
extern init_serial, serial_write

global start

section .text

start:
call init_serial
push string_file_size
push string_file
call serial_write
hlt

string_file: 
incbin 'rfc2324.txt'
string_file_size dd  $ - string_file
