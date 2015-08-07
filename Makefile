.PHONY: clean all install uninstall 

all: setup.data
	ocaml setup.ml -build

setup.ml:
	oasis setup

setup.data: setup.ml
	ocaml setup.ml -configure --enable-testbenches --enable-generators

install: all
	ocaml setup.ml -install

uninstall: 
	ocamlfind remove hardcaml-riscv

clean:
	ocaml setup.ml -clean
	- find . -name "*~" | xargs rm

distclean:
	ocaml setup.ml -distclean
