Since there is some controversy about the controller in the video... I'll try to clear it up here.

When I'm playing SMB, you can see Mario walks (and then runs) even though I'm not holding the buttons.

If you look closely, I press the button, then slide my finger down and release it.

When I press the button, it sends a "mouseDown:" event to my code (in the ControllerView class). I tell the emulator that the button was pressed.

Then if I slide my finger off the button and release my finger, it sends a "mouseUp:" event. However since my finger was not on a button, I can't relate the X/Y location sent in the event to a button.  Thus I can't tell the emulator that a button was released.

If I release my finger while still on the button, the X/Y location sent in the event **can** be related to a button. And then I can tell the emulator that the button was released (as you can see when I jump).

The biggest issue here is that since it is a multitouch interface, many mouseDown:/mouseUp: events can be generated simultaneously.

Not knowing if a GSEvent in the mouseUp: specifies the original mouseDown: event, nor wanting to try and track/correlate mouseDragged: events, I left it as you see in the video/binary/code.

I hope to fix this and other controller related issues in the next few days.
