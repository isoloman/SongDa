//
//  WTMyCaseSearchController.m
//  SongDa
//
//  Created by Fancy on 2018/4/16.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTMyCaseSearchController.h"
#import "WTMyCaseSearchModel.h"
#import <AMapSearchKit/AMapSearchKit.h>

@interface WTMyCaseSearchController () <UITableViewDelegate,UITableViewDataSource,AMapSearchDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *searchView;
/** 搜索输入框 */
@property (strong, nonatomic) UITextField *searchTextField;
@property (strong, nonatomic) UIButton *searchBtn;
/** 周边搜索 */
@property (strong, nonatomic) AMapSearchAPI *mapSearch;
/** 搜索结果数组 */
@property (strong, nonatomic) NSMutableArray *searchArrM;
@end

@implementation WTMyCaseSearchController

static NSString * const ID = @"searchCell";

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (AMapSearchAPI *)mapSearch {
    if (_mapSearch == nil) {
        _mapSearch = [[AMapSearchAPI alloc] init];
        _mapSearch.delegate = self;
    }
    return _mapSearch;
}

- (UIButton *)searchBtn
{
    if (_searchBtn == nil) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [_searchBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateDisabled];
        _searchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_searchBtn sizeToFit];
        _searchBtn.width += 20;
        _searchBtn.height = 44;
        _searchBtn.enabled = NO;
        [_searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *separateLine = [[UIView alloc] init];
        separateLine.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
        separateLine.size = CGSizeMake(0.5, 16);
        separateLine.centerY = _searchBtn.height*0.5;
        [_searchBtn addSubview:separateLine];
    }
    return _searchBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WTGlobalBG;
    [self setupSearchView];
    [self setupTableView];
}

- (void)setupSearchView {
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(10, IPhoneX_Status_Height+5, HYXScreenW-2*10, 44)];
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.layer.cornerRadius = 2;
    searchView.layer.masksToBounds = YES;
    searchView.layer.borderColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
    searchView.layer.borderWidth = 0.5;
    self.searchView = searchView;
    [self.view addSubview:searchView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setImage:HYXImage(@"nav_back_black") forState:UIControlStateNormal];
    cancelBtn.size = CGSizeMake(50, searchView.height);
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:cancelBtn];
    
    self.searchBtn.right = searchView.width;
    [searchView addSubview:self.searchBtn];
    
    _searchTextField = [[UITextField alloc] init];
    _searchTextField.backgroundColor = [UIColor clearColor];
    _searchTextField.x = CGRectGetMaxX(cancelBtn.frame);
    _searchTextField.width = self.searchBtn.x-_searchTextField.x-10;
    _searchTextField.height = searchView.height;
    _searchTextField.font = [UIFont systemFontOfSize:15];
    _searchTextField.textColor = [UIColor colorWithHexString:@"333333"];
    [_searchTextField becomeFirstResponder];
    _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_searchTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [searchView addSubview:_searchTextField];
}

- (void)setupTableView {
    CGFloat y = CGRectGetMaxY(self.searchView.frame)+10;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, y, HYXScreenW-2*10, HYXScreenH-y)];
    tableView.backgroundColor = WTGlobalBG;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    adjustsScrollViewInsets(tableView);
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.tableFooterView = [UIView new];
}

- (void)searchClick {
    // 取消所有未回调的请求
    [self.mapSearch cancelAllRequests];
    
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = self.searchTextField.text;
#warning hyx_cityName
    request.city     = [WTLocationManager shareInstance].currentCity;
//    request.city     = @"昆明";
    request.location = [AMapGeoPoint locationWithLatitude:[WTLocationManager shareInstance].latitude longitude:[WTLocationManager shareInstance].longitude];
    //        request.types = @"";
    request.requireExtension = YES;
    request.cityLimit = YES;
    request.requireSubPOIs = YES;
    [self.mapSearch AMapPOIKeywordsSearch:request];
}
- (void)cancelClick {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textFieldChange:(UITextField *)textField {
    if (![textField.text isEmpty]) {
        self.searchBtn.enabled = YES;
        [self searchClick];
    } else {
        self.searchBtn.enabled = NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchArrM.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTMyCaseSearchModel *model = self.searchArrM[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.text = model.name;
    NSString *distance = [NSString stringKiloMeterFormatByNum:model.distance];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ | %@",distance,model.address];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [self cancelClick];
    
    WTWeakSelf;
    if (weakSelf.searchBlock) {
        WTMyCaseSearchModel *searchModel = weakSelf.searchArrM[indexPath.row];
        weakSelf.searchBlock(searchModel);
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchTextField resignFirstResponder];
}

#pragma mark - <AMapSearchDelegate>
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    self.searchArrM = [NSMutableArray array];
    for (AMapPOI *poi in response.pois) {
        WTMyCaseSearchModel *searchModel = [[WTMyCaseSearchModel alloc] init];
        searchModel.name = poi.name;
        searchModel.address = poi.address;
        searchModel.lat = poi.location.latitude;
        searchModel.lng = poi.location.longitude;
        [self.searchArrM addObject:searchModel];
    }
    [self.tableView reloadData];
}

@end
