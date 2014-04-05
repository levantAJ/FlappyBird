//
//  ViewController.h
//  flapping
//
//  Created by AJ on 3/22/14.
//  Copyright (c) 2014 AJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNGridMenu.h"


@interface ViewController : UIViewController <RNGridMenuDelegate>
{
    IBOutlet UILabel *flappyTitle;
    IBOutlet UIButton *about;
    IBOutlet UIButton *flapping;
}

-(IBAction)showAbout:(id)sender;

@end
