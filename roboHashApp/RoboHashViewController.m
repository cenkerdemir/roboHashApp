//
//  RoboHashViewController.m
//  roboHashApp
//
//  Created by Cenker Demir on 10/23/17.
//  Copyright © 2017 home. All rights reserved.
//

#import "RoboHashViewController.h"

@interface RoboHashViewController ()
    
@property (weak, nonatomic) IBOutlet UIImageView *roboHashImageView;
    
@end

@implementation RoboHashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.roboHashImageView.image = self.roboHashImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
