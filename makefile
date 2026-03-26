.PHONY: all default clean install uninstall demo
.SECONDEXPANSION:

include aux/sources.mk

VERSION := $(shell cat .version)
DATE    := $(shell date +'%F')
MONTH   := $(shell date +'%B')
YEAR    := $(shell date +'%Y')

PREFIX ?= /usr
INCLUDEDIR ?= $(PREFIX)/include
DINCLUDEDIR ?= $(INCLUDEDIR)/d/common
DATADIR ?= $(PREFIX)/share
LIBDIR ?= $(PREFIX)/lib
MANDIR ?= $(DATADIR)/man


PKG_CONFIG := pkgconf
LG2_LIBS := $(shell $(PKG_CONFIG) --libs libgit2)

BUILDDIR := .build

DMD := dmd

ifndef RELEASE
	DFLAGS := -fPIC -g
else
	DFLAGS := -fPIC -release -inline -O
endif

AR ?= ar
ARFLAGS := rcS
RANLIB ?= ranlib

SOURCES := $(addprefix source/,$(SOURCES))
OBJECTS = $(patsubst source/%.d,%.o,$(SOURCES))
OBJECTS := $(subst /,.,$(OBJECTS))
OBJECTS := $(addprefix $(BUILDDIR)/,$(OBJECTS))
LIB := $(BUILDDIR)/libdigit.a

all: $(LIB)
default: all

demo: $(BUILDDIR)/demo

DFLAGS += -Isource

$(BUILDDIR):
	mkdir -p $(BUILDDIR)

$(OBJECTS): $(BUILDDIR)/git.%.o: source/git/$$(subst .,/,%).d
	@echo -e "(\033[34mDMD\033[m)" $(shell basename $@)
	@$(DMD) $(DFLAGS) -of$@ -c $<

$(LIB): $(OBJECTS)
	@echo -e "(\033[33mAR\033[m)" $(shell basename $@)
	@$(AR) $(ARFLAGS) $@ $^
	@$(RANLIB) $@

$(BUILDDIR)/demo: misc/demo.d $(LIB)
	@echo -e "(\033[34mDMD\033[m)" $(shell basename $@)
	@$(DMD) $(DFLAGS) -of$@ $^ -L$(LG2_LIBS)

clean:
	@echo -e "(\033[33mCLEAN\033[m) all"
	@-rm -f $(OBJECTS) $(LIB) $(BUILDDIR)/demo $(BUILDDIR)/*.o *.o

install: $(LIB)
	@echo -e "(\033[32mINSTALL\033[m)" $(shell basename $(LIB))
	@install -m 0644 $(LIB) -Dt $(DESTDIR)$(LIBDIR)
	@install -dm 0755 $(DESTDIR)$(DINCLUDEDIR)
	@echo -e "(\033[32mINSTALL\033[m)" source/git
	@cp -r source/git -t $(DESTDIR)$(DINCLUDEDIR)

uninstall:
	@echo -e "(\033[33mRM\033[m)" $(LIBDIR)/$(shell basename $(LIB))
	@-rm -f  $(DESTDIR)$(LIBDIR)/$(shell basename $(LIB))
	@echo -e "(\033[33mRM\033[m)" $(DINCLUDEDIR)/git
	@-rm -fr $(DESTDIR)$(DINCLUDEDIR)/git
