//
//  WTLoginController.m
//  SongDa
//
//  Created by Fancy on 2018/3/28.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTLoginController.h"
#import "WTLoginViewModel.h"
#import "WTForgetPwdController.h"
#import "WTTabBarController.h"

#warning hyx_翔安需要验证码
static BOOL isVerify = NO;//是否需要验证码

@interface WTLoginController ()
@property (strong, nonatomic) UITextField *phoneTextField;
@property (strong, nonatomic) UITextField *pwdTextField;
/** 验证码 */
@property (strong, nonatomic) UIButton *verifyBtn;
@property (strong, nonatomic) WTLoginViewModel *viewModel;
@end

@implementation WTLoginController

- (WTLoginViewModel *)viewModel
{
    if (_viewModel == nil) {
        _viewModel = [[WTLoginViewModel alloc] init];
    }
    return _viewModel;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WTBlueColor;
    
    [self setupLoginView];
    [self setupGesture];
    [self configTimer];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)setupLoginView {
    // 整体容器
    UIView *containView = [[UIView alloc] initWithFrame:self.view.bounds];
    containView.backgroundColor = WTBlueColor;
    [self.view addSubview:containView];
    
    // 背景
    UIImageView *backImgView = [[UIImageView alloc] initWithImage:HYXImage(@"login_back")];
    backImgView.frame = containView.bounds;
    [containView addSubview:backImgView];
    
    // logo
    UIImageView *logoImgView = [[UIImageView alloc] initWithImage:HYXImage(@"chengdulvzheng-logo")];
    [logoImgView sizeToFit];
    logoImgView.centerX = containView.width*0.5;
    logoImgView.y = IPhoneX_Nav_Height+28;
    [containView addSubview:logoImgView];
#if SongDa
    
#elif YuBo
    logoImgView.image = HYXImage(@"YuBoLaunchLogo");
    [logoImgView sizeToFit];
#elif MianYang
    logoImgView.image = HYXImage(@"MianYangLaunchLogo");
    [logoImgView sizeToFit];
#elif QiQiHaEr
    logoImgView.image = HYXImage(@"QiQiHaErLaunchLogo");
    [logoImgView sizeToFit];
#endif
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
#if SongDa
    titleLabel.text = @"智慧律政司法辅助平台";//@"诉讼与公正创新中心"
#elif YuBo
    titleLabel.text = @"渝博公证司法辅助平台";
#elif MianYang
    titleLabel.text = @"法湛绵州司法辅助平台";
#elif QiQiHaEr
    titleLabel.text = @"齐齐哈尔鹤城公证处";
#endif
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    [titleLabel sizeToFit];
    titleLabel.centerX = logoImgView.centerX;
    titleLabel.y = CGRectGetMaxY(logoImgView.frame)+16;
    [containView addSubview:titleLabel];
    
    // 副标题
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.text = @"司法辅助系统";
    subTitleLabel.textColor = [UIColor whiteColor];
    subTitleLabel.font = [UIFont systemFontOfSize:13];
    [subTitleLabel sizeToFit];
    subTitleLabel.centerX = logoImgView.centerX;
    subTitleLabel.y = CGRectGetMaxY(titleLabel.frame)+10;
//    [containView addSubview:subTitleLabel];
    
    // 输入框整体
    CGFloat leftMargin = 10;
    CGFloat itemHeight = 44;
    UIView *inputView = [[UIView alloc] init];
    inputView.backgroundColor = [UIColor whiteColor];
    inputView.size = CGSizeMake(HYXScreenW-2*leftMargin, itemHeight*2);
    inputView.centerX = containView.width*0.5;
    inputView.y = CGRectGetMaxY(subTitleLabel.frame)+35;
    inputView.layer.cornerRadius = 4;
    inputView.layer.masksToBounds = YES;
    [containView addSubview:inputView];
    
    // 用户名输入框
    UIImageView *nameImgView = [[UIImageView alloc] initWithImage:HYXImage(@"login_user")];
    [nameImgView sizeToFit];
    nameImgView.centerX = 40*0.5;
    nameImgView.centerY = itemHeight*0.5;
    [inputView addSubview:nameImgView];

    UITextField *phoneTextField = [[UITextField alloc] init];
    phoneTextField.frame = CGRectMake(40, 0, inputView.width-40-leftMargin, itemHeight);
    phoneTextField.placeholder = @"请输入手机号码";
    phoneTextField.textColor = [UIColor colorWithHexString:@"333333"];
    phoneTextField.font = [UIFont systemFontOfSize:15];
    phoneTextField.x = 40;
    phoneTextField.size = CGSizeMake(inputView.width-40-leftMargin, itemHeight);
    phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [phoneTextField becomeFirstResponder];
    [inputView addSubview:phoneTextField];
    self.phoneTextField = phoneTextField;
    
    // 分割线
    UIView *separateLine = [[UIView alloc] init];
    separateLine.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    separateLine.size = CGSizeMake(inputView.width, 0.5);
    separateLine.y = itemHeight-separateLine.height;
    [inputView addSubview:separateLine];
    
//#warning hyx_翔安需要验证码
    if (isVerify) {
        // 验证码
        _verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _verifyBtn.backgroundColor = [UIColor colorWithHexString:@"ff842a"];
        [_verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _verifyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _verifyBtn.size = CGSizeMake(80, 29);
        _verifyBtn.right = inputView.width-10;
        _verifyBtn.centerY = itemHeight+itemHeight*0.5;
        _verifyBtn.layer.cornerRadius = 4;
        _verifyBtn.layer.masksToBounds = YES;
        [_verifyBtn addTarget:self action:@selector(verifyClick) forControlEvents:UIControlEventTouchUpInside];
        [inputView addSubview:_verifyBtn];
    }
    else{
        // 密码输入框
        UIImageView *pwdImgView = [[UIImageView alloc] initWithImage:HYXImage(@"login_password")];
        [pwdImgView sizeToFit];
        pwdImgView.centerX = nameImgView.centerX;
        pwdImgView.centerY = itemHeight+itemHeight*0.5;
        [inputView addSubview:pwdImgView];
    }
    
    CGFloat width = inputView.width-40-leftMargin;
    UITextField *pwdTextFiled = [[UITextField alloc] init];
    pwdTextFiled.frame = CGRectMake(40, 0, width, itemHeight);
//#warning hyx_翔安需要验证码
    pwdTextFiled.placeholder = isVerify? @"请输入验证码":@"请输入密码";
    pwdTextFiled.textColor = phoneTextField.textColor;
    pwdTextFiled.font = phoneTextField.font;
    pwdTextFiled.x = phoneTextField.x;
    pwdTextFiled.y = CGRectGetMaxY(phoneTextField.frame);
    if (_verifyBtn) {
        width = phoneTextField.width-2*10-_verifyBtn.width;
        pwdTextFiled.secureTextEntry = NO;
        pwdTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    } else {
        width = phoneTextField.width;
        pwdTextFiled.secureTextEntry = YES;
    }
    pwdTextFiled.width = width;
    
    pwdTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    [inputView addSubview:pwdTextFiled];
    self.pwdTextField = pwdTextFiled;

    if (!isVerify) {
        // 忘记密码
        UILabel *forgetPwdLabel = [[UILabel alloc] init];
        forgetPwdLabel.text = @"忘记密码?";
        forgetPwdLabel.textColor = [UIColor colorWithHexString:@"d3875d"];
        forgetPwdLabel.font = [UIFont systemFontOfSize:15];
        [forgetPwdLabel sizeToFit];
        forgetPwdLabel.right = inputView.right;
        forgetPwdLabel.y = CGRectGetMaxY(inputView.frame)+10;
        forgetPwdLabel.userInteractionEnabled = YES;
        [forgetPwdLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgetPwd)]];
        [containView addSubview:forgetPwdLabel];

    }

    
    // 登录
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.backgroundColor = [UIColor whiteColor];
    loginBtn.size = CGSizeMake(inputView.width, 50);
    loginBtn.centerX = inputView.centerX;
    loginBtn.y = CGRectGetMaxY(inputView.frame)+50;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:WTBlueColor forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 4;
    loginBtn.layer.masksToBounds = YES;
    [loginBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [containView addSubview:loginBtn];
    
#warning hyx_changeCopyrightName
//    UILabel *copyrightLabel = [[UILabel alloc] init];
//    copyrightLabel.text = @"版权所有©厦门市翔安区人民法院";
////    copyrightLabel.text = @"版权所有©昆明市官渡区人民法院";
//    copyrightLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
//    copyrightLabel.font = [UIFont systemFontOfSize:10];
//    [copyrightLabel sizeToFit];
//    copyrightLabel.bottom = containView.height-20-IPhoneX_Bottom_Safe_Height;
//    copyrightLabel.centerX = containView.width*0.5;
//    [containView addSubview:copyrightLabel];
    

#warning hyx_testAccount
//    phoneTextField.text = @"15100000009";
//    pwdTextFiled.text = @"123456";
    
}

