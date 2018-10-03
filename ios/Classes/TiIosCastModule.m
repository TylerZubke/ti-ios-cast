/**
 * ti-ios-cast
 *
 * Created by Your Name
 * Copyright (c) 2018 Your Company. All rights reserved.
 */

#import "TiIosCastModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiApp.h"

@implementation TiIosCastModule

#pragma mark Internal

static const BOOL kDebugLoggingEnabled = NO;

#pragma mark - GCKLoggerDelegate

- (void)logMessage:(NSString *)message fromFunction:(NSString *)function {
    if (kDebugLoggingEnabled) {
        NSLog(@"%@  %@", function, message);
    }
}

// This is generated for your module, please do not change it
- (id)moduleGUID
{
  return @"792c8032-e637-4bc2-9069-f02256baae06";
}

// This is generated for your module, please do not change it
- (NSString *)moduleId
{
  return @"ti.ios.cast";
}

- (void)configure:(id)args
{
    if (!args || [args count] == 0) {
        return;
    }
   
    
    NSDictionary *payload = [args objectAtIndex:0];
    NSString *appId = [payload objectForKey:@"applicationId"];
    
    
    if(![GCKCastContext isSharedInstanceInitialized])
    {
        GCKCastOptions *options =
        [[GCKCastOptions alloc] initWithDiscoveryCriteria:[[GCKDiscoveryCriteria alloc] initWithApplicationID:appId]];
        [GCKCastContext setSharedInstanceWithOptions:options];
        [GCKLogger sharedInstance].delegate = self;
        
    }
    
}

#pragma mark Lifecycle

- (void)startup
{
  // This method is called when the module is first loaded
  // You *must* call the superclass
  [super startup];
  DebugLog(@"[DEBUG] %@ loaded", self);
}

@end
