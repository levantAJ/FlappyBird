//
//  ViewController.m
//  flapping
//
//  Created by AJ on 3/22/14.
//  Copyright (c) 2014 AJ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [flappyTitle setFont:[UIFont fontWithName:@"04b_19" size:50]];
    flappyTitle.shadowColor = [UIColor blackColor];
    flappyTitle.shadowOffset = CGSizeMake(3.0, 3.0);
    
    flapping.titleLabel.font =[UIFont fontWithName:@"04b_19" size:31];
    flapping.titleLabel.shadowColor = [UIColor blackColor];
    flapping.titleLabel.shadowOffset = CGSizeMake(2.0, 2.0);
    
    about.titleLabel.font =[UIFont fontWithName:@"04b_19" size:15];
    about.titleLabel.shadowColor = [UIColor blackColor];
    about.titleLabel.shadowOffset = CGSizeMake(2.0, 2.0);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)facebookTapped:(UITapGestureRecognizer *)gr {
    //    UIImageView *theImageViewThatGotTapped = (UIImageView *)gr.view;
}

- (void)twitterTapped:(UITapGestureRecognizer *)gr {
    //    UIImageView *theImageViewThatGotTapped = (UIImageView *)gr.view;
}

-(IBAction)showAbout:(id)sender{
    [self showGrid];
}

#pragma mark - RNGridMenuDelegate

- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    NSLog(@"Dismissed with item %d: %@", itemIndex, item.title);
    switch (itemIndex) {
        case 0:
            // Twitter link
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/levantAJ"]];
            break;
        case 1:
            // Facebook twitter
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/levantai"]];
            break;
        default:
            break;
    }
}

#pragma mark - Show information
- (void)showGrid {
    NSInteger numberOfOptions = 3;
    NSArray *items = @[
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"twitter.png"] title:@"@levantAJ"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"facebook.png"] title:@"Le Van Tai"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"bird.png"] title:@"Close"]
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    av.itemFont =[UIFont fontWithName:@"04b_19" size:15];
    //    av.bounces = NO;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}

@end
