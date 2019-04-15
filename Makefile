CA=ca65
LD=ld65
PY=python3
CFLAGS65=-g

IDIR=inc
ODIR=obj
LDIR=lib
SDIR=src

title=spellbind

objlist = nrom init main bg player pads ppuclear

.PHONY: run clean

EMU=java -jar ~/Nintaco/Nintaco.jar

$(ODIR)/%.o: $(SDIR)/%.s $(IDIR)/nes.inc $(IDIR)/global.inc
	$(CA) $(CFLAGS65) $< -o $@

# For generated source files
$(ODIR)/%.o: $(ODIR)/%.s
	$(CA) $(CFLAGS65) $< -o $@

objlistntsc = $(foreach o,$(objlist),$(ODIR)/$(o).o)

map.txt $(title).nes: nrom256.cfg $(objlistntsc)
	$(LD) -o $(title).nes -m map.txt -C $^

$(ODIR)/main.o: $(ODIR)/background.chr $(ODIR)/sprite.chr

$(title).chr: $(ODIR)/background.chr $(ODIR)/sprite.chr
	cat $^ > $@

$(ODIR)/%.chr: $(IDIR)/%.png
	$(PY) tools/pilbmp2nes.py $< $@

$(ODIR)/%16.chr: $(IDIR)/%.png
	$(PY) tools/pilbmp2nes.py -H 16 $< $@

run:
	$(EMU) $(title).nes

clean:
	rm -f $(ODIR)/*.o $(ODIR)/*.chr
