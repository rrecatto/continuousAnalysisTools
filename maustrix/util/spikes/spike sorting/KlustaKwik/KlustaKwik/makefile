#
# makefile for KlustaKwik
#
#
SOURCES = KlustaKwik.cpp param.c KK.cpp
HEADERS = KlustaKwik.h Array.h param.h KK.h KlustaSave.h

KlustaKwik: $(SOURCES) $(HEADERS)
	g++ -O3 -o KlustaKwik $(SOURCES) -lm 

test:
	rm -f tempout test.model.1 test.clu.1
	KlustaKwik test 1 -MinClusters 2 -Debug 1 > tempout
	diff test.clu.1 test_res.clu.1
	cvs diff test.model.1

vg: KlustaKwik.h KlustaKwik.C Array.h param.c param.h
	g++ -g -O0 -o KlustaKwik KlustaKwik.C  param.c -lm
	rm -f tempout
	valgrind KlustaKwik test 1 -MinClusters 2 -Debug 1 > tempout

