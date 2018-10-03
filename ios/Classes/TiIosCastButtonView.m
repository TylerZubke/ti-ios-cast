#import "TiIosCastButtonView.h"
#import <GoogleCast/GoogleCast.h>
#import "TiUtils.h"
#import "TiApp.h"

@interface TiIosCastButtonView ()

@property (nonatomic, strong, readwrite) GCKUICastButton *castButton;

@end

@implementation TiIosCastButtonView

- (id)init
{
    if ((self = [super init])) {
        CGRect frame = CGRectMake(0, 0, 24, 24);
        GCKUICastButton *castButton = [[GCKUICastButton alloc] initWithFrame:frame];
        self.castButton = castButton;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    NSLog(@"[VIEW LIFECYCLE EVENT] willMoveToSuperview");
}

- (void)initializeState
{
    // This method is called right after allocating the view and
    // is useful for initializing anything specific to the view
    
    [super initializeState];
    
    NSLog(@"[VIEW LIFECYCLE EVENT] initializeState");
}

- (void)configurationSet
{
    // This method is called right after all view properties have
    // been initialized from the view proxy. If the view is dependent
    // upon any properties being initialized then this is the method
    // to implement the dependent functionality.
    
    [super configurationSet];
    
    NSLog(@"[VIEW LIFECYCLE EVENT] configurationSet");
}

- (void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
    // You must implement this method for your view to be sized correctly.
    // This method is called each time the frame / bounds / center changes
    // within Titanium.
    
    NSLog(@"[VIEW LIFECYCLE EVENT] frameSizeChanged");
    
}

-(void)createButton
{
    [self addSubview: self.castButton];
}

- (void)setColor_:(id)color
{
    NSLog(@"[VIEW LIFECYCLE EVENT] Property Set: setColor_");
    
    // Use the TiUtils methods to get the values from the arguments
    TiColor *newColor = [TiUtils colorValue:color];
    UIColor *clr = [newColor _color];
    [self.castButton setTintColor:clr];
}



@end
