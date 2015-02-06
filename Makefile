JC = javac
JFLAGS = -g -d bin -cp src

sources = $(wildcard src/**/*.java)

all: $(sources:.java=.class)

.SUFFIXES: .java .class

.java.class:
	$(JC) $(JFLAGS) $*.java

clean:
	$(RM) $(sources:.java=.class)
