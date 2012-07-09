//
//  GameViewController.m
//  BlocksProject
//
//  Created by Jeff Breunig on 7/6/12.
//  Copyright (c) 2012 Easy Touch, LLC. All rights reserved.
//

#define CORNER_RADIUS_IPAD          30.0
#define CORNER_RADIUS_IPHONE        15.0
#define BORDER_WIDTH_IPAD           6.0
#define BORDER_WIDTH_IPHONE         3.0

#define MAXIMUM_BLOCK_TOWER_COUNT   10
#define TOWER_BLOCK_COUNT           7

#define BLOCK_WIDTH_IPOD            50
#define BLOCK_WIDTH_IPAD            110

#define BLOCK_HEIGHT_IPOD           42.00
#define BLOCK_HEIGHT_IPAD           95.00

#define STARTING_X_COORD_IPOD       42.5
#define ADD_X_COORD_IPOD            92.5

#define STARTING_X_COORD_IPAD       130.0
#define ADD_X_COORD_IPAD            199.0

#define BLOCK_BASE_Y_COORD_IPOD     480 - BLOCK_HEIGHT_IPOD
#define BLOCK_BASE_Y_COORD_IPAD     1024 - BLOCK_HEIGHT_IPAD


#import <QuartzCore/QuartzCore.h>
#import "GameViewController.h"
#import "GameSquareView.h"
#import "PauseScreenViewController.h"

@interface GameViewController ()
@property (nonatomic, strong) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, strong) IBOutlet UILabel *gameTimeLabel;
@property (nonatomic, strong) IBOutlet UIView *gameDirectionsView;
@property (nonatomic, strong) NSMutableArray *blockArray;
@property (nonatomic, strong) NSMutableArray *foundationBlocksArray;
@property (nonatomic, strong) NSMutableArray *allTowersArray;
@property (nonatomic, strong) NSMutableArray *allLastObjectInTowersArray;
@property (nonatomic, strong) NSMutableArray *allTranslucentViewsArray;
@property (nonatomic, strong) NSMutableSet *blockSet;
@property (nonatomic, strong) UIView *translucentView;
@property (nonatomic, strong) UIView *currentPanGestureView;
@property (nonatomic, assign) BOOL isScreenLocked;
@property (nonatomic, assign) BOOL isGameOver;
@property (nonatomic, assign) BOOL isPanGestureInProgress;
@property (nonatomic, assign) float gameTimeCounter;
@property (nonatomic, assign) float panBeganX;
@property (nonatomic, assign) float panBeganY;
@property (nonatomic, assign) NSInteger blocksOriginalStack;
@property (nonatomic, assign) NSInteger moveStackSize;
@property (nonatomic, assign) NSInteger moveStackIndex;
@property (nonatomic, assign) NSInteger allTowersCompleteTower;
@property (nonatomic, assign) NSInteger allTowersCompleteBlockPosition;
@property (nonatomic, strong) NSTimer *gameTimer;
@property (nonatomic, strong) NSTimer *completedTowersAlphaTimer;