- (void)setupGesture {
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(endTextEdit)];
    [self.view addGestureRecognizer:panGes];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endTextEdit)];
    [self.view addGestureRecognizer:tapGes];
}

- (void)configTimer {
    UIApplication *app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid) {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid) {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
}

- (void)endTextEdit {
    [self.view endEditing:YES];
}

- (void)verifyClick {
    WTWeakSelf;
    if ([self.phoneTextField.text isPureNumber] &&
        self.phoneTextField.text.length == 11) {
        NSDictionary *paras = @{@"mobile" : self.phoneTextField.text, @"type" : kVerifyTypeLogin};
        [[[WTLoginViewModel alloc] init] getVerifyCodeWithParas:paras success:^(id obj) {
            HYXLog(@"验证码发送成功！");
            [weakSelf resumeTimer];
            [SVProgressHUD showSuccessWithStatus:@"验证码发送成功！"];
        } failure:^(NSError *error, NSString *message) {
            HYXLog(@"验证码发送失败：error  %@",error);
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    } else {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
    }
}
- (void)resumeTimer {
    // 开启倒计时效果
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.verifyBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                self.verifyBtn.userInteractionEnabled = YES;
            });
            
        } else {
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.verifyBtn setTitle:[NSString stringWithFormat:@"%.2ds后重发", seconds] forState:UIControlStateNormal];
                self.verifyBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}


- (void)forgetPwd {
    WTForgetPwdController *forgetVc = [[WTForgetPwdController alloc] init];
    forgetVc.phoneNum = self.phoneTextField.text;
    [self.navigationController pushViewController:forgetVc animated:YES];
}

- (void)loginClick:(UIButton *)button {
    if (![self.phoneTextField.text isPureNumber] || self.phoneTextField.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    if ([self.pwdTextField.text isEmpty]) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }

    [SVProgressHUD show];

//#warning hyx_翔安才需要验证码
    NSDictionary *paras;
    if (isVerify) {//验证码
        paras = @{@"mobile" : self.phoneTextField.text, @"verifyCode" : self.pwdTextField.text};
    }
    else{//密码
        paras = @{@"mobile" : self.phoneTextField.text, @"pwd" : [self.pwdTextField.text base64EncodedString]};
    }

    [SVProgressHUD show];


    [self.viewModel loginWithPhoneNumParas:paras success:^(id obj) {
        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            WTTabBarController *tabBarVc = [[WTTabBarController alloc] init];
            [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVc;
            [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
            [[WTLocationManager shareInstance] reportCurrentAddress];
        });
    } failure:^(NSError *error, NSString *message) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}


@end
