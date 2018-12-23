.PHONY: all clean

all:
	g++ main.cpp -o helloworld

clean:
	rm -rf helloworld