-(void)addPauseButton;
-(void)initializeObjects;
-(void)createTranslucentView;
-(void)addTranslucentViewToBackground;
-(void)showDirectionsView;
- (IBAction)startButtonPressed:(id)sender;
-(void)createNewGame;
-(UIColor *)getBlockColorForTower:(int)tower;
-(UIView *)createAGameBlockViewForTower:(int)tower height:(int)blockHeight width:(int)blockWidth color:(UIColor *)blockColor;
-(UILabel *)createANumberLabelForABlockWithFrame:(CGRect)frame number:(int)number;
-(void)addGestureRecognizerToBlock:(UIView *)block;
-(void)createBlockViews;
-(void)setCoordinatesForTranslucentBlocks;
-(void)makeATranslucentBlock:(int)stack x:(float)x y:(int)y;
-(void)assignBlocksToTowers;
-(void)setTheLastBlocksInATowerArray;
-(BOOL)isAttemptingToMoveAFoundationBlock:(UIView *)viewToMove;
-(BOOL)checkIfAttemptingToMoveMoreThanOneBlock:(UIView *)viewToMove;
-(BOOL)checkIFBlocksAttemptedtoBeMovedAreAllTheSameColor:(UIView *)blockTouched;
-(void)findNewTowerToMoveBlocks:(UIView *)blockTouched width:(float)blockWidth height:(float)blockHeight;
-(void)moveAndPositionBlocksOnTheScreen:(UIPanGestureRecognizer *)recognizer width:(float)blockWidth;
-(void)moveBlocks:(UIPanGestureRecognizer *)recognizer;
-(void)checkIfSuccessfullyCompletedTowers;
-(void)makeBlockAlphaOneAfterCompletingAllTowersForTower:(NSArray *)tower blockNumber:(int)number;
-(void)allTowersCompleteFindBlockToChangeAlpha;
-(void)completedTowers;
-(void)removeBlocksFromAllTowersArrayAfterCompletingAGame;
-(void)updateGameTimer;
-(void)pauseButtonPressed;
-(void)pauseResumeButtonPressed;

@end

@implementation GameViewController
@synthesize navigationBar = _navigationBar;
@synthesize blockArray = _blockArray;
@synthesize foundationBlocksArray = _foundationBlocksArray;
@synthesize allTowersArray = _allTowersArray;
@synthesize allLastObjectInTowersArray = _allLastObjectInTowersArray;
@synthesize allTranslucentViewsArray = _allTranslucentViewsArray;
@synthesize blockSet = _blockSet;
@synthesize gameDirectionsView = _gameDirectionsView;
@synthesize translucentView = _translucentView;
@synthesize isScreenLocked = _isScreenLocked;
@synthesize isGameOver = _isGameOver;
@synthesize isPanGestureInProgress = _isPanGestureInProgress;
@synthesize currentPanGestureView = _currentPanGestureView;
@synthesize gameTimer = _gameTimer;
@synthesize completedTowersAlphaTimer = _completedTowersAlphaTimer;
@synthesize gameTimeLabel = _gameTimeLabel;
@synthesize gameTimeCounter = _gameTimeCounter;
@synthesize panBeganX = _panBeganX;
@synthesize panBeganY = _panBeganY;
@synthesize blocksOriginalStack = _blocksOriginalStack;
@synthesize moveStackSize = _moveStackSize;
@synthesize moveStackIndex = _moveStackIndex;
@synthesize allTowersCompleteTower = _allTowersCompleteTower;
@synthesize allTowersCompleteBlockPosition = _allTowersCompleteBlockPosition;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Add Pause Button

-(void)addPauseButton {
    // set pause button on navigation bar
    UIBarButtonItem *pauseGameBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pauseButtonPressed)];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.leftBarButtonItem = pauseGameBarButtonItem;
    [self.navigationBar pushNavigationItem:navItem animated:NO];
}

-(void)initializeObjects {
    self.blockSet = [[NSMutableSet alloc]init ];
    self.blockArray = [[NSMutableArray alloc]init ];
    self.foundationBlocksArray = [[NSMutableArray alloc]init ];    
    self.allTowersArray = [[NSMutableArray alloc]initWithObjects:[[NSMutableArray alloc]init],[[NSMutableArray alloc]init],[[NSMutableArray alloc]init], nil];    
    self.allTranslucentViewsArray = [[NSMutableArray alloc]initWithObjects:[[NSMutableArray alloc]init],[[NSMutableArray alloc]init],[[NSMutableArray alloc]init], nil];    
    self.allLastObjectInTowersArray = [[NSMutableArray alloc]init];    
}

#pragma mark - View Did Load

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createTranslucentView];
    
    self.isScreenLocked = YES;
    
    [self initializeObjects];
    
    [self addPauseButton];
    
    // create game blocks and translucnet blocks
    [self createBlockViews];    
    [self setCoordinatesForTranslucentBlocks];
    
    [self createNewGame];
}

