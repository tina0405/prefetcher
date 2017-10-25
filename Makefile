CFLAGS = -msse2 --std gnu99 -g -O0 -Wall -Wextra
TESTS = \
    sse \
    sse_prefetch \
    naive \
    unrolling_naive
GIT_HOOKS := .git/hooks/applied

all: $(GIT_HOOKS) main.c
	$(CC) $(CFLAGS) -Dsse_prefetch -o sse_prefetch main.c
	$(CC) $(CFLAGS) -Dsse -o sse main.c
	$(CC) $(CFLAGS) -Dnaive -o  naive main.c
	$(CC) $(CFLAGS) -Dunrolling_naive -o  unrolling_naive main.c
$(GIT_HOOKS):
	@scripts/install-git-hooks
	@echo

clean:
	$(RM) main
cache-test:  $(TESTS)
	echo 3 | sudo tee /proc/sys/vm/drop_caches;
	perf stat --repeat 100 \
                -e cache-misses,cache-references,instructions,cycles \
                ./sse
	perf stat --repeat 100 \
                -e cache-misses,cache-references,instructions,cycles \
                ./sse_prefetch
	perf stat --repeat 100 \
                -e cache-misses,cache-references,instructions,cycles \
                ./naive
	perf stat --repeat 100 \
                -e cache-misses,cache-references,instructions,cycles \
                ./unrolling_naive

