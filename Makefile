# This taken from Palmer Dabbelt's home directory repo
# git@github.com:palmer-dabbelt/home.git

LOCAL_DIR ?= $(LOCAL)

# Configuration variables
TMUX_BIN_VERSION ?= 2.1
LIBEVENT_VERSION ?= 2.0.22
LUA_VERSION ?= 5.3.3
VIM_VERSION ?= 8.0.069
# These variables should be used to refer to programs that get run, so we can
# install them if necessary.
BIN_DIR ?= $(LOCAL_DIR)/bin
LIB_DIR ?= $(LOCAL_DIR)/lib
HDR_DIR ?= $(LOCAL_DIR)/include
PC_DIR ?= $(LOCAL_DIR)/lib/pkgconfig

# Targets
TMUX_BIN ?= $(BIN_DIR)/tmux
LIBEVENT ?= $(LIB_DIR)/libevent.so
LUA ?= $(BIN_DIR)/lua
VIM ?= $(BIN_DIR)/vim

# "make all"
ALL = \
	$(TMUX_BIN) \
	$(LUA) \
	$(VIM)

.PHONY: all
all: $(ALL)

# "make clean" -- use CLEAN, so your output gets in .gitignore
CLEAN = \
	$(ALL) \

.PHONY: clean
clean:
	rm -rf $(CLEAN)

# Useful build variables
UNAME_S=$(shell uname -s)

# These programs can be manually installed so I can use my home drive
# transparently when on other systems.
$(LOCAL_DIR)/bin/%: /usr/bin/%
	mkdir -p $(dir $@)
	cp -Lf $< $@

$(LOCAL_DIR)/lib/%: /usr/lib/%
	mkdir -p $(dir $@)
	cp -Lf $< $@

$(LOCAL_DIR)/include/%: /usr/include/%
	mkdir -p $(dir $@)
	cp -Lf $< $@

# Fetch tmux
INSTALLED_TMUX_VERSION = $(shell echo -e "$(TMUX_BIN_VERSION)\n`/usr/bin/tmux -V | head -n1 | cut -d' ' -f2`" | sort --version-sort | head -n1)
ifneq ($(INSTALLED_TMUX_VERSION),$(TMUX_BIN_VERSION))
CLEAN += $(LOCAL_DIR)/var/distfiles/tmux-$(TMUX_BIN_VERSION).tar.bz2
CLEAN += $(LOCAL_DIR)/src/tmux/

$(TMUX_BIN): $(LOCAL_DIR)/src/tmux/build/tmux
	mkdir -p $(dir $@)
	cp -Lf $< $@

$(LOCAL_DIR)/src/tmux/build/tmux: $(LOCAL_DIR)/src/tmux/build/Makefile
	$(MAKE) -C $(dir $@) $(notdir $@) 

$(LOCAL_DIR)/src/tmux/build/Makefile: $(LOCAL_DIR)/src/tmux/configure $(LIBEVENT) $(LIBCURSES) $(LIBZ)
	mkdir -p $(dir $@)
	cd $(dir $@) && CPPFLAGS="-I$(abspath $(HDR_DIR)) -I$(abspath $(HDR_DIR)/ncurses)" LDFLAGS="-L$(abspath $(LIB_DIR)) -Wl,-rpath,$(abspath $(LIB_DIR))" ../configure

$(LOCAL_DIR)/src/tmux/configure: $(LOCAL_DIR)/var/distfiles/tmux-$(TMUX_BIN_VERSION).tar.gz
	rm -rf $(dir $@)
	mkdir -p $(dir $@)
	tar -xzf $< -C $(dir $@) --strip-components=1
	touch $@

$(LOCAL_DIR)/var/distfiles/tmux-$(TMUX_BIN_VERSION).tar.gz:
	mkdir -p $(dir $@)
	wget https://github.com/tmux/tmux/releases/download/$(TMUX_BIN_VERSION)/tmux-$(TMUX_BIN_VERSION).tar.gz -O $@
endif

# Fetch libevent
ifeq (,$(wildcard /usr/lib/libevent.so))
CLEAN += $(LOCAL_DIR)/var/distfiles/libevent-$(LIBEVENT_VERSION).tar.gz
CLEAN += $(LOCAL_DIR)/src/libevent/
CLEAN += $(LOCAL_DIR)/include/event.h
CLEAN += $(LOCAL_DIR)/include/evhttp.h
CLEAN += $(LOCAL_DIR)/include/evdns.h
CLEAN += $(LOCAL_DIR)/include/evrpc.h
CLEAN += $(LOCAL_DIR)/include/evutil.h
CLEAN += $(LOCAL_DIR)/include/event2/
CLEAN += $(LOCAL_DIR)/lib/pkgconfig/libevent.pc
CLEAN += $(LOCAL_DIR)/lib/pkgconfig/libevent_pthreads.pc
CLEAN += $(LOCAL_DIR)/lib/pkgconfig/libevent_openssl.pc
CLEAN += $(LOCAL_DIR)/lib/libevent-2.0.so.5
CLEAN += $(LOCAL_DIR)/lib/libevent-2.0.so.5.1.9
CLEAN += $(LOCAL_DIR)/lib/libevent.a
CLEAN += $(LOCAL_DIR)/lib/libevent.la

