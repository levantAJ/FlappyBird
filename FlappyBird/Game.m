//
//  Game.m
//  flapping
//
//  Created by AJ on 3/22/14.
//  Copyright (c) 2014 AJ. All rights reserved.
//

#import "Game.h"

@interface Game ()

@end

@implementation Game

-(IBAction)StartGame:(id)sender{
    TunnelTop.hidden = NO;
    TunnelBottom.hidden = NO;
    StartGame.hidden = YES;
    IsDied = NO;
    IsScored = YES;
    Scores = 0;
    Score.text = [NSString stringWithFormat:@"%d", Scores];
    Bird.image = [UIImage imageNamed:BirdStraight];
    Bird.center = CGPointMake(60, 264);
    BirdMovement = [NSTimer scheduledTimerWithTimeInterval:0.045 target:self selector:@selector(BirdMoving) userInfo:Nil repeats:YES];
    
    [self PlaceTunnels];
    
    TunnelMoverment = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(TunelMoving) userInfo:nil repeats:YES];
    
    BackGroundMoverment = [NSTimer scheduledTimerWithTimeInterval:0.045 target:self selector:@selector(BackGroundMoving) userInfo:nil repeats:YES];
}

-(void)PlaceTunnels{
    IsScored =YES;
    RandomTopTunnelPossition = arc4random() % 350;
    RandomTopTunnelPossition = RandomTopTunnelPossition - 228;
    
    RandomBottomTunnelPossition = RandomTopTunnelPossition + 655;
    
    TunnelTop.center = CGPointMake(340, RandomTopTunnelPossition);
    TunnelBottom.center =CGPointMake(340, RandomBottomTunnelPossition);
}


-(void)BackGroundMoving{
    BackGroundRuning.center = CGPointMake(BackGroundRuning.center.x-0.1, BackGroundRuning.center.y);
    if (BackGroundRuning.center.x+BackGroundRuning.bounds.size.width/2 < 0) {
        BackGroundRuning.center = CGPointMake(350, BackGroundRuning.center.y);
    }
    Cloud2.center = CGPointMake(Cloud2.center.x-0.3, Cloud2.center.y);
    if (Cloud2.center.x+Cloud2.bounds.size.width/2 < 0) {
        Cloud2.center = CGPointMake(350, Cloud2.center.y);
    }
}

-(void)TunelMoving{
    TunnelTop.center = CGPointMake(TunnelTop.center.x-1, TunnelTop.center.y);
    TunnelBottom.center = CGPointMake(TunnelBottom.center.x-1, TunnelBottom.center.y);
    
    // Bird died
    if ((Bird.center.x+Bird.bounds.size.width/2>=TunnelTop.center.x-TunnelTop.bounds.size.width/2 && Bird.center.x+Bird.bounds.size.width/2<=TunnelTop.center.x+TunnelTop.bounds.size.width/2) || (Bird.center.x-Bird.bounds.size.width/2>=TunnelTop.center.x-TunnelTop.bounds.size.width/2 && Bird.center.x-Bird.bounds.size.width/2<=TunnelTop.center.x+TunnelTop.bounds.size.width/2)) {
        if ((Bird.center.y-Bird.bounds.size.height/2>=TunnelTop.center.y-TunnelTop.bounds.size.height/2 && Bird.center.y-Bird.bounds.size.height/2<=TunnelTop.center.y+TunnelTop.bounds.size.height/2) || (Bird.center.y+Bird.bounds.size.height/2<=TunnelBottom.center.y+TunnelBottom.bounds.size.height/2 && Bird.center.y+Bird.bounds.size.height/2>=TunnelBottom.center.y-TunnelBottom.bounds.size.height/2)) {
            [self playAudio:@"crash" :@"wav"];
            IsDied = YES;
            [TunnelMoverment invalidate];
            TunnelMoverment = nil;
        }
    }
    
    if (Bird.center.x-Bird.bounds.size.width/2>TunnelTop.center.x + TunnelTop.bounds.size.width/2 && IsScored==YES) {
        IsScored = NO;
        Scores++;
        [self playAudio:@"ding" :@"wav"];
        Score.text = [NSString stringWithFormat:@"%d", Scores];
    }
    if (TunnelTop.center.x < -28) {
        [self PlaceTunnels];
    }
}

