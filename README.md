Mozc
====

[Mozc](http://code.google.com/p/mozc/) is an open source Japanese input method for Chromium OS, Mac and Linux developed by Google, Inc.
Their [Google日本語入力](http://www.google.co.jp/ime/) is the original product of Mozc which supports Windows as well.

Mozc is open sourced under [New BSD License](http://www.opensource.org/licenses/bsd-license.php) but unfortunately, [they can't commit any patches written by non-Google employee, so far](https://twitter.com/taku910/status/95089697172357120), which is not like the relationship between Chrome and Chromium.

Since this limitation of Mozc project, I've checked out the code from the original SVN repository then mirror it to this Git repository to commit my patches.
I'll keep sync this repo to original SVN repository but this synchronization is done by hand so you may prefer to use the original repository then fetch my patches from here.

Also, I've filed these patches to [the original issue tracking list](http://code.google.com/p/mozc/issues/list) so that they can, in future, merge them into the original repository.

Build Instructions for Android on Mac
-------------------------------------

To build Mozc for Android, for now, we need to use Ubuntu 12.04 but setting up such development environment takes long time and many hassles.
This repository provides an additional [Vagrant](http://www.vagrantup.com/) configuration and a [Puppet](https://puppetlabs.com/) manifest so that we can build Mozc for Android quickly.

 1. Install the latest [Vagrant](http://www.vagrantup.com/), [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and VirualBox Extension Pack. I've tested with Vagrant 1.1.4, VirtualBox 4.2.10 and Extension Pack
 1. Checkout source code from this repository using `git` command.
 1. Run `vagrant up` in the repository directory.
 1. Grab a cup of coffee. This command will download Ubuntu 12.04, setup a virtual machine, install packages, Android SDK and NDK, etc, etc which will take a long time.
 1. Once it's done, run next commands to build Mozc.

        # Connect to the virtual machine.
        % vagrant ssh
        
        # Current working Mozc directory is mounted to /vagrant.
        $ cd /vagrant
        
        # Build Mozc for Android.
        $ sh build_android.sh

 1. Mozc for Android is built at `src/android/bin/MozcForAndroid-debug.apk`, so you can install this apk using `adb` command on your host machine or directly from the virtual machine.

### Install apk from the virtual machine

To install binary from the virtual machine, we need to connect the device into the virtual machine instead of the host machine.

 1. Run `VBoxManage list usbhost` to get UUID of your Android device. Find the device form the long list and remember the UUID.

 1. Attach the device to the virtual machine. Run `VBoxManage list vms`, find the virtual machine ID starts with `mozc`, then run next command with it.

        % VBoxManage controlvm <virutal machine ID> usbattach <UUID>

 1. In the virtual machine, run next commands to install the apk to the device.

        # Connect to the virtual machine.
        % vagrant ssh
        
        # Restart adb server to lookup the device.
        $ sudo adb kill-server
        $ sudo adb start-server
        $ adb devices
        
        # Install the apk
        $ cd /vagrant
        $ adb install src/android/bin/MozcForAndroid-debug.apk

Build Instructions for Mac
--------------------------

 1. Checkout source code from this repository using `git` command.
 1. Run `checkout_externals.py` instead of running `gclient` command described in [the original instructions](http://code.google.com/p/mozc/wiki/MacBuildInstructions).
 1. Follow instructions. My build instruction is:

        # Checkout dependencies.
        % python checkout_externals.py mac
         
        # Build Mozc itself.
        % cd src
        % python build_mozc.py clean && python build_mozc.py gyp --noqt
        % python build_mozc.py build_tools -c Debug
        % python build_mozc.py build -c Debug mac/mac.gyp:GoogleJapaneseInput mac/mac.gyp:gen_launchd_confs
         
        # Then, install Mozc into /Library then kill existing processes.
        # which requires root priviledge.
        % sudo sh ../install_mac.sh
