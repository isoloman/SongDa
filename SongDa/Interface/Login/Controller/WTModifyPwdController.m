//
//  WTModifyPwdController.m
//  SongDa
//
//  Created by Fancy on 2018/3/29.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTModifyPwdController.h"

#define kLeftMargin     10
#define kSection0H      38
#define kSectionH       44

@interface WTModifyPwdController ()
/** 验证码 */
@property (strong, nonatomic) UIButton *verifyBtn;
/** 密码可见 */
@property (strong, nonatomic) UIButton *showPwdBtn;
/** 验证码输入框 */
@property (strong, nonatomic) UITextField *verifyTextField;
/** 密码输入框 */
@property (strong, nonatomic) UITextField *pwdTextField;
@end

@implementation WTModifyPwdController

- (UIButton *)verifyBtn
{
    if (_verifyBtn == nil) {
        _verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _verifyBtn.backgroundColor = [UIColor colorWithHexString:@"ff842a"];
        [_verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _verifyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _verifyBtn.size = CGSizeMake(80, 29);
        _verifyBtn.layer.cornerRadius = 4;
        _verifyBtn.layer.masksToBounds = YES;
        [_verifyBtn addTarget:self action:@selector(verifyClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _verifyBtn;
}
- (UIButton *)showPwdBtn
{
    if (_showPwdBtn == nil) {
        _showPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showPwdBtn setImage:HYXImage(@"login_hidePwd") forState:UIControlStateNormal];
        [_showPwdBtn setImage:HYXImage(@"login_showPwd") forState:UIControlStateSelected];
        [_showPwdBtn setAdjustsImageWhenHighlighted:NO];
        [_showPwdBtn sizeToFit];
        _showPwdBtn.size = CGSizeMake(_showPwdBtn.width+2*10, kSectionH);
        [_showPwdBtn addTarget:self action:@selector(changePwdStatus) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showPwdBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HYXColor(245, 246, 247);
    self.navigationItem.title = @"修改密码";
    
    [self setupUI];
    [self verifyClick];
}

- (void)setupUI {
    NSString *headNum = [[WTAccountManager sharedManager].phoneNum substringToIndex:3];
    NSString *footNum = [[WTAccountManager sharedManager].phoneNum substringFromIndex:7];
    NSString *phoneNum = [[headNum stringByAppendingString:@"****"] stringByAppendingString:footNum];
    
    NSString *metionStr = [NSString stringWithFormat:@"已向您的手机号：%@发送短信",phoneNum];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:metionStr];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"e4393c"] range:NSMakeRange(metionStr.length-phoneNum.length-4, phoneNum.length+4)];
    
    UILabel *metionLabel = [[UILabel alloc] init];
    metionLabel.textColor = [UIColor colorWithHexString:@"666666"];
    metionLabel.font = [UIFont systemFontOfSize:14];
    metionLabel.attributedText = attrString;
    [metionLabel sizeToFit];
    metionLabel.x = kLeftMargin;
    metionLabel.centerY = kSection0H*0.5;
    [self.view addSubview:metionLabel];
    
    for (NSInteger i = 0; i < 2; i++) {
        UIView *itemView = [self setupItemViewWithType:i];
        itemView.y = kSection0H+i*kSectionH;
        [self.view addSubview:itemView];
        
        if (i == 1) {
            UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            commitBtn.backgroundColor = [UIColor colorWithHexString:@"11a07c"];
            [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
            commitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
            commitBtn.size = CGSizeMake(HYXScreenW-2*10, 45);
            commitBtn.centerX = self.view.width*0.5;
            commitBtn.y = CGRectGetMaxY(itemView.frame)+49;
            commitBtn.layer.cornerRadius = 4;
            commitBtn.layer.masksToBounds = YES;
            [commitBtn addTarget:self action:@selector(commitClick) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:commitBtn];
        }
    }
    
}

- (UIView *)setupItemViewWithType:(NSUInteger)type {
    UIView *containView = [[UIView alloc] init];
    containView.backgroundColor = [UIColor whiteColor];
    containView.size = CGSizeMake(HYXScreenW, kSectionH);
    
    CGFloat leftMargin = 10;
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"验证码:";
    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [titleLabel sizeToFit];
    titleLabel.x = leftMargin;
    titleLabel.centerY = containView.height*0.5;
    [containView addSubview:titleLabel];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.x = CGRectGetMaxX(titleLabel.frame)+leftMargin;
    textField.height = kSectionH;
    textField.textColor = [UIColor colorWithHexString:@"333333"];
    textField.font = [UIFont systemFontOfSize:15];
    [containView addSubview:textField];
    
    UIView *separateLine = [[UIView alloc] init];
    separateLine.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
    separateLine.size = CGSizeMake(HYXScreenW, 0.5);
    separateLine.y = containView.height-separateLine.height;
    [containView addSubview:separateLine];
    
    switch (type) {
        case 0:
        {
            self.verifyBtn.centerY = containView.height*0.5;
            self.verifyBtn.right = containView.width-leftMargin;
            [containView addSubview:self.verifyBtn];
            
            titleLabel.text = @"验证码:";
            textField.placeholder = @"请输入验证码";
            textField.width = self.verifyBtn.x-textField.x-leftMargin;
            textField.keyboardType = UIKeyboardTypePhonePad;
            self.verifyTextField = textField;
        }
            break;
            
        case 1:
        {
            self.showPwdBtn.right = containView.width;
            self.showPwdBtn.centerY = containView.height*0.5;
            [containView addSubview:self.showPwdBtn];
            
            titleLabel.text = @"新密码:";
            textField.placeholder = @"请输入新密码";
            textField.width = self.showPwdBtn.x-textField.x;
            textField.secureTextEntry = YES;
            self.pwdTextField = textField;
        }
            break;
            
        default:
            break;
    }
    
    return containView;
}

- (void)verifyClick {
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
            
        } else{
            
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

- (void)changePwdStatus {
    self.showPwdBtn.selected = !self.showPwdBtn.selected;
    self.pwdTextField.secureTextEntry = !self.showPwdBtn.selected;
}

- (void)commitClick {
    
}

@end
