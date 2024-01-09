# anyka-software
Set of tools for building sofware for running on Anyka AK3918 CPU based ip cameras.

The crosscompiler for Anyka is 32-bit (x86), so you need to enable support for 32-bit apps in your distro.  For example, on Ubuntu 22:
        
        sudo apt install libstdc++-i386
        sudo apt install lib32stdc++6
        sudo apt install libmpc-dev:i386
        sudo apt install libz1:i386
        sudo ln -s /lib/i386-linux-gnu/libmpfr.so.6 /lib/i386-linux-gnu/libmpfr.so.4 
        
The last command makes a link to libmpfr.so, because the cross-compiler is linked to its old version(4), which is no longer present in modern distros.

To compile all software, run ./all.sh, the compiled binaries and libraries will be placed into 'INSTALL' folder.
To compile manually, run ./crosscompiler.sh followed by the necessary scripts. Don't forget the dependencies that need to be compiled first (e.g. to compile v4l2rtspserver you should run ./live555.sh first, and then run ./v4l2rtspserver.sh).
