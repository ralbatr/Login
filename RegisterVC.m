//
//  registerVC.m
//  yellowpage
//
//  Created by Ralbatr Yi on 14-12-19.
//  Copyright (c) 3014年 com.yingnet. All rights reserved.
//

#import "RegisterVC.h"
#import "OLGhostAlertView.h"
#import <CoreLocation/CoreLocation.h>
#import "AppUtil.h"

#define kCityTextFieldTag 1011

@interface RegisterVC ()<UITextFieldDelegate,CLLocationManagerDelegate>
{
    UITextField *_nameTextField;
    UITextField *_pwdTextField;
    UITextField *_pwd2TextField;
    UITextField *_companyTextField;
    UITextField *_cityTextField;
    UIButton *_registerButton;
    
    OLGhostAlertView *_ghostView;
    
    CLLocationManager * _locationManager;
    //BOOL _isPan;
    float _latitude;
    float _longitude;
}

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"注册"];
    self.view.backgroundColor = kbgColor;
    [self initView];
    [self addTap];
    if (self.cityName.length == 0) {
        [self startLocation];
    }
    //提醒试图
    _ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:0.5 dismissible:YES];
    _ghostView.position = OLGhostAlertViewPositionCenter;
}
#pragma mark - 界面
- (void)initView
{
    _nameTextField    = [[UITextField alloc] init];
    _pwdTextField     = [[UITextField alloc] init];
    _pwd2TextField    = [[UITextField alloc] init];
    _companyTextField = [[UITextField alloc] init];
    _cityTextField    = [[UITextField alloc] init];
    _registerButton   = [[UIButton alloc] init];
    
    _nameTextField.font    = kfont;
    _pwdTextField.font     = kfont;
    _pwd2TextField.font    = kfont;
    _companyTextField.font = kfont;
    _cityTextField.font    = kfont;
    _registerButton.titleLabel.font = kfont;
    
    _nameTextField.background = [UIImage imageNamed:@"get.png"];
    _pwdTextField.background  = [UIImage imageNamed:@"get.png"];
    _pwd2TextField.background = [UIImage imageNamed:@"get.png"];
    _cityTextField.background = [UIImage imageNamed:@"reg_option@2x.png"];
    
    
    _nameTextField.delegate = self;
    _pwd2TextField.delegate = self;
    _pwdTextField.delegate  = self;
    _cityTextField.delegate = self;
    _cityTextField.tag = kCityTextFieldTag;
    
    // 设置 键盘类型
    _nameTextField.keyboardType  = UIKeyboardTypeNumberPad;
    _nameTextField.returnKeyType = UIReturnKeyNext;
    _pwdTextField.returnKeyType  = UIReturnKeyDone;
    _pwd2TextField.returnKeyType = UIReturnKeyDone;
    _nameTextField.placeholder = @"请输入手机号";
    _pwdTextField.placeholder  = @"6-10位数字和字母组合的密码";
    _pwd2TextField.placeholder = @"确认密码";
    _cityTextField.placeholder = @"选择城市";
    if (self.cityName.length > 0) {
        _cityTextField.text = self.cityName;
    }
    if (self.cityName.length > 0) {
        _cityTextField.text = self.cityName;
    }
    [_pwdTextField setSecureTextEntry:YES];
    [_pwd2TextField setSecureTextEntry:YES];
    
    [_registerButton setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    [_registerButton setBackgroundImage:[UIImage imageNamed:@"nextH.png"]forState:UIControlStateHighlighted];
    [_registerButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_registerButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_registerButton addTarget:self action:@selector(registerAciton) forControlEvents:UIControlEventTouchUpInside];
    _registerButton.titleLabel.font = kfont;
    
    [self.view addSubview:_nameTextField];
    [self.view addSubview:_pwdTextField];
    [self.view addSubview:_pwd2TextField];
    [self.view addSubview:_companyTextField];
    [self.view addSubview:_cityTextField];
    [self.view addSubview:_registerButton];
    
    _nameTextField.translatesAutoresizingMaskIntoConstraints    = NO;
    _pwdTextField.translatesAutoresizingMaskIntoConstraints     = NO;
    _pwd2TextField.translatesAutoresizingMaskIntoConstraints    = NO;
    _companyTextField.translatesAutoresizingMaskIntoConstraints = NO;
    _cityTextField.translatesAutoresizingMaskIntoConstraints       = NO;
    _registerButton.translatesAutoresizingMaskIntoConstraints   = NO;
    
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_nameTextField,_pwdTextField,_pwd2TextField,_companyTextField,_cityTextField,_registerButton);
    
    
    NSArray *constraintsArray2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-80-[_nameTextField]-27-[_pwdTextField]-27-[_pwd2TextField]-27-[_cityTextField]" options:NSLayoutFormatAlignAllLeft metrics:0 views:viewsDictionary];
    NSArray *constraintsArray3 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-80-[_nameTextField]-27-[_pwdTextField]-27-[_pwd2TextField]" options:NSLayoutFormatAlignAllRight metrics:0 views:viewsDictionary];
    NSArray *constraintsArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_cityTextField]-27-[_registerButton]" options:0 metrics:0 views:viewsDictionary];
    
    NSArray *constraintsArrayH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[_nameTextField]-25-|" options:0 metrics:0 views:viewsDictionary];
    NSArray *constraintsArrayH2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[_registerButton]-25-|" options:0 metrics:0 views:viewsDictionary];
    
    [self.view addConstraints:constraintsArray];
    [self.view addConstraints:constraintsArray2];
    [self.view addConstraints:constraintsArray3];
    [self.view addConstraints:constraintsArrayH];
    [self.view addConstraints:constraintsArrayH2];
    
    // 四个右边的小图片
    UIImageView *phoneImage = [[UIImageView alloc] init];
    UIImageView *pwdImage   = [[UIImageView alloc] init];
    UIImageView *pwd2Image  = [[UIImageView alloc] init];
    UIImageView *cityImage  = [[UIImageView alloc] init];

    phoneImage.image = [UIImage imageNamed:@"REG_phone.png"];
    pwd2Image.image  = [UIImage imageNamed:@"reg_lock.png"];
    pwdImage.image   = [UIImage imageNamed:@"reg_lock.png"];
    cityImage.image  = [UIImage imageNamed:@"reg_map.png"];
    

    phoneImage.translatesAutoresizingMaskIntoConstraints = NO;
    pwdImage.translatesAutoresizingMaskIntoConstraints   = NO;
    pwd2Image.translatesAutoresizingMaskIntoConstraints  = NO;
    cityImage.translatesAutoresizingMaskIntoConstraints  = NO;
    
    [self.view addSubview:phoneImage];
    [self.view addSubview:pwd2Image];
    [self.view addSubview:pwdImage];
    [self.view addSubview:cityImage];
    
    NSDictionary *imageDictionary = NSDictionaryOfVariableBindings(phoneImage,pwdImage,pwd2Image,cityImage);
    
    
    NSArray *constraintsImageArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-85-[phoneImage]-25-[pwdImage]-25-[pwd2Image]-25-[cityImage]" options:NSLayoutFormatAlignAllLeft metrics:0 views:imageDictionary];
    
    NSArray *constraintsImageArrayH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[phoneImage]" options:0 metrics:0 views:imageDictionary];
    
    
    [self.view addConstraints:constraintsImageArray];
    [self.view addConstraints:constraintsImageArrayH];
    
    
}
#pragma mark - 注册
- (void)registerAciton
{
//    PayVC *payVC = [[PayVC alloc] init];
//    payVC.cityName = self.cityName;
//    payVC.cityCode = self.cityCode;
//    [self.navigationController pushViewController:payVC animated:YES];
    [self managerKeyBoard];
    //判断 用户输入的是否准确
    if (![_pwd2TextField.text isEqualToString:_pwdTextField.text]) {
        _ghostView.message = @"密码不匹配！";
        [_ghostView show];
    }else  if ([AppUtil checkTel:_nameTextField.text]&&(_nameTextField.text.length>0)) {
        // 进行网络请求
        [self requestData];
    }else
    {
        _ghostView.message = @"请按要求输入用户名及密码！";
        [_ghostView show];
    }
}

