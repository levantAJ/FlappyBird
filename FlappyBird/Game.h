//
//  Game.h
//  flapping
//
//  Created by AJ on 3/22/14.
//  Copyright (c) 2014 AJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNGridMenu.h"
#import <AudioToolbox/AudioToolbox.h>
#import <Social/Social.h>

int BirdFlight;
int RandomTopTunnelPossition;
int RandomBottomTunnelPossition;
NSString * BirdUp = @"birdup.png";
NSString * BirdDied = @"birddie.png";
NSString * BirdDown = @"birddown.png";
NSString * BirdStraight = @"bird.png";
NSString * HighestScoredFile = @"highest.txt";

int Scores = -1;
int HighestScored = 0;
BOOL IsDied;
BOOL IsScored;

@interface Game : UIViewController <RNGridMenuDelegate>
{
    IBOutlet UIImageView * Bird;
    IBOutlet UIButton * StartGame;
    IBOutlet UILabel *Score;
    
    IBOutlet UIImageView *TunnelTop;
    IBOutlet UIImageView *TunnelBottom;
    IBOutlet UIImageView *Top;
    IBOutlet UIImageView *Bottom;
    IBOutlet UIImageView *BackGround;
    IBOutlet UIImageView *BackGroundRuning;
    IBOutlet UIImageView *Cloud2;
    
    NSTimer *BirdMovement;
    NSTimer *TunnelMoverment;
    NSTimer *BackGroundMoverment;
}
-(IBAction)StartGame:(id)sender;
-(void)BirdMoving;
-(void)TunelMoving;
-(void)PlaceTunnels;
@end
