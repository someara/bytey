OSTYPE=$(shell uname -s)
CC=clang

#
# https://newbedev.com/os-detecting-makefile
#

ifeq '$(findstring ;,$(PATH))' ';'
	detected_OS := Windows
else
	detected_OS := $(shell uname 2>/dev/null || echo Unknown)
	detected_OS := $(patsubst CYGWIN%,Cygwin,$(detected_OS))
	detected_OS := $(patsubst MSYS%,MSYS,$(detected_OS))
	detected_OS := $(patsubst MINGW%,MSYS,$(detected_OS))
endif

ifeq ($(detected_OS),Windows)
	CCFLAGS += -D WIN32
	ifeq ($(PROCESSOR_ARCHITEW6432),AMD64)
		CCFLAGS += -D AMD64
	else
		ifeq ($(PROCESSOR_ARCHITECTURE),AMD64)
			CCFLAGS += -D AMD64
		endif
		ifeq ($(PROCESSOR_ARCHITECTURE),x86)
			CCFLAGS += -D IA32
		endif
	endif
else
	ifeq ($(detected_OS),Linux)
		CCFLAGS += -D LINUX
	endif
	ifeq ($(detected_OS),Darwin)
		CFLAGS += -D OSX
	endif
	ifeq ($(detected_OS),FreeBSD)
		CFLAGS += -D FreeBSD
	endif
	ifeq ($(detected_OS),NetBSD)
		CFLAGS += -D NetBSD
	endif
	ifeq ($(detected_OS),OpenBSD)
		CFLAGS += -D OpenBSD
	endif

	PROCESSOR := $(shell uname -p)
	ifeq ($(PROCESSOR),x86_64)
		CCFLAGS += -D AMD64
	endif
	ifneq ($(filter %86,$(PROCESSOR)),)
		CCFLAGS += -D IA32
	endif
	ifneq ($(filter arm%,$(PROCESSOR)),)
		CCFLAGS += -D ARM
	endif
endif

#
# Make
#

ifeq ($(OS),Windows_NT)
build: main.c
	@echo "building main.c on $(OS)"
	@echo "CC = $(CC)"
	@echo "CCFLAGS = $(CCFLAGS)"
	$(CC) $(CFLAGS) -o bytey.exe main.c
clean:
	@echo "cleaning"
	del byte.txt
else
build: main.c
	@echo "building main.c on $(OSTYPE)"
	@echo "CC = $(CC)"
	@echo "CCFLAGS = $(CCFLAGS)"
	$(CC) $(CFLAGS) -o bytey main.c
clean:
	@echo "cleaning"
	rm byte
endif
