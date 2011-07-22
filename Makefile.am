## Process this file with automake to produce Makefile.in

## Created by Anjuta


uidir = $(datadir)/magicmirror/ui
ui_DATA = magicmirror.ui


AM_CPPFLAGS = \
	-DPACKAGE_LOCALE_DIR=\""$(prefix)/$(DATADIRNAME)/locale"\" \
	-DPACKAGE_SRC_DIR=\""$(srcdir)"\" \
	-DPACKAGE_DATA_DIR=\""$(datadir)"\" \
	$(MAGICMIRROR_CFLAGS)

AM_CFLAGS =\
	 -Wall\
	 -g

VALAFLAGS =  \
	--pkg gtk+-3.0 --vapidir . --pkg config

bin_PROGRAMS = magicmirror

magicmirror_SOURCES = \
	videoview.vala

magicmirror_LDFLAGS = \
	-Wl,--export-dynamic

magicmirror_LDADD = $(MAGICMIRROR_LIBS)


EXTRA_DIST = $(ui_DATA)

# Remove ui directory on uninstall
uninstall-local:
	-rm -r $(uidir)
	-rm -r $(datadir)/magicmirror
