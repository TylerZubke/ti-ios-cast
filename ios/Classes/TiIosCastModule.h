/**
 * ti-ios-cast
 *
 * Created by Your Name
 * Copyright (c) 2018 Your Company. All rights reserved.
 */

#import "TiModule.h"
#import <GoogleCast/GoogleCast.h>

@interface TiIosCastModule : TiModule

@property(nonatomic, strong, readwrite) UIWindow *window;
@property(nonatomic, assign, readwrite) BOOL castControlBarsEnabled;

@end
