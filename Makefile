.PHONY: build install modules_install version config clean

LINUX := WSL2-Linux-Kernel
MAKEFILE := ${LINUX}/Makefile
CONFIG := ${LINUX}/.config
KERNEL := ${LINUX}/arch/x86/boot/bzImage
MODULES_DIR := lib/modules
MAKE := make -C ${LINUX}
PREFIX ?= $${PWD}
REVISION ?=

define get_version
	file ${1} | sed -E 's/^.*version ([^ ]*).*$$/\1/'
endef

build: ${KERNEL}

install: ${KERNEL}
	cp $^ "${PREFIX}/bzImage-$$($(call get_version,$^))${REVISION}"

modules.tar.xz: ${MODULES_DIR}
	tar cavf $@ -C $^ .

${MODULES_DIR}: ${KERNEL}
	${MAKE} INSTALL_MOD_PATH=$${PWD} modules_install

modules_install: ${KERNEL}
	${MAKE} modules_install

version: ${KERNEL}
	@$(call get_version,$^)
	
${KERNEL}: ${CONFIG}
	${MAKE} -j $$(nproc) 

${CONFIG}: ${MAKEFILE} config-wsl
	cp config-wsl $@
	${MAKE} olddefconfig

${MAKEFILE}:
	git submodule update --init

clean: ${MAKEFILE}
	-rm -f ${CONFIG} *.xz
	-rm -rf lib
	${MAKE} clean
