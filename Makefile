SUBDIRS := tests

all: $(SUBDIRS)
$(SUBDIRS):
	$(MAKE) -C $@

.PHONY: all $(SUBDIRS)

test:
	$(MAKE) test -C tests

clean:
	$(MAKE) clean -C tests
