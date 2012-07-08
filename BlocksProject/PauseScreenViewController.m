//
//  PauseScreenViewControllerViewController.m
//  BlocksProject
//
//  Created by Jeff Breunig on 7/6/12.
//  Copyright (c) 2012 Easy Touch, LLC. All rights reserved.
//


#import "PauseScreenViewController.h"


@interface PauseScreenViewController ()

@property (nonatomic, strong) IBOutlet UILabel *gameTimeLabel;

- (IBAction)resumeButtonPressed:(id)sender;

@end

@implementation PauseScreenViewController
@synthesize gameTimeLabel = _gameTimeLabel;
@synthesize gameTime = _gameTime;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Convert the game time to one decimal place and set the time remaining label.
    self.gameTime = ((float) ((int) (self.gameTime * 10.0)) / 10.0);
    self.gameTimeLabel.text = [NSString stringWithFormat:@"Time: %.1f", self.gameTime];
}

- (void)viewDidUnload
{
    [self setGameTimeLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait ||
        interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        return YES;
    } else {
        return NO;
    }        
}

- (IBAction)resumeButtonPressed:(id)sender {
    NSLog(@"resume button pressed");
    [self.delegate pauseResumeButtonPressed];
}

@end
