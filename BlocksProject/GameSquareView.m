//
//  GameSquareView.m
//  BlocksProject
//
//  Created by Jeff Breunig on 7/6/12.
//  Copyright (c) 2012 Easy Touch, LLC. All rights reserved.
//

#import "GameSquareView.h"

@implementation GameSquareView
@synthesize centerX = _centerX;
@synthesize centerY = _centerY;
@synthesize radius = _radius;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGFloat BGLocations[2] = { 0.0, 1.0 };
    CGFloat BgComponents[8] = { 1.0, 1.0, 1.0 , 0.4,
        0.0, 0.0, 0.0, 0.25 };
    CGColorSpaceRef BgRGBColorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef bgRadialGradient = CGGradientCreateWithColorComponents(BgRGBColorspace, BgComponents, BGLocations, 2);
    
    CGPoint startBg = CGPointMake(self.centerX, self.centerY); 
    CGFloat endRadius= self.radius * 1.7;
    
    CGContextDrawRadialGradient(context, bgRadialGradient, startBg, 0, startBg, endRadius, kCGGradientDrawsAfterEndLocation);
    CGColorSpaceRelease(BgRGBColorspace);
    CGGradientRelease(bgRadialGradient);
}


@end
