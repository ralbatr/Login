//
//  LoginVC.m
//  yellowpage
//
//  Created by Ralbatr Yi on 14-12-19.
//  Copyright (c) 2014年 com.yingnet. All rights reserved.
//
//  用户 登录页面

#import "LoginVC.h"
#import "AppUtil.h"
#import "RegisterVC.h"
#import "FindPwdVC.h"
#import <CoreLocation/CoreLocation.h>

//iPhone的宽度
#define iPwidth [[UIScreen mainScreen] bounds].size.width

@interface LoginVC ()<UITextFieldDelegate,CLLocationManagerDelegate>
{
    CLLocationManager * _locationManager;
    float _latitude;
    float _longitude;
    NSString *_cityCode;
    NSString *_cityName;

    UITextField *_nameTextField;
    UITextField *_pwdTextField;
    UITextField *_prePwdTF;
    UIButton *_loginButton;
    UIButton *_registerButton;
    UIButton *_noNameButton;  // 无账号登录
    UIButton *_findPwdButton;
    OLGhostAlertView *_ghostView;
}
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kbgColor;
    [self setTitle:@"登录"];
    [self initView];
    [self addTap];
    [self startLocation];
    
    _ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:0.5 dismissible:YES];
    _ghostView.position = OLGhostAlertViewPositionCenter;
}
#pragma mark - 界面
- (void)initView
{
    _nameTextField  = [[UITextField alloc] init];
    _pwdTextField   = [[UITextField alloc] init];
    _loginButton    = [[UIButton alloc] init];
    _findPwdButton  = [[UIButton alloc] init];
    _noNameButton   = [[UIButton alloc] init];
    UILabel *label  = [[UILabel alloc] init];
    UIImageView *bgImage = [[UIImageView alloc] init];
    UILabel *otherLabel  = [[UILabel alloc] init];
    
    
    _nameTextField.font = kfont;
    _pwdTextField.font  = kfont;
    _loginButton.titleLabel.font   = kfont;
    _findPwdButton.titleLabel.font = kfont;
    _noNameButton.titleLabel.font  = kfont;
    
    bgImage.image             = [UIImage imageNamed:@"bgL.png"];
    _nameTextField.background = [UIImage imageNamed:@"get.png"];
    _pwdTextField.background  = [UIImage imageNamed:@"get.png"];
    
    _nameTextField.returnKeyType = UIReturnKeyNext;
    _pwdTextField.returnKeyType  = UIReturnKeyDone;
    
    label.text = @"中国硅谷有限公司";
    otherLabel.text = @"还没有帐号";
    
    label.font      = [UIFont systemFontOfSize:12.0];
    otherLabel.font = [UIFont systemFontOfSize:12.0];
    
    label.textColor = [UIColor grayColor];
    otherLabel.textColor = [UIColor grayColor];
    
    _nameTextField.delegate = self;
    _pwdTextField.delegate  = self;
    
    _nameTextField.placeholder = @"用户名";
    _pwdTextField.placeholder  = @"密码";
    // 设置 键盘类型
    _nameTextField.keyboardType  = UIKeyboardTypeNumberPad;
    _nameTextField.returnKeyType = UIReturnKeyNext;
    _pwdTextField.returnKeyType  = UIReturnKeyDone;
    
    [_pwdTextField setSecureTextEntry:YES];
    [_loginButton setTitle:@"登 录" forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(loginAciton) forControlEvents:UIControlEventTouchUpInside];
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"login.png"] forState:UIControlStateNormal];
    
    [_findPwdButton setTitle:@"找回密码" forState:UIControlStateNormal];
    [_findPwdButton addTarget:self action:@selector(findAction) forControlEvents:UIControlEventTouchUpInside];
    [_findPwdButton setTitleColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login.png"]] forState:UIControlStateNormal];
  
    [_noNameButton setTitle:@"注册" forState:UIControlStateNormal];
    [_noNameButton addTarget:self action:@selector(registerAciton) forControlEvents:UIControlEventTouchUpInside];
    [_noNameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_noNameButton setBackgroundImage:[UIImage imageNamed:@"login.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:bgImage];
    [self.view addSubview:_nameTextField];
    [self.view addSubview:_pwdTextField];
    [self.view addSubview:_loginButton];
    [self.view addSubview:_findPwdButton];
    [self.view addSubview:_noNameButton];
    [self.view addSubview:label];
    [self.view addSubview:otherLabel];
    
    _nameTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _pwdTextField.translatesAutoresizingMaskIntoConstraints  = NO;
    _loginButton.translatesAutoresizingMaskIntoConstraints   = NO;
    _findPwdButton.translatesAutoresizingMaskIntoConstraints = NO;
    _noNameButton.translatesAutoresizingMaskIntoConstraints  = NO;
    otherLabel.translatesAutoresizingMaskIntoConstraints     = NO;
    bgImage.translatesAutoresizingMaskIntoConstraints        = NO;
    label.translatesAutoresizingMaskIntoConstraints          = NO;

    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_nameTextField,_pwdTextField,_loginButton,_findPwdButton,_noNameButton,label,bgImage);
    
    NSArray *constraintsBG = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-80-[bgImage(190)]" options:0 metrics:0 views:viewsDictionary];
    NSArray *constraintsBGH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[bgImage]-10-|" options:0 metrics:0 views:viewsDictionary];
    
    NSArray *constraintsArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-90-[_nameTextField]-25-[_pwdTextField]-25-[_loginButton]-25-[_findPwdButton]-100-[_noNameButton]" options:NSLayoutFormatAlignAllLeft metrics:0 views:viewsDictionary];
    
    NSArray *constraintsArray3 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-90-[_nameTextField]-25-[_pwdTextField]-25-[_loginButton]-25-[_findPwdButton]-100-[_noNameButton]" options:NSLayoutFormatAlignAllRight metrics:0 views:viewsDictionary];
    
    NSArray *constraintsArray2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-30-|" options:NSLayoutFormatAlignAllCenterX metrics:0 views:viewsDictionary];
//    NSArray *constraintsArray4 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[label]-30-|" options:NSLayoutFormatAlignAllCenterX metrics:0 views:viewsDictionary];
    
    NSArray *constraintsArrayH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-55-[_nameTextField]-40-|" options:0 metrics:0 views:viewsDictionary];
    NSArray *constraintsArrayH3 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=40-[_findPwdButton]->=40-|" options:0 metrics:0 views:viewsDictionary];
    
    
    // Make label's CenterX the same as self.view's CenterX.
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label  attribute:NSLayoutAttributeCenterX  relatedBy:NSLayoutRelationEqual  toItem:self.view  attribute:NSLayoutAttributeCenterX  multiplier:1  constant:0]];
    [self.view addConstraints:constraintsBG];
    [self.view addConstraints:constraintsBGH];
    [self.view addConstraints:constraintsArray];
    [self.view addConstraints:constraintsArray2];
    [self.view addConstraints:constraintsArray3];
    [self.view addConstraints:constraintsArrayH];
    [self.view addConstraints:constraintsArrayH3];
    
    // 四个右边的小图片
    UIImageView *phoneImage = [[UIImageView alloc] init];
    UIImageView *pwdImage   = [[UIImageView alloc] init];
    
    phoneImage.image = [UIImage imageNamed:@"REG_phone.png"];
    pwdImage.image = [UIImage imageNamed:@"reg_lock.png"];
  
    phoneImage.translatesAutoresizingMaskIntoConstraints = NO;
    pwdImage.translatesAutoresizingMaskIntoConstraints   = NO;
    
    [self.view addSubview:phoneImage];
    [self.view addSubview:pwdImage];
    
    NSDictionary *imageDictionary = NSDictionaryOfVariableBindings(phoneImage,pwdImage,otherLabel);

    NSArray *constraintsImageArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-95-[phoneImage]-25-[pwdImage]-160-[otherLabel(30)]" options:NSLayoutFormatAlignAllLeft metrics:0 views:imageDictionary];
    
    NSArray *constraintsImageArrayH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[phoneImage]" options:0 metrics:0 views:imageDictionary];

    [self.view addConstraints:constraintsImageArray];
    [self.view addConstraints:constraintsImageArrayH];
}
#pragma mark - 登录
- (void)loginAciton
{
    [self managerKeyBoard];
    //判断 用户输入的是否准确
    if ([AppUtil checkTel:_nameTextField.text]) {
        // 进行网络请求
        [self requestDataIsSee:NO];
    }else
    {
        _ghostView.message = @"请按要求输入用户名及密码！";
        [_ghostView show];
    }
}

