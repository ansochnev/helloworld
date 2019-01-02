.PHONY: all clean test

all: helloworld

helloworld:
	g++ main.cpp lib.cpp -o helloworld

test_version:
	g++ lib.cpp test_version.cpp -o test_version

test: test_version
	./test_version

deb: helloworld
	chmod 755 deb/makepkg.sh
	deb/makepkg.sh

clean:
	rm -rf helloworld
	rm -rf test_version
	rm -rf *.deb

