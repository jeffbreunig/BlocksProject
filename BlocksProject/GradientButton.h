//
//  GradientButton.h
//  BlocksProject
//
//  Created by Jeff Breunig on 7/6/12.
//  Copyright (c) 2012 Easy Touch, LLC. All rights reserved.
//

// GradientButton.h:

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GradientButton : UIButton {
    CAGradientLayer *shineLayer;
    CALayer         *highlightLayer;
}
@end