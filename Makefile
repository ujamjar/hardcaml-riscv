.PHONY: clean all install uninstall 

PREFIX ?= /usr/local

all: setup.data
	ocaml setup.ml -build

setup.ml: _oasis
	oasis setup

setup.data: setup.ml
	ocaml setup.ml -configure \
		--enable-testbenches --enable-generators --enable-bloop \
		--prefix $(PREFIX)

install: all
	ocaml setup.ml -install --prefix $(PREFIX)

uninstall: 
	ocamlfind remove hardcaml-riscv
	ocamlfind remove hardcaml-altera

clean:
	ocaml setup.ml -clean
	- find . -name "*~" | xargs rm

distclean:
	ocaml setup.ml -distclean
