NOTE ON SOUND

Sound required that you disable mediaserverd, and only works through the
headphones. A couple of easy aliases can be added to your .profile to disable or
re-enable mediaserverd if you are using MobileShell:

```
alias nosound="launchctl unload /System/Library/LaunchDaemons/coreaudiod.plist"
alias sound="launchctl load /System/Library/LaunchDaemons/coreaudiod.plist"
```