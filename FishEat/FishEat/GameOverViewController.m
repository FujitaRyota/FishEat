//
//  GameOverViewController.m
//  FishEat
//
//  Created by FujitaRyota on 2015/11/13.
//  Copyright © 2015年 FujitaRyota. All rights reserved.
//

#import "GameOverViewController.h"

@interface GameOverViewController ()

@end

@implementation GameOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    self.finishScore.text = [NSString stringWithFormat:@"Score: %ld", _inheritScore];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)moveTitleView:(id)sender{
    [self performSegueWithIdentifier:@"toTitleView" sender:self];
}

-(IBAction)tweetView:(id)sender{
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"ツイートエラー"
                                                        message:@"Twitterアカウントが設定されていません。"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    NSString* text = @"ﾁｮ～えきさいちんぐ！";
    NSURL* URL = [NSURL URLWithString:@"【FishEat】URL~~~~~~~."];
    NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"hogehoge"]];
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [controller setInitialText:text];
    [controller addURL:URL];
    [controller addImage:[[UIImage alloc] initWithData:imageData]];
    controller.completionHandler =^(SLComposeViewControllerResult result){
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:controller animated:YES completion:nil];
}

@end
