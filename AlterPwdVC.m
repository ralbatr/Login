//
//  AlterPwdVC.m
//  yellowpage
//
//  Created by Ralbatr Yi on 14-12-24.
//  Copyright (c) 2014年 com.yingnet. All rights reserved.
//

#import "AlterPwdVC.h"
#import "OLGhostAlertView.h"

@interface AlterPwdVC ()<UITextFieldDelegate>
{
    UITextField *_oldPwdTF;
    UITextField *_newPwdTF;
    UITextField *_againPwdTF;
    UITextField *_prePwdTF;
    UIButton    *_doneBtn;
    OLGhostAlertView *_ghostView;
}
@end

@implementation AlterPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"找回密码"];
    [self initView];
    [self addTap];
    //提醒试图
    _ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:0.5 dismissible:YES];
    _ghostView.position = OLGhostAlertViewPositionCenter;
}

#pragma mark - 描绘界面
- (void)initView
{
    _oldPwdTF   = [[UITextField alloc] init];
    _newPwdTF   = [[UITextField alloc] init];
    _againPwdTF = [[UITextField alloc] init];
    _doneBtn    = [[UIButton alloc] init];
    
    [_oldPwdTF setSecureTextEntry:YES];
    [_newPwdTF setSecureTextEntry:YES];
    [_againPwdTF setSecureTextEntry:YES];
    
    
    _oldPwdTF.placeholder   = @"原密码";
    _newPwdTF.placeholder   = @"新密码";
    _againPwdTF.placeholder = @"原密码确认";
    
    _oldPwdTF.font   = kfont;
    _newPwdTF.font   = kfont;
    _againPwdTF.font = kfont;
    
    _oldPwdTF.delegate   = self;
    _newPwdTF.delegate   = self;
    _againPwdTF.delegate = self;
    
    _oldPwdTF.background   = [UIImage imageNamed:@"get.png"];
    _newPwdTF.background   = [UIImage imageNamed:@"get.png"];
    _againPwdTF.background = [UIImage imageNamed:@"get.png"];
    
    _oldPwdTF.returnKeyType   = UIReturnKeyNext;
    _newPwdTF.returnKeyType   = UIReturnKeyNext;
    _againPwdTF.returnKeyType = UIReturnKeyDone;
    
    [_doneBtn setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    [_doneBtn setBackgroundImage:[UIImage imageNamed:@"nextH.png"] forState:UIControlStateHighlighted];
    [_doneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_doneBtn setTitle:@"完 成" forState:UIControlStateNormal];
    _doneBtn.titleLabel.font = kfont;
    [_doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    
    _oldPwdTF.translatesAutoresizingMaskIntoConstraints   = NO;
    _newPwdTF.translatesAutoresizingMaskIntoConstraints   = NO;
    _againPwdTF.translatesAutoresizingMaskIntoConstraints = NO;
    _doneBtn.translatesAutoresizingMaskIntoConstraints    = NO;
    
    [self.view addSubview:_oldPwdTF];
    [self.view addSubview:_newPwdTF];
    [self.view addSubview:_againPwdTF];
    [self.view addSubview:_doneBtn];
    
    NSDictionary *viewsDic = NSDictionaryOfVariableBindings(_oldPwdTF,_newPwdTF,_againPwdTF,_doneBtn);
    NSArray *constrainV    = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-80-[_oldPwdTF]-20-[_newPwdTF]-20-[_againPwdTF]-25-[_doneBtn]" options:NSLayoutFormatAlignAllLeft metrics:0 views:viewsDic];
    NSArray *constrainV3   = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-80-[_oldPwdTF]-20-[_newPwdTF]-20-[_againPwdTF]-25-[_doneBtn]" options:NSLayoutFormatAlignAllRight metrics:0 views:viewsDic];
    NSArray *constrainH    = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[_oldPwdTF(>=0@200)]-40-|" options:0 metrics:0 views:viewsDic];
    
    [self.view addConstraints:constrainV];
    [self.view addConstraints:constrainV3];
    [self.view addConstraints:constrainH];
}

- (void)doneAction
{
    [self.view endEditing:YES];
    //判断 两个密码是否一致
    if (_oldPwdTF.text.length == 0 || _newPwdTF.text.length == 0 || _againPwdTF.text.length == 0) {
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

- (void)request
{

    if (YES) {
        _ghostView.message = @"修改成功";
       [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        _ghostView.message = @"修改失败";
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
