SUBDIRS := tests

all: openssh-portable-ncot $(SUBDIRS)
$(SUBDIRS):
	$(MAKE) -C $@

.PHONY: all $(SUBDIRS)

test:
	$(MAKE) test -C tests

clean:
	$(MAKE) clean -C tests

openssh-portable-ncot:
	@git clone https://github.com/tdkuehnel/openssh-portable-ncot.git ;\
	cd openssh-portable-ncot ;\
	git checkout V_9_5 ;\
	autoreconf ;\
	./configure --prefix=$$PWD ;\
	make ;\
	make install
