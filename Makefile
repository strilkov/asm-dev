
all: run

binary/boot.bin: arch/boot/boot.asm
	fasm arch/boot/boot.asm binary/boot.bin

binary/kernel.bin: kernel/kernel.asm
	fasm kernel/kernel.asm binary/kernel.bin

file.img: binary/boot.bin binary/kernel.bin binary/test.bin
	dd if=/dev/zero of=file.img bs=1474560 count=1
	dd if=binary/boot.bin of=file.img bs=512 count=1 seek=0 conv=notrunc
	dd if=binary/kernel.bin of=file.img bs=512 count=1 seek=1 conv=notrunc
	dd if=binary/test.bin of=file.img bs=512 count=1 seek=2 conv=notrunc

clean:
	rm binary/*.bin
	rm *.img

run: file.img
	virtualbox --dbg --startvm test &

binary/test.bin: test/test.c
	bcc -0 -Md -ansi -S test/test.c
	bcc -0 -Md -ansi -c -o binary/test.o test/test.c
	ld86 -d -o binary/test.bin binary/test.o -D8100 -T8000
