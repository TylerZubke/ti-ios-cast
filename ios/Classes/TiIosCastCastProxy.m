//
//  TiIosCastProxy.m
//  ti-ios-cast
//
//  Created by Tyler Zubke on 4/25/18.
//

#import <Foundation/Foundation.h>
#import "TiIosCastCastProxy.h"
#import <GoogleCast/GoogleCast.h>

@implementation TiIosCastCastProxy

GCKSessionManager *_sessionManager;
GCKCastSession *_castSession;
GCKUIMediaController *_castMediaController;
GCKUIDeviceVolumeController *_volumeController;

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _sessionManager = [GCKCastContext sharedInstance].sessionManager;
        [_sessionManager addListener:self];
        _castMediaController = [[GCKUIMediaController alloc] init];
        _volumeController = [[GCKUIDeviceVolumeController alloc] init];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(castDeviceDidChange:)
         name:kGCKCastStateDidChangeNotification
         object:[GCKCastContext sharedInstance]];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(presentExpandedMediaControls)
         name:kGCKExpandedMediaControlsTriggeredNotification
         object:nil];
    }
    return self;
}

- (void) showExpandedControls:(id)args
{
    [[GCKCastContext sharedInstance] presentDefaultExpandedMediaControls];
}

- (void) castVideo:(id)args
{
    ENSURE_SINGLE_ARG(args, NSDictionary);
    
    NSDictionary *metaDataDict = args[@"metadata"];
    
    NSString *url = [args valueForKey:@"url"];
    NSString *contentType = [args valueForKey:@"contentType"];

    GCKMediaMetadata *metadata =
    [[GCKMediaMetadata alloc] initWithMetadataType:GCKMediaMetadataTypeMovie];
    if (metaDataDict) {
        [metadata setString:metaDataDict[@"title"] forKey:kGCKMetadataKeyTitle];
        [metadata setString:metaDataDict[@"subtitle"] forKey: kGCKMetadataKeySubtitle];
        NSArray *images = [NSArray arrayWithArray:metaDataDict[@"images"]];
        NSURL *imageURL = ([images count] > 0) ? [NSURL URLWithString:[images objectAtIndex:0]] : NULL;
        if(imageURL)
        {
            [metadata addImage:[[GCKImage alloc] initWithURL:imageURL
                                                       width:480
                                                      height:720]];
        }
    }
    
    GCKMediaInformation *mediaInfo = [[GCKMediaInformation alloc]
                                      initWithContentID:url
                                      streamType: GCKMediaStreamTypeNone
                                      contentType: contentType
                                      metadata:metadata
                                      streamDuration:INFINITY
                                      mediaTracks:NULL
                                      textTrackStyle:NULL
                                      customData:NULL];
    
    _castSession = _sessionManager.currentCastSession;
    
    GCKMediaQueueItemBuilder *builder = [[GCKMediaQueueItemBuilder alloc] init];
    builder.mediaInformation = mediaInfo;
    builder.autoplay = YES;
    GCKMediaQueueItem *item = [builder build];
    
    [_castSession.remoteMediaClient queueLoadItems:@[ item ]
                                        startIndex:0
                                      playPosition:0
                                        repeatMode:GCKMediaRepeatModeOff
                                        customData:nil];
    
    //If you show the expanded controls right away it'll show very briefly and disappear. This doesn't happen when you show it after a small delay.
    //I noticed android has the same issue so either I'm doing something wrong or this is a Titanium or chromecast bug
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.5);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void){
        [[GCKCastContext sharedInstance] presentDefaultExpandedMediaControls];
    });
}

- (void)castDeviceDidChange:(NSNotification *)notification {
    GCKCastState state = [GCKCastContext sharedInstance].castState;
    NSString *strState = [NSString stringWithFormat:@"%d", (int)state];
    [self fireEvent:@"castStateChange" withObject:@{@"state": strState}];
}

- (int) getCastState:(id)args
{
    GCKCastState state = [GCKCastContext sharedInstance].castState;
    return (int)state;
}

- (NSString *) getDeviceName:(id)args
{
    GCKDevice *device = [GCKCastContext sharedInstance].sessionManager.currentCastSession.device;
    return device.friendlyName;
}

#pragma mark - GCKSessionManagerListener

- (void)sessionManager:(GCKSessionManager *)sessionManager
       didStartSession:(GCKSession *)session {
    NSLog(@"MediaViewController: sessionManager didStartSession %@", session);
    
}

- (void)sessionManager:(GCKSessionManager *)sessionManager
      didResumeSession:(GCKSession *)session {
    NSLog(@"MediaViewController: sessionManager didResumeSession %@", session);

}

- (void)sessionManager:(GCKSessionManager *)sessionManager
         didEndSession:(GCKSession *)session
             withError:(NSError *)error {
    NSLog(@"session ended with error: %@", error);

}

- (void)sessionManager:(GCKSessionManager *)sessionManager
didFailToStartSessionWithError:(NSError *)error {
    NSLog(@"didFailToStartSessionWithError: %@", error);
}

- (void)sessionManager:(GCKSessionManager *)sessionManager
didFailToResumeSession:(GCKSession *)session
             withError:(NSError *)error {

}

#pragma mark - GCKRemoteMediaClientListener

- (void)remoteMediaClient:(GCKRemoteMediaClient *)player
     didUpdateMediaStatus:(GCKMediaStatus *)mediaStatus {

}


@end