#pragma mark - Translucnet View

-(void)createTranslucentView {
    // add translucent view to background before showing directions view
    self.translucentView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 44.0, self.view.frame.size.width, self.view.frame.size.height)];
    self.translucentView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];    
}

-(void)addTranslucentViewToBackground {

    [self.view addSubview:self.translucentView];     
}

#pragma mark - Show Directions View

-(void)showDirectionsView {
    [self addTranslucentViewToBackground];
    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"GameDirectionsView" owner:self options:nil];
    
    UIView *mainView = [subviewArray objectAtIndex:0];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        mainView.frame = CGRectMake(109, 140, self.gameDirectionsView.frame.size.width, self.gameDirectionsView.frame.size.height);
        mainView.layer.borderWidth = BORDER_WIDTH_IPAD;
        mainView.layer.cornerRadius = CORNER_RADIUS_IPAD;
    } else {
        mainView.frame = CGRectMake(30, 100, self.gameDirectionsView.frame.size.width, self.gameDirectionsView.frame.size.height);
        mainView.layer.borderWidth = BORDER_WIDTH_IPHONE;
        mainView.layer.cornerRadius = CORNER_RADIUS_IPHONE;
    }
    
    mainView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.8].CGColor;
    
    [self.view addSubview:mainView];
}

- (IBAction)startButtonPressed:(id)sender {
    [self.gameDirectionsView removeFromSuperview]; 
    [self.translucentView removeFromSuperview];
    self.isScreenLocked = NO;

    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                          target:self
                                                        selector:@selector(updateGameTimer)
                                                        userInfo:nil
                                                         repeats:YES];  
    
}

#pragma mark - Create New Game

-(void)createNewGame {
    
    self.gameTimeCounter = 0.0;
    self.gameTimeLabel.text = [NSString stringWithFormat:@"%d", (int)self.gameTimeCounter];
    
    [self assignBlocksToTowers];
    
    // set default values before a new game
    self.allTowersCompleteBlockPosition = 0;
    self.allTowersCompleteTower = 1;
    self.isPanGestureInProgress = NO;
    self.isGameOver = NO;
    
    [self addTranslucentViewToBackground];
    [self showDirectionsView];
    
}

#pragma mark - Create Block Views

-(UIColor *)getBlockColorForTower:(int)tower {
    UIColor *color;
    if (tower == 1) {
        return color = [UIColor redColor];
    } else if (tower == 2) {
        return color = [UIColor blueColor];
    } else {
        return color = [UIColor greenColor];
    }
}

-(UIView *)createAGameBlockViewForTower:(int)tower height:(int)blockHeight width:(int)blockWidth color:(UIColor *)blockColor {
    
    GameSquareView *view = [[GameSquareView alloc]initWithFrame:CGRectMake(0, 0, blockWidth, blockHeight)];
    view.centerX = blockWidth / 2;
    view.centerY = blockHeight / 2;
    view.radius = blockWidth;
    view.tag = tower;
    view.backgroundColor = blockColor;
    if (tower != 1) {
        view.alpha = 0.9;
    }
    
    return view;
}

-(UILabel *)createANumberLabelForABlockWithFrame:(CGRect)frame number:(int)number {
    
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:frame];
    numberLabel.text = [NSString stringWithFormat:@"%d",number];
    numberLabel.textColor = [UIColor whiteColor];
    numberLabel.backgroundColor = [UIColor clearColor];
    numberLabel.textAlignment = UITextAlignmentCenter;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        numberLabel.font = [UIFont systemFontOfSize:63];
    } else {
        numberLabel.font = [UIFont systemFontOfSize:30];
    } 
    
    return numberLabel;
}

-(void)addGestureRecognizerToBlock:(UIView *)block {
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveBlocks:)];
    
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    //[panRecognizer setDelegate:self];
    [block addGestureRecognizer:panRecognizer];  
}

