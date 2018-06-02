//
//  FeedbackViewController.m
//  football
//
//  Created by masha on 2018/5/29.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import "FeedbackViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MBProgressHUD+ZD.h"
#import "UITextView+WZB.h"

@interface FeedbackViewController ()
@property (weak, nonatomic) IBOutlet UITextView *titleTextF;
@property (weak, nonatomic) IBOutlet UITextField *phon;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleTextF.wzb_placeholder = @"请填写意见建议";
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submit:(id)sender {
    if (!self.titleTextF.text.length) {
        [MBProgressHUD showError:@"请填写意见建议！"];

    }else{
        AVObject *comment = [AVObject objectWithClassName:@"Feedback"];
        if ([AVUser currentUser]) {
            [comment setObject:[AVUser currentUser] forKey:@"user"];
        }
        if (self.phon.text.length) {
            [comment setObject:self.phon.text forKey:@"phon"];
        }
        [comment setObject:self.titleTextF.text forKey:@"title"];
        [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (!error) {
                [MBProgressHUD showSuccess:@"提交成功"];
                self.titleTextF.text = @"";
                self.phon.text = @"";
            }
        }];
    }
   
}


@end
