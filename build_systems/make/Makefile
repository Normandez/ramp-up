BINARY=main
DIST=$(BINARY).tar.gz
INSTALL_DIR=~/
CXX=g++

build: *.o
	$(CXX) *.o -o $(BINARY)

*.o: *.cc *.h
	$(CXX) -c *.cc

clean:
	rm -f *.o $(BINARY)

dist:
	tar -czf $(DIST) --include="*.cc" --include="*.h" *

install: build
	cp $(BINARY) $(INSTALL_DIR)

uninstall:
	rm -r $(INSTALL_DIR)/$(BINARY)

