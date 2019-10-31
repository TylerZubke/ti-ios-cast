iOS Chromecast Module
===========================================

This module allows you to cast videos to a chromecast device from a Titanium iOS project. It uses the underlying UI elements built into the 
Chromecast SDK so you don't need to create any extra UI for the cast button, device discovery, controlling playback, etc. As far as I'm aware, this
is the only module that implements these native UI elements.


HOW TO USE
-----------------------------

A simple example can be foun in example/app.js. 

1. Require the module
2. Create a new cast context and pass in your chromecast application id. 

*If you don't have an existing chromecast application you can create one here: https://cast.google.com/publish/#/signup

To create a cast button:

```
var castButtonContainer = Ti.UI.createView({width:24, height:24});
var castButton = CastManager.createButtonView({
    color: '#f00'
});
castButtonContainer.add(castButton);
window.add(castButtonContainer);
```

To cast a video:

First you need to create a cast proxy:

```
var proxy = CastManager.createCast();
```

Then add an event listener:

```
proxy.addEventListener('castStateChange', onCastStateChange);
```

There are 4 cast states:
	0 = No Cast session is established, and no Cast devices are available.
	1 = No Cast session is establishd, and Cast devices are available.
	2 = A Cast session is being established.
	3 = A Cast session is established.
	
When a cast session is established you can cast a video like this:

```
proxy.castVideo({
    url: 'http://clips.vorwaerts-gmbh.de/VfE_html5.mp4',
    contentType: 'video/mp4',
    metadata: {
	title: 'Test Video',
	subtitle: 'Test subtitle',
	images: [
	    'http://camendesign.com/code/video_for_everybody/poster.jpg'
	]
    }
});
```

Once the video is successfully casting the Expanded Controller should automatically pop up on the device.
This can be triggered manually with 
	
```
proxy.showExpandedControls();
```

REGISTERING THE MODULE
--------------------

Register your module with your application by editing `tiapp.xml` and adding your module.
Example:

```
<modules>
	<module platform="iphone">ti.ios.cast</module>
</modules>
```

When you run your project, the compiler will combine your module along with its dependencies
and assets into the application.


USING YOUR MODULE IN CODE
-------------------------

To use your module in code, you will need to require it.

For example,

```
var CastManager = require('ti.ios.cast');
CastManager.configure({
	applicationId: 'xxxxxxxxxx'
});
```



