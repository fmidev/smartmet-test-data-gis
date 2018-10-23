SUBNAME = test-data-gis
SPEC = smartmet-$(SUBNAME)
TESTDATADIRS = $(shell for i in * ; do test ! -d $$i || echo $$i ; done )

# Installation directories
ifeq ($(origin PREFIX), undefined)
  PREFIX = /usr
else
  PREFIX = $(PREFIX)
endif
datadir = $(PREFIX)/share
mydatadir = $(datadir)/smartmet
objdir = obj

# How to install
INSTALL_PROG = install -p -m 775
INSTALL_DATA = install -p -m 664

.PHONY: test rpm

# The rules
all: 

debug: all
release: all
profile: all

clean:
	rm -f *~ $(SUBNAME)/*~
	rm -rf $(objdir)
	rm -f test/*Test

install:
	@mkdir -p $(mydatadir)/test/data
	cp -r --preserve=timestamps $(TESTDATADIRS) $(mydatadir)/test/data

rpm: clean $(SPEC).spec
	rm -f $(SPEC).tar.gz # Clean a possible leftover from previous attempt
	tar -czvf $(SPEC).tar.gz --transform "s,^,$(SPEC)/," *
	rpmbuild -ta $(SPEC).tar.gz
	rm -f $(SPEC).tar.gz

# Test: checks timestamps, checks installed if installed
datatarget=$(shell test -d /usr/share/smartmet/test/data && echo /usr/share/smartmet/test/data || pwd)
test:
	test -d $(datatarget)/gis/.

