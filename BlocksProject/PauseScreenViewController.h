//
//  PauseScreenViewControllerViewController.h
//  BlocksProject
//
//  Created by Jeff Breunig on 7/6/12.
//  Copyright (c) 2012 Easy Touch, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol resumeGameProtocol <NSObject>
-(void)pauseResumeButtonPressed;
@end

@interface PauseScreenViewController : UIViewController
@property (nonatomic, assign) id <resumeGameProtocol> delegate;
@property (nonatomic, assign) float gameTime;
@end