-(void)createBlockViews {

    int numberOfBlocks = TOWER_BLOCK_COUNT;
    
    int blockHeight, blockWidth;    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        blockWidth = BLOCK_WIDTH_IPAD;
        blockHeight = BLOCK_HEIGHT_IPAD;
    } else {
        blockWidth = BLOCK_WIDTH_IPOD;
        blockHeight = BLOCK_HEIGHT_IPOD;
    }
    for (int tower=1; tower<=3; tower++) {
        
        UIColor *blockColor = [self getBlockColorForTower:tower];
        
        for (int blockNumber=numberOfBlocks; blockNumber>0; blockNumber--) {
            
            UIView *view = [self createAGameBlockViewForTower:tower height:blockHeight width:blockWidth color:blockColor];
            
            UILabel *numberLabel = [self createANumberLabelForABlockWithFrame:view.frame number:blockNumber];
            [view addSubview:numberLabel];
            
            [self addGestureRecognizerToBlock:view];
            
            if (blockNumber == TOWER_BLOCK_COUNT) {
                [self.foundationBlocksArray addObject:view];
            } else {
                [self.blockSet addObject:view];
            }
        }
    }    
}

#pragma mark - Set Coordinates For Translucent Blocks

-(void)setCoordinatesForTranslucentBlocks {
    int y, yBaseCoord, blockHeight;
    float x, addX;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        yBaseCoord = BLOCK_BASE_Y_COORD_IPAD;
        x = STARTING_X_COORD_IPAD;
        addX = ADD_X_COORD_IPAD;
        blockHeight = BLOCK_HEIGHT_IPAD;
    } else {
        yBaseCoord = BLOCK_BASE_Y_COORD_IPOD;
        x = STARTING_X_COORD_IPOD;
        addX = ADD_X_COORD_IPOD;
        blockHeight = BLOCK_HEIGHT_IPOD;
    }    

    y = yBaseCoord;
    for (int blockCount=0; blockCount< 3 * MAXIMUM_BLOCK_TOWER_COUNT; blockCount++) {
        if (blockCount<MAXIMUM_BLOCK_TOWER_COUNT) {
            [self makeATranslucentBlock:0 x:x y:y];
        } else if (blockCount<MAXIMUM_BLOCK_TOWER_COUNT * 2) {
            if (blockCount == MAXIMUM_BLOCK_TOWER_COUNT) {
                x += addX;
                y = yBaseCoord;
            }
            [self makeATranslucentBlock:1 x:x y:y];
        } else if (blockCount<MAXIMUM_BLOCK_TOWER_COUNT * 3) {
            if (blockCount == MAXIMUM_BLOCK_TOWER_COUNT * 2) {
                x += addX;
                y = yBaseCoord;
            }
            [self makeATranslucentBlock:2 x:x y:y];
        }
        y -= blockHeight;
    }
}

-(void)makeATranslucentBlock:(int)stack x:(float)x y:(int)y {
    int blockWidth;
    int blockHeight;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        blockWidth = BLOCK_WIDTH_IPAD;
        blockHeight = BLOCK_HEIGHT_IPAD;
    } else {
        blockWidth = BLOCK_WIDTH_IPOD;
        blockHeight = BLOCK_HEIGHT_IPOD;
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(x, y, blockWidth, blockHeight)];
    view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.4].CGColor;
    NSMutableArray *array = [self.allTranslucentViewsArray objectAtIndex:stack];
    [array addObject:view];
    [self.view addSubview:view];
}

#pragma mark - Assign Blocks To Towers

