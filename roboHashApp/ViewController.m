//
//  ViewController.m
//  roboHashApp
//
//  Created by Cenker Demir on 10/23/17.
//  Copyright © 2017 home. All rights reserved.
//

#import "ViewController.h"
#import "RoboHashViewController.h"
#import <SVProgressHUD.h>

@interface ViewController ()
    
@property (weak, nonatomic) IBOutlet UITextField *stringTextfield;
@property (weak, nonatomic) IBOutlet UIButton *roboHashButton;
@property (strong, nonatomic) UIImage *recievedImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //reset the textfield upon returning back
    self.stringTextfield.text = @"";
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action method for button tap
- (IBAction)didTapRoboHashButton:(UIButton *)sender {
    [self.stringTextfield resignFirstResponder];
    if(self.stringTextfield.text != nil && ![self.stringTextfield.text isEqualToString:@""]) {
        [SVProgressHUD showWithStatus:@"Getting Your Robo Hash..."];
        
        [self getImageFromURLString:self.stringTextfield.text completionHandler:^(UIImage *image, NSError *error) {
            if(error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [self presentErrorAlert];
                });
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.recievedImage = image;
                    [SVProgressHUD dismiss];
                    [self performSegueWithIdentifier:@"roboHashSegue" sender:nil];
                });
            }
            
        }];
    }
}

#pragma mark - error alert
- (void)presentErrorAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"We encountered an error while trying to get your robo hash. Please try again." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"roboHashSegue"]) {
        RoboHashViewController *vc = (RoboHashViewController *)segue.destinationViewController;
        vc.roboHashImage = self.recievedImage;
    }
}
 
#pragma mark - image download from robohash
- (void)getImageFromURLString:(NSString *)urlString
            completionHandler: (void(^)(UIImage *image, NSError *error))completionHandler {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://robohash.org/%@", urlString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error) {
            completionHandler(nil, error);
        }
        else {
            UIImage *image = [UIImage imageWithData:data];
            completionHandler(image, nil);
        }
        
    }];
    
    [dataTask resume];
}
    
    
    
@end
