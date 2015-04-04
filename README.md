NES.app
NES Emulator for iPhone
Version 0.20

Core: InfoNES Project ( based on pNesX )

Code: nervegas, stepwhite

Cool: nightwatch (CoreSurfaces), bwhiteman (CoreAudio), dshadow (General)
> wheat-_(Icon)_

BUILDING

0. You will need to install the arm-apple-darwin toolchain. See:
> http://iphone.fiveforty.net/wiki/index.php/Toolchain_Project

> You will also need to apply the patches in toolchain-includes-patch.txt
> Run the patch in your toolchain's include directory. For example:
```
       cd /usr/local/arm-apple-darwin/include
       patch -p0 < toolchain-includs-patch.txt
```
1. Compile using 'make'. This will create a new NES.app package in ./build.

> Upload entire NES.app directory into /Applications on the iPhone and reboot
> the iPhone. It should automatically detect the application and add it to the
> springboard.

2. Place your ROM files in /var/root/Media/ROMs/NES

NOTE ON SOUND
Sound required that you disable mediaserverd, and only works through the
headphones. A couple of easy aliases can be added to your .profile to disable or
re-enable mediaserverd if you are using MobileShell:
```
alias nosound="launchctl unload /System/Library/LaunchDaemons/coreaudiod.plist"
alias sound="launchctl load /System/Library/LaunchDaemons/coreaudiod.plist"
```
NOTE ON MULTITOUCH
The multitouch reports mouseDown and mouseDragged events separately, and so
you can run while holding 'B', for example, but the iPhone appears to get
pushed to the limits when you are holding a direction and dragging on
another. It fails to report the necessary mouseUp events to distinguish which
button(s) let up, and so they must all be reset. As a result:

Versions >= 0.20
> If you are doing something complex, such as running with B held
> down, then jump with A, you will also need to slide your thumb back off the
> directional pad (to zero, or to the other size) to stop running.

Versions < 0.20
> Whenever you are holding a direction + button, releasing the button will
> cause the direction to stop moving as well. I am working on
> finding a way to poll the screen to re-evaluate all the buttons, but
> until then, this is the only caveat you'll have to live with.

NOTE ON DEBUG

Compiling with -DDEBUG (see Makefile) will enable debugging to be sent to
/tmp/NES.debug. At the moment, this is only recording touchscreen activity.