#pragma mark - 找回密码
- (void)findAction
{
    FindPwdVC *findVC = [[FindPwdVC alloc] init];
    [self.navigationController pushViewController:findVC animated:YES];
}

#pragma mark - 注册
- (void)registerAciton
{
    RegisterVC *registerVC = [[RegisterVC alloc] init];
    registerVC.cityName = _cityName;
    registerVC.cityCode = _cityCode;
    [self.navigationController pushViewController:registerVC animated:YES];
}
#pragma mark - 请求网络
- (void)requestDataIsSee:(BOOL)isSee
{
    if([_nameTextField.text isEqualToString:@"15112345678"])
    {
        //存储密码资料
        if ([AppUtil isExistKeychain]) {
            [SSKeychain deletePasswordForService:kService account:@"account"];
        }
        NSDictionary *data = [NSDictionary dictionaryWithObject:_nameTextField.text forKey:@"name"];
        NSMutableData *dat = [AppUtil dictionaryTodata:data];
        [AppUtil writeToKeychain:dat];
        [self dismissViewControllerAnimated:YES completion:nil];
        _ghostView.message = @"登录成功！";
    }else
    {
        _ghostView.message = @"用户名或密码错误，请重试！";
    }
    [_ghostView show];
}
#pragma mark - 处理键盘
- (void)managerKeyBoard
{
    [self.view endEditing:YES];
}

