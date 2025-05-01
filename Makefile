CFLAGS = -O0 -g -Wall

all: build cppcheck

cppcheck:
	cppcheck --enable=all --inconclusive --std=c11 --quiet --force . 2> cppcheck.log

run:
	make build
	./trusty_reflection.out

build: clever_williams.o kirch.o print_kirch.o trusty_reflection.o bhaskara.o
	$(CC) $(CFLAGS) -o trusty_reflection.out trusty_reflection.o bhaskara.o kirch.o print_kirch.o clever_williams.o
	rm *.o

clever_williams.o: clever_williams.c
	$(CC) $(CFLAGS) -c -o clever_williams.o clever_williams.c

kirch.o: kirch.c
	$(CC) $(CFLAGS) -c -o kirch.o kirch.c

print_kirch.o: print_kirch.c
	$(CC) $(CFLAGS) -c -o print_kirch.o print_kirch.c

trusty_reflection.o: trusty_reflection.c
	$(CC) $(CFLAGS) -c -o trusty_reflection.o trusty_reflection.c

bhaskara.o: bhaskara.c
	$(CC) $(CFLAGS) -c -o bhaskara.o bhaskara.c

valgrind:
	valgrind --leak-check=full --track-origins=yes ./trusty_reflection.out < valgrind_test_input.txt > valgrind_output.log 2>&1

coverage:
	./trusty_reflection.out < valgrind_test_input.txt
	gcovr --exclude-directories tests/ --branches --txt > coverage.txt
	gcovr --exclude-directories tests/ --branches --html --html-details -o coverage.html

clean:
	rm -f *.o
	rm -f *.out
	rm -f cppcheck.log
