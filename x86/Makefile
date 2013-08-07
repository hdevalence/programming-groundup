AS=as
LD=ld
ASFLAGS=--32
LDFLAGS=-m elf_i386

%.o: %.s
	$(AS) -o $@ $< $(ASFLAGS)

exit: exit.o
	$(LD) -o exit exit.o $(LDFLAGS)

maximum: maximum.o
	$(LD) -o maximum maximum.o $(LDFLAGS)

factorial: factorial.o
	$(LD) -o factorial factorial.o $(LDFLAGS)

power: power.o
	$(LD) -o power power.o $(LDFLAGS)

power_fast: power_fast.o
	$(LD) -o power_fast power_fast.o $(LDFLAGS)

upcase: upcase.o
	$(LD) -o upcase upcase.o $(LDFLAGS)

ALL=exit maximum factorial power power_fast upcase

all: $(ALL)

clean:
	rm *.o $(ALL)
