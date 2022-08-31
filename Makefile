TARGETS=r_temp.time r_xor.time r_pm.time r_xchg.time rm_temp.time rm_xor.time rm_xor_temp.time rm_xchg_rm.time rm_xchg_lm.time m_temp.exe noreg_rm_temp.time

all: $(TARGETS)

%.time: %.exe
	/usr/bin/time -f "user: %U" -o "./$@" "./"$^

%.exe: %.S
	gcc $^ -o $@

clean:
	rm -rf *.exe *_time

.PHONY: all, clean
.PRECIOUS: %.exe
