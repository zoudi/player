//
//  PublishTopicTableVC.m
//  football
//
//  Created by masha on 2018/5/28.
//  Copyright © 2018年 邹笛. All rights reserved.
//

#import "PublishTopicTableVC.h"
#import "UITextView+WZB.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "MBProgressHUD+ZD.h"
#import "SelectLocationTableVC.h"
#import <AVOSCloud/AVOSCloud.h>
#import "LoginTableVC.h"

@interface PublishTopicTableVC ()
@property (weak, nonatomic) IBOutlet UITextView *Topic;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (nonatomic, strong)AMapLocationManager *locationManager;
@property (nonatomic, strong)CLLocation *ZDLocation;

@end

@implementation PublishTopicTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.Topic.wzb_placeholder = @"与大家分享话题！";
    self.Topic.wzb_placeholderColor = [UIColor lightGrayColor];
      self.locationManager = [[AMapLocationManager alloc] init];
     //    self.locationManager.delegate = self;
     
     // 带逆地理信息的一次定位（返回坐标和地址信息）
     [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
     //   定位超时时间，最低2s，此处设置为10s
     self.locationManager.locationTimeout =2;
     //   逆地理请求超时时间，最低2s，此处设置为10s
     self.locationManager.reGeocodeTimeout = 2;
     // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
     [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
     
         if (error)
         {
             NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
     
             if (error.code == AMapLocationErrorLocateFailed)
             {
                 [MBProgressHUD showError:@"定位失败：请在设置中允许football\n使用定位服务"];
                 return;
             }
         }
     
         self.ZDLocation = location;
     
         if (regeocode)
         {
             self.location.text = [[regeocode.city stringByAppendingString:@" "]stringByAppendingString:regeocode.district];
         }
     }];
}

//invitation
- (IBAction)publish:(UIBarButtonItem *)sender {
    if ([AVUser currentUser]) {
        if (self.Topic.text) {
            AVObject *invitation = [AVObject objectWithClassName:@"Invitation"];
            [invitation setObject:self.Topic.text forKey:@"title"];
            [invitation setObject:[AVUser currentUser] forKey:@"user"];
            if (self.ZDLocation) {
                [invitation setObject:self.location.text forKey:@"locationName"];
                CLLocationCoordinate2D coordinate = self.ZDLocation.coordinate;
                AVGeoPoint *point = [AVGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude];
                [invitation setObject:point forKey:@"location"];
            }else{
                [invitation setObject:@"未知" forKey:@"locationName"];
                
            }
            
            [invitation saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (!error) {
                    [MBProgressHUD showSuccess:@"发表成功！"];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [MBProgressHUD showError:@"发表失败！"];
                }
            }];
        }
    }else{
        LoginTableVC *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginTableVC"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"pushLocation"]) {
        SelectLocationTableVC *vc = segue.destinationViewController;
        vc.location = self.ZDLocation;
        [vc setLocationBlock:^(AMapPOI *model) {
            self.location.text = model.name;
        }];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
