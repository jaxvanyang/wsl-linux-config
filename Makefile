.PHONY: build install modules_install version config clean

LINUX := WSL2-Linux-Kernel
MAKEFILE := ${LINUX}/Makefile
CONFIG := ${LINUX}/.config
KERNEL := ${LINUX}/arch/x86/boot/bzImage
MAKE := make -C ${LINUX}
PREFIX ?= $${PWD}
REVISION ?=
TMP_DIR ?= /tmp/wsl-linux-config

define get_version
	file ${1} | sed -E 's/^.*version ([^ ]*).*$$/\1/'
endef

build: ${KERNEL}

install: ${KERNEL}
	cp $^ "${PREFIX}/bzImage-$$($(call get_version,$^))${REVISION}"

modules.tar.xz: ${TMP_DIR}/lib
	tar cavf $@ -C ${TMP_DIR} lib

${TMP_DIR}/lib: ${KERNEL}
	mkdir -p ${TMP_DIR}
	sudo ${MAKE} INSTALL_MOD_PATH=${TMP_DIR} modules_install

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
	${MAKE} clean
	-rm -f ${CONFIG} *.xz
	-sudo rm -rf ${TMP_DIR}
