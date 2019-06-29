del hello-world.gb
del main.o

rgbasm -o bin\main.o main.asm
rgblink -o bin\hello-world.gb bin\main.o 
rgbfix -v -p 0 bin\hello-world.gb
start bin\hello-world.gb