-(void)assignBlocksToTowers {
    int y,yBaseCoord, blockHeight;;
    float x, addX;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        yBaseCoord = BLOCK_BASE_Y_COORD_IPAD;
        x = STARTING_X_COORD_IPAD;
        addX = ADD_X_COORD_IPAD;
        blockHeight = BLOCK_HEIGHT_IPAD;
        
    } else {
        yBaseCoord = BLOCK_BASE_Y_COORD_IPOD;
        x = STARTING_X_COORD_IPOD;
        addX = ADD_X_COORD_IPOD;
        blockHeight = BLOCK_HEIGHT_IPOD;  
    }
    
    y = yBaseCoord;
    
    NSMutableSet *temporaryBlockSet = [[NSMutableSet alloc]init];
    
    for (int tower=0; tower<self.allTowersArray.count; tower++) {
        
        //NSLog(@"number of blocks %d for stack %i", number, tower+1);
        for (int i=0; i<TOWER_BLOCK_COUNT; i++) {
            UIView *view;
            if (i !=0) {
                view = [self.blockSet anyObject];
                view.frame = CGRectMake(x, y, view.frame.size.width, view.frame.size.height);
                [[self.allTowersArray objectAtIndex:tower] addObject:view];
                [temporaryBlockSet addObject:view];
                [self.blockSet removeObject:view];
            } else {
                view = [self.foundationBlocksArray objectAtIndex:tower];
                view.frame = CGRectMake(x, y, view.frame.size.width, view.frame.size.height);
                [[self.allTowersArray objectAtIndex:tower] addObject:view];
            }
            
            [self.view addSubview:view];
            y -= blockHeight;
        }
        y = yBaseCoord;
        x += addX;
    }
    self.blockSet = temporaryBlockSet;
}

#pragma mark - Pan Gesture Recognizer

-(void)setTheLastBlocksInATowerArray {
    [self.allLastObjectInTowersArray removeAllObjects];
    
    for (int i=0; i<self.allTowersArray.count; i++) {
        UIView *view = [[self.allTowersArray objectAtIndex:i]lastObject];
        [self.allLastObjectInTowersArray insertObject:view atIndex:i];
    }
}