-(void)BirdMoving{
    Bird.center = CGPointMake(Bird.center.x, (Bird.center.y-BirdFlight)<32?45:(Bird.center.y-BirdFlight));
    //Bird.center = CGPointMake(Bird.center.x, Bird.center.y-BirdFlight);
    BirdFlight = BirdFlight - 5;
    
    if (BirdFlight<-15) {
        BirdFlight=-15;
    }
    if (BirdFlight>15) {
        Bird.image = [UIImage imageNamed:BirdUp];
    }
    if (BirdFlight>-10 && BirdFlight<15) {
        Bird.image = [UIImage imageNamed:BirdStraight];
    }
    if (BirdFlight<-10 && IsDied==NO) {
        Bird.image = [UIImage imageNamed:BirdDown];
    }
    if (BirdFlight<-10 && IsDied==YES) {
        Bird.image = [UIImage imageNamed:BirdDied];
    }
    // Down to died
    if (Bird.center.y >= Bottom.center.y-Bottom.bounds.size.height/2) {
        if (IsDied==NO) {
            [self playAudio:@"crash" :@"wav"];
        }
        [BirdMovement invalidate];
        BirdMovement = nil;
        [TunnelMoverment invalidate];
        TunnelMoverment = nil;
        StartGame.hidden = NO;
        Bird.image = [UIImage imageNamed:BirdStraight];
        
        if (Scores > HighestScored) {
            [self writeStringToFile:[NSString stringWithFormat:@"%d", Scores] theFileName:HighestScoredFile];
            HighestScored = Scores;
        }
        Score.text = [NSString stringWithFormat:@"0"];
        [self showGrid];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (IsDied==NO) {
        [self playAudio:@"flap" :@"wav"];
        if (Bird.center.y-25 <= Top.center.y+Top.bounds.size.height/2) {
            BirdFlight = Bird.center.y-25;
        }else{
            BirdFlight = 25;
        }
    }
}

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
    TunnelTop.hidden =YES;
    TunnelBottom.hidden = YES;
    [super viewDidLoad];
    HighestScored = [[self readStringFromFile:HighestScoredFile] intValue];
    [self.view bringSubviewToFront:Bottom];
    [self.view bringSubviewToFront:StartGame];
    [self.view bringSubviewToFront:Bird];
	// Do any additional setup after loading the view.
    [Score setFont:[UIFont fontWithName:@"04b_19" size:50]];
    Score.shadowColor = [UIColor blackColor];
    Score.shadowOffset = CGSizeMake(3.0, 3.0);
    
    StartGame.titleLabel.font =[UIFont fontWithName:@"04b_19" size:15];
    StartGame.titleLabel.shadowColor = [UIColor blackColor];
    StartGame.titleLabel.shadowOffset = CGSizeMake(2.0, 2.0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RNGridMenuDelegate

- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Unlogin in Facebook"
                                                        message:@"Please login to Facebook first!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    switch (itemIndex) {
        case 2:
            // Share facebook
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
            {
                SLComposeViewController *facebookSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                [facebookSheet setInitialText:@"Here we go, my score :)"];
                [facebookSheet addImage:[self screenshot]];
                [facebookSheet addURL:[NSURL URLWithString:@"https://www.facebook.com/levantai"]];
                [self presentViewController:facebookSheet animated:YES completion:nil];
            }else{
                alertView.title = @"Sorry";
                alertView.message = @"You can't send a status right now, make sure your device has an internet connection and you have at least one Facebook account setup";
                
                [alertView show];
            }
            break;
        case 3:
            // Share twitter
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            {
                SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                [tweetSheet setInitialText:@"Here we go, my score :)"];
                // Share image
                [tweetSheet addImage:[self screenshot]];
                // Share link
                [tweetSheet addURL:[NSURL URLWithString:@"@levantAJ"]];
                
                [self presentViewController:tweetSheet animated:YES completion:nil];
            }
            else{
                alertView.title = @"Sorry";
                alertView.message = @"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup";
                [alertView show];
            }
            break;
        default:
            break;
    }
}


#pragma mark - Show information
- (void)showGrid {
    NSInteger numberOfOptions = 5;
    NSArray *items = @[
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"bird.png"] title:[NSString stringWithFormat:@"%d", Scores]],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"highest.png"] title:[NSString stringWithFormat:@"%d", HighestScored]],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"facebook.png"] title:@"Facebook"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"twitter.png"] title:@"Twitter"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"newgame.png"] title:@"NEW GAME"]
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    av.itemFont =[UIFont fontWithName:@"04b_19" size:15];
    //    av.bounces = NO;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}


#pragma WRITE - READ FILE
- (void)writeStringToFile:(NSString*)stringData theFileName:(NSString*)fileName {
    
    // Build the path, and create if needed.
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
        [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
    }
    
    // The main act...
    [[stringData dataUsingEncoding:NSUTF8StringEncoding] writeToFile:fileAtPath atomically:NO];
}

- (NSString*)readStringFromFile:(NSString*)fileName {
    
    // Build the path...
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];
    
    // The main act...
    return [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:fileAtPath] encoding:NSUTF8StringEncoding];
}

#pragma play sound
-(void)playAudio:(NSString *)name:(NSString *)extension{
    SystemSoundID soundID;
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:name ofType:extension];
    NSURL *soundUrl = [NSURL fileURLWithPath:soundPath];
    
    AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundUrl, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

#pragma Take sapshot
- (UIImage *) screenshot{
    CGRect rect;
    rect=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