#pragma mark - 添加 手势
- (void)addTap
{
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(managerKeyBoard)];
    closeTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:closeTap];
}
#pragma mark - uitextfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!_prePwdTF) {
        _prePwdTF = textField;
    }else
    {
        _prePwdTF.background = [UIImage imageNamed:@"get.png"];
        _prePwdTF = textField;
    }
    textField.background = [UIImage imageNamed:@"lost.png"];
}

#pragma mark - 定位
- (void)startLocation{
    
    if (![CLLocationManager locationServicesEnabled] )
    {
        _ghostView.message = @"定位失败，请手动选择城市！";
        [_ghostView show];
    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        _ghostView.message = @"请允许使用你的地理位置！";
        [_ghostView show];
    }
    else
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
            //开启定位
            _locationManager = [[CLLocationManager alloc] init];//创建位置管理器
            _locationManager.delegate=self;
            _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
            _locationManager.distanceFilter=1000.0f;
            //启动位置更新
            
        }
        else
        {
            _locationManager = [[CLLocationManager alloc]init];
            _locationManager.delegate = self;
            [_locationManager requestAlwaysAuthorization];
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            _locationManager.distanceFilter = kCLDistanceFilterNone;
            //[_locationManager startUpdatingLocation];
        }
        [_locationManager startUpdatingLocation];
    }

}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    [_locationManager stopUpdatingLocation];
    
    NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f 纬度:%3.5f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
    
    _latitude = newLocation.coordinate.latitude;
    _longitude = newLocation.coordinate.longitude;
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil &&[placemarks count] > 0) {
            for (CLPlacemark * placemark in placemarks) {
                NSLog(@"%@",placemarks);
                NSDictionary *test = [placemark addressDictionary];
                //  Country(国家)  State(城市)  SubLocality(区)
                NSLog(@"%@", [test objectForKey:@"City"]);
                [self cityNameToCode:[test objectForKey:@"City"]];
                _cityName = [test objectForKey:@"City"];
            }
        }
        else if (error == nil &&
                 [placemarks count] == 0){
            NSLog(@"No results were returned.");
        }
        else if (error != nil){
            NSLog(@"An error occurred = %@", error);
        }
    }];
    
}
- (void)cityNameToCode:(NSString *)cityName
{

}


@end