$(LIBEVENT): $(LOCAL_DIR)/src/libevent/build/.libs/libevent.so
	$(MAKE) -C $(LOCAL_DIR)/src/libevent/build install

$(LOCAL_DIR)/src/libevent/build/.libs/libevent.so: $(LOCAL_DIR)/src/libevent/build/Makefile
	$(MAKE) -C $(LOCAL_DIR)/src/libevent/build

$(LOCAL_DIR)/src/libevent/build/Makefile: $(LOCAL_DIR)/src/libevent/configure
	mkdir -p $(dir $@)
	cd $(dir $@) && ../configure --prefix=$(abspath $(LOCAL_DIR))

$(LOCAL_DIR)/src/libevent/configure: $(LOCAL_DIR)/var/distfiles/libevent-$(LIBEVENT_VERSION).tar.gz
	rm -rf $(dir $@)
	mkdir -p $(dir $@)
	tar -xzf $< -C $(dir $@) --strip-components=1
	touch $@

$(LOCAL_DIR)/var/distfiles/libevent-$(LIBEVENT_VERSION).tar.gz:
	mkdir -p $(dir $@)
	wget https://github.com/libevent/libevent/releases/download/release-$(LIBEVENT_VERSION)-stable/libevent-$(LIBEVENT_VERSION)-stable.tar.gz -O $@
endif

ifeq ($(UNAME_S),Linux)
LUA_PLATFORM=linux
endif
ifeq ($(UNAME_S),Darwin)
LUA_PLATFORM=osx
endif

# Fetch lua
INSTALLED_LUA_VERSION = $(shell echo -e "$(LUA_VERSION)\n`/usr/local/bin/lua -v | head -n1 | cut -d' ' -f2`" | sort --version-sort | head -n1)
ifneq ($(INSTALLED_LUA_VERSION),$(LUA_VERSION))
CLEAN += $(LOCAL_DIR)/var/distfiles/lua-$(LUA_VERSION).tar.gz
CLEAN += $(LOCAL_DIR)/src/lua
CLEAN += $(LOCAL_DIR)/bin/lua
CLEAN += $(LOCAL_DIR)/bin/luac
CLEAN += $(LOCAL_DIR)/include/lua.h
CLEAN += $(LOCAL_DIR)/include/luaconf.h
CLEAN += $(LOCAL_DIR)/include/lualib.h
CLEAN += $(LOCAL_DIR)/include/lua.hpp
CLEAN += $(LOCAL_DIR)/include/luaxlib.h
CLEAN += $(LOCAL_DIR)/man/man1/lua.1
CLEAN += $(LOCAL_DIR)/man/man1/luac.1
CLEAN += $(LOCAL_DIR)/lib/liblua.a

$(LOCAL_DIR)/var/distfiles/lua-$(LUA_VERSION).tar.gz:
	mkdir -p $(dir $@)
	wget http://www.lua.org/ftp/lua-$(LUA_VERSION).tar.gz -O $@

$(LOCAL_DIR)/src/lua/Makefile: $(LOCAL_DIR)/var/distfiles/lua-$(LUA_VERSION).tar.gz
	rm -rf $(dir $@)
	mkdir -p $(dir $@)
	tar -xzf $< -C $(dir $@) --strip-components=1
	touch $@

$(LOCAL_DIR)/src/lua/src/lua: $(LOCAL_DIR)/src/lua/Makefile
	$(MAKE) -C $(dir $<) $(LUA_PLATFORM)

$(LUA): $(LOCAL_DIR)/src/lua/src/lua
	$(MAKE) -C $(dir $<)/.. install INSTALL_TOP=$(LOCAL)

endif

# Fetch VIM
INSTALLED_VIM_VERSION = $(shell echo -e "$(VIM_VERSION)\n`/usr/bin/vim --version | head -n1 | cut -d' ' -f5`" | sort --version-sort | head -n1)
ifneq ($(INSTALLED_VIM_VERSION),$(VIM_VERSION))

$(LOCAL_DIR)/var/distfiles/vim-$(VIM_VERSION).tar.bz2:
	mkdir -p $(dir $@)
	wget http://ftp.vim.org/vim/unix/vim-$(VIM_VERSION).tar.bz2 -O $@

$(LOCAL_DIR)/src/vim/configure: $(LOCAL_DIR)/var/distfiles/vim-$(VIM_VERSION).tar.bz2
	rm -rf $(dir $@)
	mkdir -p $(dir $@)
	tar -xvf $< -C $(dir $@) --strip-components=1
	touch $@

$(LOCAL_DIR)/src/vim/src/Makefile: $(LOCAL_DIR)/src/vim/configure
	cd $(dir $<) && ./configure --with-features=huge  --with-lua-prefix=$(LOCAL)  --enable-fail-if-missing  --enable-luainterp  --prefix=$(LOCAL)


$(LOCAL_DIR)/src/vim/src/vim: $(LOCAL_DIR)/src/vim/src/Makefile
	$(MAKE) -C $(dir $@)

$(VIM): $(LOCAL_DIR)/src/vim/src/vim
	$(MAKE) -C $(dir $<) install

endif
