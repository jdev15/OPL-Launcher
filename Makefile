.SILENT:

FRONTEND_OBJS = $(EE_SRC_DIR)main.o

EECORE_OBJS =	$(EE_C_DIR)ps2dev9.o $(EE_C_DIR)ps2atad.o $(EE_C_DIR)ps2fs.o $(EE_C_DIR)ps2hdd.o \
		$(EE_C_DIR)iomanx.o $(EE_C_DIR)filexio.o

EE_BIN = OPL-Launcher.elf
EE_PACKED_BIN = OPL-Launcher-packed.elf

EE_SRC_DIR = src/
EE_C_DIR = modules/
EE_OBJS = $(FRONTEND_OBJS) $(EECORE_OBJS)

EE_CFLAGS := -O2 -mgpopt -Wno-stringop-truncation
EE_LDFLAGS += -L$(PS2SDK)/ee/lib
EE_LIBS += -lfileXio -lpatches -lelf-loader-nocolour
EE_INCS += -I$(PS2SDK)/ports/include
EE_INCS += -I./include

BIN2C = $(PS2SDK)/bin/bin2c

all: create_dirs $(EE_BIN)
	$(EE_STRIP) $(EE_BIN)
	ps2-packer $(EE_BIN) $(EE_PACKED_BIN)

create_dirs:
	mkdir -p $(EE_C_DIR)

clean:
	rm -f -r $(EE_C_DIR) $(EE_BIN) $(EE_PACKED_BIN)

rebuild: clean all

$(EE_C_DIR)ps2dev9.c: $(PS2SDK)/iop/irx/ps2dev9.irx
	$(BIN2C) $< $@ ps2dev9_irx

$(EE_C_DIR)ps2atad.c: $(PS2SDK)/iop/irx/ps2atad.irx
	$(BIN2C) $< $@ ps2atad_irx

$(EE_C_DIR)ps2fs.c: $(PS2SDK)/iop/irx/ps2fs.irx
	$(BIN2C) $< $@ ps2fs_irx

$(EE_C_DIR)ps2hdd.c: $(PS2SDK)/iop/irx/ps2hdd-osd.irx
	$(BIN2C) $< $@ ps2hdd_irx

$(EE_C_DIR)iomanx.c: $(PS2SDK)/iop/irx/iomanX.irx
	$(BIN2C) $< $@ iomanx_irx

$(EE_C_DIR)filexio.c: $(PS2SDK)/iop/irx/fileXio.irx
	$(BIN2C) $< $@ filexio_irx

include $(PS2SDK)/samples/Makefile.pref
include $(PS2SDK)/samples/Makefile.eeglobal_cpp

