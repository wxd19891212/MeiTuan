//
//  JGHomeViewController.m
//  JGMeiTuan
//
//  Created by stkcctv on 16/8/30.
//  Copyright © 2016年 stkcctv. All rights reserved.
//

#import "JGHomeViewController.h"
#import "JGHotQueueModel.h"

#import "JGHomeMenuCell.h"

#import "JGRushDataModel.h"
#import "JGRushDealsModel.h"
#import "JGRushCell.h"
#import "JGDiscountModel.h"
#import "JGDiscountCell.h"
#import "JGRecommendModel.h"
#import "JGRecommendCell.h"

@interface JGHomeViewController () <UITableViewDelegate, UITableViewDataSource, JGRushCellDelegate, JGDiscountCellDelegate> {
    

    NSMutableArray *_menuArray;//
    NSMutableArray *_rushArray;//抢购数据
    JGHotQueueModel *_hotQueueData;
    NSMutableArray *_recommendArray;
    NSMutableArray *_discountArray;
    
}
@property(nonatomic, strong) UITableView *tableView;
@end

static NSString * const JGHomeMenuCellID = @"JGHomeMenuCellID";
static NSString * const JGRushCellID = @"JGRushCellID";

@implementation JGHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;

    [self initData];
    
    [self setNav];

    [self initTableView];
}

- (void)initTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHight-49-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self setUpTableView];
}

- (void)setUpTableView {
    //设置下拉刷新回调
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.tableView.mj_header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
}


- (void)setNav {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 64)];
    backView.backgroundColor = JGNavBarColor;
    [self.view addSubview:backView];
    //城市
    UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cityBtn.frame = CGRectMake(10, 30, 40, 25);
    cityBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cityBtn setTitle:@"杭州" forState:UIControlStateNormal];
    [backView addSubview:cityBtn];
    //
    UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cityBtn.frame), 38, 13, 10)];
    [arrowImage setImage:[UIImage imageNamed:@"icon_homepage_downArrow"]];
    [backView addSubview:arrowImage];
    //地图
    UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mapBtn.frame = CGRectMake(kDeviceWidth-42, 30, 42, 30);
    [mapBtn setImage:[UIImage imageNamed:@"icon_homepage_map_old"] forState:UIControlStateNormal];
    [mapBtn addTarget:self action:@selector(OnMapBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:mapBtn];
    
    //搜索框
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(arrowImage.frame)+10, 30, kDeviceWidth - 120, 25)];
    //    searchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_home_searchBar"]];
    searchView.backgroundColor = JGRGB(7, 170, 153);
    searchView.layer.masksToBounds = YES;
    searchView.layer.cornerRadius = 12;
    [backView addSubview:searchView];
    
    //
    UIImageView *searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 3, 15, 15)];
    [searchImage setImage:[UIImage imageNamed:@"icon_homepage_search"]];
    [searchView addSubview:searchImage];
    
    UILabel *placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 150, 25)];
    placeHolderLabel.font = [UIFont boldSystemFontOfSize:13];
    //    placeHolderLabel.text = @"请输入商家、品类、商圈";
    placeHolderLabel.text = @"江浙沪总专享版";
    placeHolderLabel.textColor = [UIColor whiteColor];
    [searchView addSubview:placeHolderLabel];
    
}

- (void)OnMapBtnTap:(UIButton *)btn {

    
}

- (void)refreshData {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getRushBuyData];
        [self getDiscountData];
        [self getRecommendData]; //底部
    });
    
    
    
}

#pragma mark - 名店抢购 -
- (void)getRushBuyData {

    
    __weak __typeof(self) weakself = self;
    
    [[NetworkSingleton sharedManager] getRushBuyResult:nil url:RushBuy_URL successBlock:^(id responseBody) {
        
//        JGLog(@"%@",responseBody);
        
        if (weakself) {
//            NSLog(@"抢购请求成功");
            NSDictionary *dataDic = [responseBody objectForKey:@"data"];

            JGRushDataModel *rushDataM = [JGRushDataModel mj_objectWithKeyValues:dataDic];
            [_rushArray removeAllObjects];
            
            for (int i = 0; i < rushDataM.deals.count; i++) {
                JGRushDealsModel *deals = [JGRushDealsModel mj_objectWithKeyValues:rushDataM.deals[i]];
                [_rushArray addObject:deals];
            }
            [weakself.tableView reloadData];
//            JGLog(@"%@",_rushArray);
        }
        
        
    } failureBlock:^(NSString *error) {
        if (weakself) {
//            NSLog(@"%@",error);
            [weakself.tableView.mj_header endRefreshing];
        }
        
    }];
    
    
}