-(BOOL)isAttemptingToMoveAFoundationBlock:(UIView *)viewToMove {
    for (int i =0; i<self.allTowersArray.count; i++) {
        UIView *view = [[self.allTowersArray objectAtIndex:i]objectAtIndex:0];
        if ([viewToMove isEqual:view]) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)checkIfAttemptingToMoveMoreThanOneBlock:(UIView *)viewToMove {

    for (UIView *lastObject in self.allLastObjectInTowersArray) {
        if (viewToMove.frame.origin.x == lastObject.frame.origin.x && viewToMove.frame.origin.y == lastObject.frame.origin.y) {
            // is a last block
            return YES;
        }
    }
    return NO;
}

-(BOOL)checkIFBlocksAttemptedtoBeMovedAreAllTheSameColor:(UIView *)blockTouched {
    for (int tower=0; tower<self.allTowersArray.count; tower++) {
        NSArray *towerArray = [self.allTowersArray objectAtIndex:tower];
        if (self.moveStackIndex == -1) {
            for (int i= towerArray.count-2; i>=1; i--) {
                UIView *view = [towerArray objectAtIndex:i];
                // find the number of blocks that the user is attempting to move 
                // top block in a tower has the highest stack index
                if ([view isEqual:blockTouched]) {
                    self.moveStackIndex = i;
                    // check if the block is the same color as the block that the user touched
                    if (view.tag == blockTouched.tag) {
                        // check that all the blocks are the same color
                        for (int j=self.moveStackIndex; j<towerArray.count; j++) {
                            UIView *nextView = [towerArray objectAtIndex:j];
                            if (nextView.tag != blockTouched.tag) {
                                return NO;
                            }
                        }
                        self.moveStackSize = towerArray.count - self.moveStackIndex;
                    } else {
                        // not the same color as the block the user touched
                        return NO;
                    }
                }
            }
        }
    } 
    return YES;
}

-(void)findNewTowerToMoveBlocks:(UIView *)blockTouched width:(float)blockWidth height:(float)blockHeight  {
    
    float halfBlockWidth = blockWidth / 2;
    float halfBlockHeight = blockHeight / 2;    
    int  MIN_X = blockWidth * 0.6;
    int  MAX_X = blockWidth * 1.6;
    int  MIN_Y = blockHeight * 10;   
    int  MAX_Y = blockHeight * 2;
    
    BOOL didFindNewTowerToMoveBlockTo = NO;
    for (int a=0; a<self.allTowersArray.count; a++) {
        NSMutableArray *blockEndingTower = [self.allTowersArray objectAtIndex:a];
        NSMutableArray *blockOriginalTower = [self.allTowersArray objectAtIndex:self.blocksOriginalStack];
        UIView *lastObject = [self.allLastObjectInTowersArray objectAtIndex:a];
        
        if (self.blocksOriginalStack != a && blockEndingTower.count + self.moveStackSize <= MAXIMUM_BLOCK_TOWER_COUNT && (blockTouched.center.x > (lastObject.frame.origin.x - MIN_X) && blockTouched.center.x < (lastObject.frame.origin.x + MAX_X)) && (blockTouched.center.y > (lastObject.frame.origin.y - MIN_Y) && blockTouched.center.y < (lastObject.frame.origin.y + MAX_Y))) {
            if (self.moveStackSize > 1) {
                for (int i = 0; i<self.moveStackSize; i++) {
                    UIView *view = [blockOriginalTower objectAtIndex:self.moveStackIndex];
                    UIView *lastObjectEndingStack = [blockEndingTower lastObject];
                    view.center = CGPointMake(lastObjectEndingStack.frame.origin.x+halfBlockWidth, lastObjectEndingStack.frame.origin.y-halfBlockHeight);
                    [blockEndingTower addObject:view];
                    [blockOriginalTower removeObject:view];
                }
            } else {
                blockTouched.center = CGPointMake(lastObject.frame.origin.x+halfBlockWidth, lastObject.frame.origin.y-halfBlockHeight);
                [blockEndingTower addObject:[blockOriginalTower lastObject]]; 
                [blockOriginalTower removeLastObject];
            }
            didFindNewTowerToMoveBlockTo = YES;
        }
    }
    
    
    if (didFindNewTowerToMoveBlockTo == NO) {

        if (self.moveStackSize > 1) {
            NSArray *arrayStack = [NSArray arrayWithArray:[self.allTowersArray objectAtIndex:self.blocksOriginalStack]];
            for (int i=0; i<self.moveStackSize; i++) {
                UIView *view = [arrayStack objectAtIndex:self.moveStackIndex+i];
                view.center = CGPointMake(self.panBeganX, 
                                          self.panBeganY - (i * blockHeight));
            }
        } else {
            blockTouched.center = CGPointMake(self.panBeganX, 
                                                 self.panBeganY);
        }
    }
}

-(void)moveAndPositionBlocksOnTheScreen:(UIPanGestureRecognizer *)recognizer width:(float)blockWidth {
    
    CGPoint translation = [recognizer translationInView:self.view];
    float halfBlockWidth = blockWidth / 2;
    
    if([(UIPanGestureRecognizer *)recognizer state] == UIGestureRecognizerStateBegan) {
        self.currentPanGestureView = recognizer.view;
        self.isPanGestureInProgress = YES;
		self.panBeganX = [[recognizer view] center].x;
		self.panBeganY = [[recognizer view] center].y;
        for (int i=0; i<self.allLastObjectInTowersArray.count; i++) {
            UIView *lastObject = [self.allLastObjectInTowersArray objectAtIndex:i];
            if (self.panBeganX - halfBlockWidth == lastObject.frame.origin.x)  {
                self.blocksOriginalStack = i;
                break;
            }
        }    
        
        [self.view insertSubview:recognizer.view aboveSubview:[self.view.subviews lastObject]];
        
        if (self.moveStackSize > 1) {
            for (int i = 0; i<self.moveStackSize-1; i++) {
                UIView *view = [[self.allTowersArray objectAtIndex:self.blocksOriginalStack]objectAtIndex:self.moveStackIndex + i+1];
                view.center = CGPointMake(view.center.x + translation.x, 
                                          view.center.y + translation.y);
                [self.view insertSubview:view aboveSubview:[self.view.subviews lastObject]];
            }
        }
	} else {
        recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, 
                                             recognizer.view.center.y + translation.y);
        if (self.moveStackSize > 1) {
            for (int i = 0; i<self.moveStackSize-1; i++) {
                UIView *view = [[self.allTowersArray objectAtIndex:self.blocksOriginalStack]objectAtIndex:self.moveStackIndex + i+1];
                view.center = CGPointMake(view.center.x + translation.x, 
                                          view.center.y + translation.y);
            }
        }
    }
}

