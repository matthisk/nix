# My personal Nix configuration

This repository contains my personal Nix configuration. It currently supports
Nix Darwin to setup an OS X machine and Nixos to setup a aarch64 Linux VM. It is
loosely based on Mitchell Hashimoto's Nix config, but will probably diverge overtime.

## Setup guide VM

You can download the NixOS ISO from the official [NixOS download page](https://nixos.org/download/).
You can use the minimal ISO image for the setup.

Create a VMware Fusion VM with the following settings. My configurations are made for VMware Fusion exclusively currently and you will have issues on other virtualization solutions without minor changes.

* ISO: NixOS 23.05 or later.
* Disk: SATA 150 GB+
* CPU/Memory: I give at least half my cores and half my RAM, as much as you can.
* Graphics: Full acceleration, full resolution, maximum graphics RAM.
* Network: Shared with my Mac.
* Remove sound card, remove video camera, remove printer.
* Profile: Disable almost all keybindings
* Boot Mode: UEFI

On VMWare Workstation on Windows make sure you are in the UEFI build mode. On my workstation the setup defaulted to BIOS. To update to UEFI add the following line to the VM's vmx file:

```
firmare = "efi"
```

Boot the VM, and using the graphical console, change the root password to "root":

```
$ sudo su
$ passwd
# change to root
```

At this point, verify `/dev/sda` exists. This is the expected block device where the Makefile will install the OS. If you setup your VM to use SATA, this should exist. If `/dev/nvme` or `/dev/vda` exists instead, you didn't configure the disk properly. Note, these other block device types work fine, but you'll have to modify the bootstrap0 Makefile task to use the proper block device paths.

Also at this point, I recommend making a snapshot in case anything goes wrong. I usually call this snapshot `"prebootstrap0"`. This is entirely optional, but it'll make it super easy to go back and retry if things go wrong.

Run ifconfig and get the IP address of the first device. It is probably 192.168.58.XXX, but it can be anything. In a terminal with this repository set this to the NIXADDR env var:

```
$ export NIXADDR=<VM ip address>
```

The Makefile assumes an Intel processor by default. If you are using an ARM-based processor (M1, etc.), you must change NIXNAME so that the ARM-based configuration is used:

```
$ export NIXNAME=vm-aarch64
```

Perform the initial bootstrap. This will install NixOS on the VM disk image but will not setup any other configurations yet. This prepares the VM for any NixOS customization:

```
$ make vm/bootstrap0
```

After the VM reboots, run the full bootstrap, this will finalize the NixOS customization using this configuration:

```
$ make vm/bootstrap
```

You should have a graphical functioning dev VM.

At this point, I never use Mac terminals ever again. I clone this repository in my VM and I use the other Make tasks such as make test, make switch, etc. to make changes my VM.

## Setup guide OS X

Before using; install Nix Darwin. I use the [nix-installer](https://github.com/DeterminateSystems/nix-installer) from Determinate Systems.

Once installed, clone this repo and run `make`. If there are any errors, follow the error message (some folders may need permissions changed, some files may need to be deleted). That's it.