#pragma mark - 请求网络
- (void)requestData
{
    NSDictionary *data;
    if(YES)
    {
      //  mAlertView(@"提示", @"你的输入的手机号已经注册了，请检查后，再注册");
    }else if(NO)
    {
        //mAlertView(@"提示", @"注册失败，稍后请重试！");
    }
    {
        //存储密码资料
        if ([AppUtil isExistKeychain]) {
            [SSKeychain deletePasswordForService:kService account:@"account"];
        }
        NSMutableData *dat = [AppUtil dictionaryTodata:data];
        [AppUtil writeToKeychain:dat];
    }
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
#pragma mark - 选则城市
- (void)selectCity
{

}
 - (void)cityCode:(NSString *)cityCode andCityName:(NSString *)cityName
{
    _cityCode = cityCode;
    _cityTextField.text = cityName;
    _cityName = cityName;
}
#pragma mark - uitextfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.background = [UIImage imageNamed:@"lost.png"];
    if (textField.tag == kCityTextFieldTag) {
        [self selectCity];
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    //返回BOOL值，指定是否允许文本字段结束编辑，当编辑结束，文本字段会让出first responder
    //要想在用户结束编辑时阻止文本字段消失，可以返回NO
    //这对一些文本字段必须始终保持活跃状态的程序很有用，比如即时消息
    textField.background = [UIImage imageNamed:@"get.png"];
    return YES;
}
#pragma mark - 定位
-(void)startLocation{
    
    //
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

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
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
                _cityTextField.text = [test objectForKey:@"City"];
                [self cityNameToCode];
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

- (void)cityNameToCode
{

}

@end