-(void)moveBlocks:(UIPanGestureRecognizer *)recognizer {
    
    if (self.isScreenLocked) {
        return;
    }

    if (self.isPanGestureInProgress) {
        if (![recognizer.view isEqual:self.currentPanGestureView]) {
            return;
        }
    }

    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateBegan) {
        [self setTheLastBlocksInATowerArray];        
    }

    // do not allow the foundation object in a tower to be moved
    BOOL isAFoundationBlock = [self isAttemptingToMoveAFoundationBlock:recognizer.view];
    if (isAFoundationBlock) {
        return;
    }
    
    self.moveStackIndex = -1; // default value
    self.moveStackSize = 1;
    
    // check if attempting to move the last (top) block in a tower
    BOOL isALastObject = [self checkIfAttemptingToMoveMoreThanOneBlock:recognizer.view];
    if (!isALastObject) {
        BOOL isBlocksSameColor = [self checkIFBlocksAttemptedtoBeMovedAreAllTheSameColor:recognizer.view];
        if (!isBlocksSameColor) {
            return;
        }
    }

    float blockWidth, blockHeight;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        blockWidth = BLOCK_WIDTH_IPAD;
        blockHeight = BLOCK_HEIGHT_IPAD;
    } else {
        blockWidth = BLOCK_WIDTH_IPOD;
        blockHeight = BLOCK_HEIGHT_IPOD;
    }

    [self moveAndPositionBlocksOnTheScreen:recognizer width:blockWidth];
    
    BOOL isStateEnded = NO;
    
    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateEnded) {
        self.isPanGestureInProgress = NO;
        isStateEnded = YES;
        [self findNewTowerToMoveBlocks:recognizer.view width:blockWidth height:blockHeight];
    }
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateEnded) {
        self.isPanGestureInProgress = NO;
        // check if game over
        [self checkIfSuccessfullyCompletedTowers];
    }
}

#pragma mark - Check If Completed Towers

-(void)checkIfSuccessfullyCompletedTowers {
    if ([[self.allTowersArray objectAtIndex:0]count] == TOWER_BLOCK_COUNT && [[self.allTowersArray objectAtIndex:1]count] == TOWER_BLOCK_COUNT && [[self.allTowersArray objectAtIndex:2]count] == TOWER_BLOCK_COUNT) {
        BOOL isGameOver;
        for (int i=1; i<=3; i++) {
            isGameOver = YES;
            NSArray *blockArray;
            int towerTag;
            if (i==1) {
                blockArray = [NSArray arrayWithArray:[self.allTowersArray objectAtIndex:0]];
                towerTag = i;
            } else if (i==2) {
                blockArray = [NSArray arrayWithArray:[self.allTowersArray objectAtIndex:1]];
                towerTag = i;
            } else if (i==3) {
                blockArray = [NSArray arrayWithArray:[self.allTowersArray objectAtIndex:2]];
                towerTag = i;
            }
            
            int blocksInATower = TOWER_BLOCK_COUNT;
            
            for (UIView *view in blockArray) {
                if (view.tag != towerTag) {
                    return;
                }
                
                UILabel *numberLabel = [view.subviews objectAtIndex:0];
                if ([numberLabel.text intValue] != blocksInATower) {
                    return;
                }
                blocksInATower--;
            }
        }
        if (isGameOver) {
            [self completedTowers];
        }
    }
}

