.ONESHELL:

help:
	@
	echo -e " \E[33;1m                                                      \E[0m "
	echo -e " \E[33;1m   this Makefile helps you to play with               \E[0m "
	echo -e " \E[33;1m     a special version of cicada language,            \E[0m "
	echo -e " \E[33;1m     which is a simple operating system of x86_64.    \E[0m "
	echo -e " \E[33;1m                                                      \E[0m "
	echo -e " \E[33;1m                                                      \E[0m "
	echo -e " \E[33;1m   dependencies ::                                    \E[0m "
	echo -e " \E[33;1m     fasm, gcc, qemu                                  \E[0m "
	echo -e " \E[33;1m                                                      \E[0m "
	echo -e " \E[33;1m                                                      \E[0m "
	echo -e " \E[33;1m   build == make BMFS                                 \E[0m "
	echo -e " \E[33;1m            make compile-bootloader                   \E[0m "
	echo -e " \E[33;1m            make compile-cicada-kernel                \E[0m "
	echo -e " \E[33;1m            make burn-cicada.image                    \E[0m "
	echo -e " \E[33;1m            make write-programs-to-cicada.image       \E[0m "
	echo -e " \E[33;1m                                                      \E[0m "
	echo -e " \E[33;1m   run :: use qemu (the 'Quick EMUlator')             \E[0m "
	echo -e " \E[33;1m          to emulate the OS                           \E[0m "
	echo -e " \E[33;1m                                                      \E[0m "
	echo -e " \E[33;1m   clean :: note that, this will also clean up        \E[0m "
	echo -e " \E[33;1m            backup files that ended by '~'            \E[0m "
	echo -e " \E[33;1m                                                      \E[0m "
	echo -e " \E[33;1m   CBR == make clean                                  \E[0m "
	echo -e " \E[33;1m          make build                                  \E[0m "
	echo -e " \E[33;1m          make run                                    \E[0m "
	echo -e " \E[33;1m                                                      \E[0m "
	echo -e " \E[33;1m                                                      \E[0m "
	echo -e " \E[33;1m     please read the 'Makefile' for more informations \E[0m "
	echo -e " \E[33;1m     happy making ^_^                                 \E[0m "


build:
	make build-cicada
run:
	make run-cicada
CBR:
	@
	echo "	 "        &&\
	make clean        &&\
	echo "	 "        &&\
	make build        &&\
	echo "	 "        &&\
	make run          &&\
	echo "	 "

BMFS:
	@ 
	cd play                                    
	gcc -ansi -std=c99 -Wall -pedantic -o bmfs bmfs.c   &&\
	echo -e "\E[33;1m[ok] build BMFS\E[0m"

compile-bootloader:
	@ 
	cd play
	fasm -m 500000 bootloader.fasm	 bootloader.bin 

compile-cicada-kernel:
	@ 
	cd play                                   
	fasm -m 500000 cicada-kernel.fasm cicada-kernel.bin

burn-cicada.image:
	@ 
	cd play
	rm -f cicada.image                                                          &&\
	dd if=/dev/zero of=cicada.image bs=1M count=8				    &&\
	./bmfs cicada.image format /force					    &&\
	dd if=bootloader.bin of=cicada.image bs=512 conv=notrunc

write-programs-to-cicada.image:
	@ 
	cd play
	./bmfs cicada.image   create   cicada-kernel.bin 2    &&\
	./bmfs cicada.image   write    cicada-kernel.bin      &&\
	./bmfs cicada.image   create   english-core.ccd 2     &&\
	./bmfs cicada.image   write    english-core.ccd   

build-cicada:
	@
	echo "	 "                               &&\
	make BMFS			         &&\
	echo "	 "			         &&\
	make compile-bootloader		         &&\
	echo "	 "			         &&\
	make compile-cicada-kernel	         &&\
	echo "	 "			         &&\
	make burn-cicada.image		         &&\
	echo "	 "			         &&\
	make write-programs-to-cicada.image	 &&\
	echo "	 "

run-cicada:
	@ 
	cd play
	qemu-system-x86_64			   \
	  -enable-kvm				   \
	  -vga std				   \
	  -smp 4				   \
	  -m 1G 				   \
	  -drive id=disk,file=cicada.image,if=none \
	  -device ich9-ahci,id=ahci		   \
	  -device ide-drive,drive=disk,bus=ahci.0  \
	  -net nic,model=i82551                    \
	  -monitor stdio

dangerous-burn-sda6-with-cicada.image:
	@ 
	make build-cicada                            &&\
	cd play                                      &&\
	sudo dd if=cicada.image of=/dev/sda6 bs=2M        			  

CBR-cicada:
	@
	echo "	 "         &&\
	make clean         &&\
	echo "	 "         &&\
	make build-cicada  &&\
	echo "	 "         &&\
	make run-cicada    &&\
	echo "	 "

clean:
	@
	rm -f		       \
	play/bmfs	       \
	play/*.bin	       \
	play/*.image	       \
	*~ */*~ */*/*~ */*/*/*~	 */*/*/*/*~    &&\
	echo -e "\E[33;1m [ok] clean directory \E[0m"
