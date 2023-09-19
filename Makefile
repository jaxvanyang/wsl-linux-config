.PHONY: build install modules_install version diff config clean

LINUX := WSL2-Linux-Kernel
MS_CONFIG := ${LINUX}/Microsoft/config-wsl
CONFIG := ${LINUX}/.config
DIFF := config-wsl.diff
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
	cp $^ "${PREFIX}/vmlinuz-$$($(call get_version,$^))${REVISION}"

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

diff: ${DIFF}
${DIFF}: ${MS_CONFIG} config-wsl
	-diff $^ > $@

config: ${CONFIG}
${CONFIG}: ${MS_CONFIG} config-wsl
	cp config-wsl $@
	${MAKE} olddefconfig

${MS_CONFIG}:
	git submodule update --init

clean:
	-rm -f ${CONFIG} *.xz
	-rm -rf lib
	-rm *.diff
	-${MAKE} clean