-(void)makeBlockAlphaOneAfterCompletingAllTowersForTower:(NSArray *)tower blockNumber:(int)number {
    [UIView animateWithDuration:0.1 animations:^() {
        UIView *block = [tower objectAtIndex:number];
        block.backgroundColor = [UIColor colorWithRed:238./255. green:201./255. blue:0./255. alpha:1.0];
    }];
}

-(void)allTowersCompleteFindBlockToChangeAlpha {

    NSArray *towerArray;
    if (self.allTowersCompleteTower==1) {
        towerArray = [NSArray arrayWithArray:[self.allTowersArray objectAtIndex:0]];
    } else if (self.allTowersCompleteTower==2) {
        towerArray = [NSArray arrayWithArray:[self.allTowersArray objectAtIndex:1]];
    } else if (self.allTowersCompleteTower==3) {
        towerArray = [NSArray arrayWithArray:[self.allTowersArray objectAtIndex:2]];
    } else {
        [self performSelector:@selector(removeBlocksFromAllTowersArrayAfterCompletingAGame) withObject:nil afterDelay:0.30];
        [self.completedTowersAlphaTimer invalidate];
    }
    
    [self makeBlockAlphaOneAfterCompletingAllTowersForTower:towerArray blockNumber:self.allTowersCompleteBlockPosition];
    
    if (self.allTowersCompleteBlockPosition == towerArray.count - 1) {
        self.allTowersCompleteTower++;
        self.allTowersCompleteBlockPosition = 0;
    } else {
        self.allTowersCompleteBlockPosition++;
    }    
}

-(void)completedTowers {

    self.isGameOver = YES;

    self.completedTowersAlphaTimer = [NSTimer scheduledTimerWithTimeInterval:0.10f
                                                                      target:self
                                                                    selector:@selector(allTowersCompleteFindBlockToChangeAlpha)
                                                                    userInfo:nil
                                                                     repeats:YES];

}

#pragma mark - Remove All Block Views

-(void)removeBlocksFromAllTowersArrayAfterCompletingAGame {
    UIColor *color;
    NSMutableArray *array;
    UIView *view;
    for (int tower=0; tower<self.allTowersArray.count; tower++) {
        array = [self.allTowersArray objectAtIndex:tower];
        color = [self getBlockColorForTower:tower];
        for (int j=0; j<array.count; j++) {
            view = [array objectAtIndex:j];
            view.backgroundColor = color;
            [view removeFromSuperview];
        }
        [array removeAllObjects];
    }
    
    [self createNewGame];
}

#pragma mark - Update Counter

-(void)updateGameTimer {
    if (self.isScreenLocked) {
        return; 
    }
    
    if (self.isGameOver) {
        self.isScreenLocked = YES;
        [self.gameTimer invalidate];
        self.gameTimeLabel.text = [NSString stringWithFormat:@"%.1f", self.gameTimeCounter];
    } else {
        if (self.gameTimeCounter < 9999.9) {
            self.gameTimeCounter += 0.1;
            self.gameTimeLabel.text = [NSString stringWithFormat:@"%d", (int)self.gameTimeCounter];
        }
    }
}

#pragma mark - Pause Button

-(void)pauseButtonPressed {
    self.isScreenLocked = YES;
    PauseScreenViewController *pauseViewController = [[PauseScreenViewController alloc]initWithNibName:@"PauseScreenViewController" bundle:nil];
    pauseViewController.delegate = self;
    pauseViewController.gameTime = self.gameTimeCounter;
    [self presentModalViewController:pauseViewController animated:NO];     
}

-(void)pauseResumeButtonPressed {
    [self dismissModalViewControllerAnimated:NO];  
    self.isScreenLocked = NO;
}

#pragma mark - View Did Unload

- (void)viewDidUnload
{
    [self setGameDirectionsView:nil];
    [self setNavigationBar:nil];
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


@end