- (void)getRecommendData {
   
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *urlStr = [NSString stringWithFormat:Recommend_URL,delegate.latitude,delegate.longitude];
    //    NSLog(@"推荐数据url：%@",urlStr);
//    NSLog(@"最新的经纬度：%f,%f",delegate.latitude,delegate.longitude);

    __weak __typeof(self) weakself = self;
    [[NetworkSingleton sharedManager] getRecommendResult:nil url:urlStr successBlock:^(id responseBody){
//        NSLog(@"推荐：成功");
        NSMutableArray *dataDic = [responseBody objectForKey:@"data"];
        [_recommendArray removeAllObjects];
        for (int i = 0; i < dataDic.count; i++) {
            JGRecommendModel *recommend = [JGRecommendModel mj_objectWithKeyValues:dataDic[i]];
            [_recommendArray addObject:recommend];
        }
        
        [weakself.tableView reloadData];
        
    } failureBlock:^(NSString *error){
//        NSLog(@"推荐：%@",error);
        [weakself.tableView.mj_header endRefreshing];
    }];

    
    
    
}

- (void)getDiscountData {
    
    __weak __typeof(self) weakself = self;
    [[NetworkSingleton sharedManager] getDiscountResult:nil url:Discount_URL successBlock:^(id responseBody){
//        NSLog(@"获取折扣数据成功");
        
        NSMutableArray *dataDic = [responseBody objectForKey:@"data"];
        [_discountArray removeAllObjects];
        for (int i = 0; i < dataDic.count; i++) {
            JGDiscountModel *discount = [JGDiscountModel mj_objectWithKeyValues:dataDic[i]];
            [_discountArray addObject:discount];
        }
        
        [weakself.tableView reloadData];
        
        [weakself.tableView.mj_header endRefreshing];
        
    } failureBlock:^(NSString *error){
//        NSLog(@"获取折扣数据失败：%@",error);
        [weakself.tableView.mj_header endRefreshing];
    }];

    
    
    
    
    
}

//顶部视图
- (void)initData {
    
    _rushArray = [[NSMutableArray alloc] init];
    _hotQueueData = [[JGHotQueueModel alloc] init];
    _recommendArray = [[NSMutableArray alloc] init];
    _discountArray = [[NSMutableArray alloc] init];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"menuData" ofType:@"plist"];
    _menuArray = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
}


#pragma mark - UITableViewDataSource -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 3 ? _recommendArray.count + 1 : 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return [JGHomeMenuCell cellWithTableView:tableView menuArray:_menuArray];
    }else if (indexPath.section == 1) {
        
        JGRushCell *cell = [JGRushCell cellWithTableView:tableView];
        if (_rushArray.count !=0) {
            [cell setRushData:_rushArray];
        }
        cell.delegate = self;
        return cell;
        
    }else if (indexPath.section == 2) {
        
        JGDiscountCell *cell = [JGDiscountCell cellWithTableView:tableView];
        
        cell.delegate = self;
        if (_discountArray.count != 0) {
            [cell setDiscountArray:_discountArray];
        }
        
        return cell;
    }else{
        
        if(indexPath.row == 0){
            static NSString *cellIndentifier = @"morecellID";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            }
            
            cell.textLabel.text = @"猜你喜欢";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        
        }else {
            
            JGRecommendCell *cell = [JGRecommendCell cellWithTableView:tableView];
            
            if(_recommendArray.count!=0){
                JGRecommendModel *recommend = _recommendArray[indexPath.row - 1];
//                JGLog(@"=======  %@",recommend.mname);
                
                [cell setRecommendData:recommend];
            }
            
            return cell;
        }
        
        
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 10)];
    headerView.backgroundColor = JGRGB(239, 239, 244);
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0)];
    footerView.backgroundColor = JGRGB(239, 239, 224);
    return footerView;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 180;
    }else if(indexPath.section == 1){
        if (_rushArray.count!=0) {
            return 120;
        }else{
            return 0.0;
        }
    }else if (indexPath.section == 2){
        if (_discountArray.count == 0) {
            return 0.0;
        }else{
            return 160.0;
        }
    }else{
        
        if (indexPath.row == 0) {
            return 35.0;
        }else{
            return 100.0;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 1 : 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

#pragma mark - RushCell代理方法 -
- (void)didSelectRushIndex:(NSInteger)index {
    
    JGLog(@"%ld",index);
    
}

#pragma mark - DisCountCell代理方法 -
- (void)didSelectUrl:(NSString *)urlStr withType:(NSNumber *)type withId:(NSNumber *)ID withTitle:(NSString *)title {
    
    JGLog(@"%@",title);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
