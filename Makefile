CFLAGS = -g -Wall -fprofile-arcs -ftest-coverage
LDFLAGS = -fprofile-arcs

all: trusty_reflection.out

trusty_reflection.out: trusty_reflection.o sillypare.o hardcore_northcutt.o
    gcc $(LDFLAGS) -o trusty_reflection.out trusty_reflection.o sillypare.o hardcore_northcutt.o

trusty_reflection.o: trusty_reflection.c sillypare.h hardcore_northcutt.h
    gcc $(CFLAGS) -c trusty_reflection.c

sillypare.o: sillypare.c sillypare.h
    gcc $(CFLAGS) -c sillypare.c

hardcore_northcutt.o: hardcore_northcutt.c hardcore_northcutt.h sillypare.h
    gcc $(CFLAGS) -c hardcore_northcutt.c

clean:
    rm -f *.o *.out *.gcda *.gcno *.gcov cppcheck.log

check: trusty_reflection.out
    cppcheck --enable=warning,style,performance,portability,information,missingInclude *.c *.h > cppcheck.log

memcheck: trusty_reflection.out
    valgrind --leak-check=full ./trusty_reflection.out < valgrind_test_input.txt

coverage: trusty_reflection.out
    ./trusty_reflection.out < valgrind_test_input.txt || echo "Coverage failed with exit code $$?"
    gcov *.c
