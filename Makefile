MAKE             = /usr/bin/make
RST2HTML         = ./bootstrap.py
STYLESHEET       = ./style.css
RST2HTML_OPTIONS = --strip-comments             \
                   --report=3                   \
                   --no-doc-title               \
                   --no-toc-backlinks           \
				   --template=page.tmpl         \
                   --cloak-email-addresses      \
	               --stylesheet=$(STYLESHEET)   \
                   --link-stylesheet

SUBDIRS = research teaching coding artwork news blog
SOURCES = $(wildcard *.rst)
OBJECTS = $(subst .rst,.html, $(SOURCES))

all: home $(OBJECTS) $(SUBDIRS)

home: header.txt footer.txt sidebar.txt
	@echo "Building all $@"

subdirs: $(SUBDIRS)

$(SUBDIRS):
	@echo "Building all in $@"
	@$(MAKE) -f ../Makefile.sub -C $@

%.html: %.rst ./bootstrap.py header.txt footer.txt sidebar.txt
	@echo "  - $@"
	@$(RST2HTML) $(RST2HTML_OPTIONS) $< $@

clean:
	@-rm -f $(OBJECTS)
	@for d in $(SUBDIRS); do (cd $$d; $(MAKE) -f ../Makefile.sub clean ); done

distclean: clean
	@-rm -f `find . -name "*~"`

publish: all
	rsync -rLuv --exclude-from=rsync-exclude.txt . /Volumes/nrougier/

.PHONY: all home clean distclean subdirs $(SUBDIRS)
