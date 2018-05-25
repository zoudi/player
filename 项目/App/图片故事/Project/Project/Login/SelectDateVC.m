//
//  SelectDateVC.m
//  Project
//
//  Created by masha on 2018/5/20.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import "SelectDateVC.h"

@interface SelectDateVC ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation SelectDateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.dateStr.length){
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
        
        dateFormatter.dateFormat=@"yyyy-MM-dd";//指定转date得日期格式化形式
        self.datePicker.date = [dateFormatter dateFromString:self.dateStr];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonAction:(UIButton *)sender {
    if(sender.tag == 101){
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
        dateFormatter.dateFormat=@"yyyy-MM-dd";
        self.dateBlock([dateFormatter stringFromDate:self.datePicker.date]);
    }
    [self.navigationController popViewControllerAnimated:YES];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
