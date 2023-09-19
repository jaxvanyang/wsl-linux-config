# wsl-linux-config
My personal WSL Linux kernel build configuration.

## What's the difference from the official release?
Highlights:
- [Network block device](https://en.wikipedia.org/wiki/Network_block_device)
    (NBD) support.
- [Internet Small Computer System Interface](https://en.wikipedia.org/wiki/ISCSI)
    (iSCSI) support.

I always try to make my modification minimal, you can use `diff` to see exactly
what changes I made:
```bash
diff WSL2-Linux-Kernel/Microsoft/config-wsl config-wsl
```

> [!NOTE]
> I have also added the `config-wsl.diff` and the kernel config `.config` file
> in the GitHub releases.

## Installation
If you want to try the same configuration as mine, you can just copy the
[config-wsl](./config-wsl) as `.config` to your WSL kernel source tree and
compile it. Or you can download the prebuilt kernel and modules from the
[release page](https://github.com/jaxvanyang/wsl-linux-config/releases).

> [!NOTE]
> Please see the documentation on the
> [.wslconfig configuration file](https://docs.microsoft.com/en-us/windows/wsl/wsl-config#configure-global-options-with-wslconfig)
> for information on using a custom built kernel. And remember to install the
> kernel modules.

FYI, I use this [Makefile](./Makefile) to simplify the installation process:
```bash
# build the kernel & modules, the wsl-config is copied automatically
make build
# copy the kernel to C drive
make PREFIX=/mnt/c/path/to/your_installation install
# install the kernel modules
sudo make modules_install
# now you can edit your `.wslconfig` to use the custom kernel :)
```

## References
- [microsoft/WSL2-Linux-Kernel](https://github.com/microsoft/WSL2-Linux-Kernel)
- [jovton/USB-Storage-on-WSL2](https://github.com/jovton/USB-Storage-on-WSL2)
