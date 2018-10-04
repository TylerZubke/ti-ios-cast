var CastManager = require('ti.ios.cast');

var CastProxy = (function (){
    var instance;

    function createProxy() {
        return CastManager.createCast();
    }

    return {
        getInstance: function() {
            if(!instance){
                instance = createProxy();
            }
            return instance;
        }
    }
})();

CastManager.configure({
    applicationId: 'xxxxxxxxxx'
});

var win2 = Titanium.UI.createWindow({
    backgroundColor: '#fff',
    title: 'Chromecast Example'
});

var win1 = Titanium.UI.iOS.createNavigationWindow({
    window: win2
});

win1.open();

var castButtonContainer = Ti.UI.createView({width:24, height:24});
var castButton = CastManager.createButtonView({
    color: '#f00'
});

castButtonContainer.add(castButton);
win2.rightNavButton = castButtonContainer;

CastProxy.getInstance().addEventListener('castStateChange', onCastStateChange);

function onCastStateChange(e)
{
    if(e.state == 3)
    {

        CastProxy.getInstance().castVideo({
            url: 'http://clips.vorwaerts-gmbh.de/VfE_html5.mp4',
            contentType: 'video/m3u8',
            metadata: {
                title: 'Test Video',
                subtitle: 'Test subtitle',
                images: [
                    'http://camendesign.com/code/video_for_everybody/poster.jpg'
                ]
            }
        });
    }
}


