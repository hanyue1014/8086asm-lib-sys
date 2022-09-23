# 8086asm-lib-sys
Degree Year 1 Sem 1 Assembly 8086 TASM assignment

# Members
- [Xuan Bin AKA. hanyue1014](https://github.com/hanyue1014/)
- [yi kit AKA. yongyk](https://github.com/yongyk/)
- [Soon Chee AKA. AC3019](https://github.com/AC3019/)

# How to run (built version)
1. Install and open [DosBox](https://www.dosbox.com/)
2. Download and extract this zip file to anywhere you like (eg. C:\8086asm-lib-sys) **Make Sure there are no nested directories**
	- For example, the directory structure will look like this
		- C:
			- 8086asm-lib-sys
				- libSys.asm
				- LIBSYS.EXE
				- *.TXT
				- TASM.EXE
				- TLINK.EXE
				- DEBUG.EXE
3. Run the following command in dosbox (replace C:\8086asm-lib-sys with the path your file is in)
```
mount C C:\8086asm-lib-sys
C:
```
4. Run `libsys` in dosbox and enjoy the system

# How to build your own and run
1. Install and open [DosBox](https://www.dosbox.com/)
2. Download and extract this zip file to anywhere you like (eg. C:\8086asm-lib-sys) **Make Sure there are no nested directories**
	- For example, the directory structure will look like this
		- C:
			- 8086asm-lib-sys
				- libSys.asm
				- LIBSYS.EXE
				- *.TXT
				- TASM.EXE
				- TLINK.EXE
				- DEBUG.EXE
3. Run the following command in dosbox (replace C:\8086asm-lib-sys with the path your file is in)
```
mount C C:\8086asm-lib-sys
C:
```
4. Use the following command to build and link the file
```
tasm libSys.asm
tlink libSys
```
5. An exe file will be generated, simply run the exe file `libsys` and enjoy the system
