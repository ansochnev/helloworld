.PHONY: all clean test

all:
	g++ main.cpp lib.cpp -o helloworld

test_version:
	g++ lib.cpp test_version.cpp -o test_version

test: test_version
	./test_version

clean:
	rm -rf helloworld
	rm -rf test_version

