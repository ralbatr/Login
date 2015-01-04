//
//  FindPwdVC.m
//  yellowpage
//
//  Created by Ralbatr Yi on 14-12-25.
//  Copyright (c) 2014年 com.yingnet. All rights reserved.
//

#import "FindPwdVC.h"
#import "OLGhostAlertView.h"
#import "AppUtil.h"

@interface FindPwdVC ()<UITextFieldDelegate>
{
    UITextField *_telTF;
    UITextField *_newPwdTF;
    UITextField *_againPwdTF;
    UITextField *_prePwdTF;
    UITextField *_verificationCodeTF;
    UIButton    *_messageBtn;
    UIButton    *_doneBtn;
    OLGhostAlertView *_ghostView;
}
@end

@implementation FindPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"找回密码"];
    self.view.backgroundColor = kbgColor;
    [self initView];
    [self addTap];
    //提醒试图
    _ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:0.5 dismissible:YES];
    _ghostView.position = OLGhostAlertViewPositionCenter;
}

#pragma mark - 描绘界面
- (void)initView
{
    _telTF      = [[UITextField alloc] init];
    _newPwdTF   = [[UITextField alloc] init];
    _againPwdTF = [[UITextField alloc] init];
    _verificationCodeTF = [[UITextField alloc] init];
    _messageBtn = [[UIButton alloc] init];
    _doneBtn    = [[UIButton alloc] init];
    
    _telTF.font      = kfont;
    _newPwdTF.font   = kfont;
    _againPwdTF.font = kfont;
    _verificationCodeTF.font    = kfont;
    _doneBtn.titleLabel.font    = kfont;
    _messageBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    _telTF.keyboardType = UIKeyboardTypeNumberPad;
    [_newPwdTF setSecureTextEntry:YES];
    [_againPwdTF setSecureTextEntry:YES];
    
    _telTF.placeholder              = @"请输入手机号";
    _newPwdTF.placeholder           = @"新密码";
    _againPwdTF.placeholder         = @"原密码确认";
    _verificationCodeTF.placeholder = @"请输入验证码";
    
    _telTF.delegate      = self;
    _newPwdTF.delegate   = self;
    _againPwdTF.delegate = self;
    _verificationCodeTF.delegate = self;
    
    _telTF.background      = [UIImage imageNamed:@"get.png"];
    _newPwdTF.background   = [UIImage imageNamed:@"get.png"];
    _againPwdTF.background = [UIImage imageNamed:@"get.png"];
    _verificationCodeTF.background = [UIImage imageNamed:@"get.png"];
    
    _newPwdTF.returnKeyType   = UIReturnKeyNext;
    _againPwdTF.returnKeyType = UIReturnKeyDone;
    
    [_messageBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_messageBtn setTitle:@"获取短信验证码" forState:UIControlStateNormal];
    [_messageBtn addTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_doneBtn setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    [_doneBtn setBackgroundImage:[UIImage imageNamed:@"nextH.png"] forState:UIControlStateHighlighted];
    [_doneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_doneBtn setTitle:@"完 成" forState:UIControlStateNormal];
    [_doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    
    _telTF.translatesAutoresizingMaskIntoConstraints = NO;
    _newPwdTF.translatesAutoresizingMaskIntoConstraints   = NO;
    _againPwdTF.translatesAutoresizingMaskIntoConstraints = NO;
    _doneBtn.translatesAutoresizingMaskIntoConstraints    = NO;
    _verificationCodeTF.translatesAutoresizingMaskIntoConstraints = NO;
    _messageBtn.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:_telTF];
    [self.view addSubview:_newPwdTF];
    [self.view addSubview:_againPwdTF];
    [self.view addSubview:_verificationCodeTF];
    [self.view addSubview:_doneBtn];
    [self.view addSubview:_messageBtn];
    
    NSDictionary *viewsDic = NSDictionaryOfVariableBindings(_telTF,_newPwdTF,_againPwdTF,_verificationCodeTF,_messageBtn,_doneBtn);
    NSArray *constrainV    = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-80-[_telTF]-20-[_newPwdTF]-20-[_againPwdTF]-20-[_verificationCodeTF]-25-[_doneBtn]" options:NSLayoutFormatAlignAllLeft metrics:0 views:viewsDic];
    NSArray *constrainV3   = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-80-[_telTF]-20-[_newPwdTF]-20-[_againPwdTF]-18-[_messageBtn]-27-[_doneBtn]" options:NSLayoutFormatAlignAllRight metrics:0 views:viewsDic];
    NSArray *constrainH    = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[_newPwdTF(>=0@200)]-30-|" options:0 metrics:0 views:viewsDic];
    
    [self.view addConstraints:constrainV];
    [self.view addConstraints:constrainV3];
    [self.view addConstraints:constrainH];
}
- (void)messageAction
{
    //判断 用户输入的是否准确
    if (_telTF.text.length == 0) {
        _ghostView.message = @"请输入手机号！";
        [_ghostView show];
    }else if ([AppUtil checkTel:_telTF.text]) {
        // 进行网络请求
        [self sendMessage];
    }else
    {
        _ghostView.message = @"你输入的手机号码不正确！";
        [_ghostView show];
    }
    
}
- (void)sendMessage
{
    if (YES) {
        _ghostView.message = @"已发送验证码，请注意查收";
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        _ghostView.message = @"发送验证码失败，请稍后再试";
    }
    [_ghostView show];
}
- (void)doneAction
{
    [self.view endEditing:YES];
    //判断 两个密码是否一致
    if (_verificationCodeTF.text.length == 0 || _newPwdTF.text.length == 0 || _againPwdTF.text.length == 0) {
        _ghostView.message = @"请按要求输入！";
        [_ghostView show];
        return;
    }else if (![_newPwdTF.text isEqualToString:_againPwdTF.text]) {
        _ghostView.message = @"新密码不一致，请重新输入";
        [_ghostView show];
        return;
    }else
    {
        [self request];
    }
}
#pragma mark 请求网络
- (void)request
{
    if (YES) {
        _ghostView.message = @"修改密码成功";
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        _ghostView.message = @"修改密码失败";
    }
    [_ghostView show];
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

@end

