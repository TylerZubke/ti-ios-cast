//
//  TiIosCastProxy.h
//  ti-ios-cast
//
//  Created by Tyler Zubke on 4/25/18.
//

#import "TiProxy.h"
#import <GoogleCast/GoogleCast.h>

@interface TiIosCastCastProxy : TiProxy<GCKSessionManagerListener,GCKRemoteMediaClientListener, GCKRequestDelegate>

@end
