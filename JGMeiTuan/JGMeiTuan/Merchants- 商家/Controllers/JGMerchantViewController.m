//
//  JGMerchantViewController.m
//  JGMeiTuan
//
//  Created by stkcctv on 16/8/30.
//  Copyright © 2016年 stkcctv. All rights reserved.
//

#import "JGMerchantViewController.h"
#import "JGMerchantFilterView.h"
#import "JGMerchantModel.h"

#import "JGMerchantCell.h"



@interface JGMerchantViewController () <UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate, JGMerchantFilterViewDelegate> {
    
    NSMutableArray *_MerchantArray;
    NSString *_locationInfoStr;
    NSInteger _KindID;//分类查询ID，默认-1
    NSInteger _offset;
    UIView *_maskView;
    JGMerchantFilterView *_groupView;
}

@property(nonatomic, strong) UITableView *tableView;


@end

@implementation JGMerchantViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    _MerchantArray = [[NSMutableArray alloc] init];
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    _locationInfoStr = [userD objectForKey:@"location"];
    
    _offset = 0;
    _KindID = -1;//默认-1
    
    
    
    [self setNav];
    
    [self initViews];
    
    [self initMaskView];
}

#pragma mark - MaskView -
- (void)initMaskView {
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+40, kDeviceWidth, kDeviceHight-64-40-49)];
    _maskView.backgroundColor = JGRGBA(0, 0, 0, 0.5);
    [self.view addSubview:_maskView];
    _maskView.hidden = YES;
    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapMaskView:)];
    tap.delegate = self;
    [_maskView addGestureRecognizer:tap];
    
    //
    _groupView = [[JGMerchantFilterView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, _maskView.frame.size.height-90)];
    _groupView.delegate = self;
    [_maskView addSubview:_groupView];
    
}

- (void)OnTapMaskView:(UITapGestureRecognizer *)tap {
    
    _maskView.hidden = YES;
}



#pragma mark - 导航栏下选择子视图 -
- (void)initViews {
    
    //筛选
    UIView *filterView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kDeviceWidth, 40)];
    filterView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:filterView];
    
    NSArray *filterName = @[@"全部",@"全部",@"智能排序"];
    //筛选
    for (int i = 0; i < 3; i++) {
        //文字
        UIButton *filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        filterBtn.frame = CGRectMake(i*kDeviceWidth/3, 0, kDeviceWidth/3-15, 40);
        filterBtn.tag = 100+i;
        filterBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [filterBtn setTitle:filterName[i] forState:UIControlStateNormal];
        [filterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [filterBtn setTitleColor:JGNavBarColor forState:UIControlStateSelected];
        [filterBtn addTarget:self action:@selector(OnFilterBtn:) forControlEvents:UIControlEventTouchUpInside];
        [filterView addSubview:filterBtn];
        
        //三角
        UIButton *sanjiaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sanjiaoBtn.frame = CGRectMake((i+1)*kDeviceWidth/3-15, 16, 8, 7);
        sanjiaoBtn.tag = 120+i;
        [sanjiaoBtn setImage:[UIImage imageNamed:@"icon_arrow_dropdown_normal"] forState:UIControlStateNormal];
        [sanjiaoBtn setImage:[UIImage imageNamed:@"icon_arrow_dropdown_selected"] forState:UIControlStateSelected];
        [filterView addSubview:sanjiaoBtn];
    }
    //下划线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, kDeviceWidth, 0.5)];
    lineView.backgroundColor = JGRGB(192, 192, 192);
    [filterView addSubview:lineView];
    
    
    
    
    //tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+40, kDeviceWidth, kDeviceHight-64-40-49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self setUpTableView];
    
}


- (void)OnFilterBtn:(UIButton *)sender{
    for (int i = 0; i < 3; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:100+i];
        UIButton *sanjiaoBtn = (UIButton *)[self.view viewWithTag:120+i];
        btn.selected = NO;
        sanjiaoBtn.selected = NO;
    }
    sender.selected = YES;
    UIButton *sjBtn = (UIButton *)[self.view viewWithTag:sender.tag+20];
    sjBtn.selected = YES;
    _maskView.hidden = NO;
}

- (void)setUpTableView {
    
    //设置下拉刷新回调
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.tableView.mj_header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(getFirstPageData)];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)getFirstPageData {
    
    _offset = 0;
    [self refreshData];
    
    
}

-(void)refreshData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getMerchantList];
    });
}

//获取商家列表
-(void)getMerchantList{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *str = @"%2C";

    NSString *str1 = [NSString stringWithFormat:@"%@%ld%@",hostStr_URL,(long)_KindID,paramsStr_URL];

    NSString *urlStr = [NSString stringWithFormat:@"%@%f%@%f&offset=%zd%@",str1, delegate.latitude, str, delegate.longitude, _offset,str2_URL];
    
    __weak __typeof(self) weakself = self;
    [[NetworkSingleton sharedManager] getMerchantListResult:nil url:urlStr successBlock:^(id responseBody){
//        NSLog(@"获取商家列表成功");
        NSMutableArray *dataArray = [responseBody objectForKey:@"data"];
        
//        [dataArray writeToFile:@"/Users/stkcctv/Desktop/data.plist" atomically:YES];
        
//        NSLog(@"%ld",dataArray.count);
//        NSLog(@"offset:%ld",_offset);
        if (_offset == 0) {
            NSLog(@"0000");
            [_MerchantArray removeAllObjects];
        }
        
        for (int i = 0; i < dataArray.count; i++) {
            JGMerchantModel *JZMerM = [JGMerchantModel mj_objectWithKeyValues:dataArray[i]];
            [_MerchantArray addObject:JZMerM];
        }
        
        [weakself.tableView reloadData];
        
        if (_offset == 0 && dataArray.count!=0) {
            [weakself.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        [weakself.tableView.mj_header endRefreshing];
//        [weakself.tableView.footer endRefreshing];
        
    } failureBlock:^(NSString *error){
        NSLog(@"获取商家列表失败：%@",error);
        [weakself.tableView.mj_header endRefreshing];
//        [weakself.tableView.footer endRefreshing];
    }];
    
}
    





#pragma mark - 设置导航栏 -
- (void)setNav {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 64)];
    backView.backgroundColor = JGRGB(250, 250, 250);
    [self.view addSubview:backView];
    //下划线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, kDeviceWidth, 0.5)];
    lineView.backgroundColor = JGRGB(192, 192, 192);
    [backView addSubview:lineView];
    
    //地图
    UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mapBtn.frame = CGRectMake(10, 30, 23, 23);
    [mapBtn setImage:[UIImage imageNamed:@"icon_map"] forState:UIControlStateNormal];
    [mapBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:mapBtn];
    //搜索
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(kDeviceWidth-42, 30, 23, 23);
    [searchBtn setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(OnSearchBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:searchBtn];
    
    //segment
    UIButton *segBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    segBtn1.frame = CGRectMake(kDeviceWidth/2-80, 30, 80, 30);
    segBtn1.tag = 20;
    [segBtn1 setTitle:@"全部商家" forState:UIControlStateNormal];
    [segBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [segBtn1 setTitleColor:JGNavBarColor forState:UIControlStateNormal];
    [segBtn1 setBackgroundColor:JGNavBarColor];
    segBtn1.selected = YES;
    segBtn1.titleLabel.font = [UIFont systemFontOfSize:15];
    segBtn1.layer.borderWidth = 1;
    segBtn1.layer.borderColor = [JGNavBarColor CGColor];
    [segBtn1 addTarget:self action:@selector(OnSegBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:segBtn1];
    
    UIButton *segBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    segBtn2.frame = CGRectMake(kDeviceWidth/2, 30, 80, 30);
    segBtn2.tag = 21;
    [segBtn2 setTitle:@"优惠商家" forState:UIControlStateNormal];
    [segBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [segBtn2 setTitleColor:JGNavBarColor forState:UIControlStateNormal];
    [segBtn2 setBackgroundColor:[UIColor whiteColor]];
    segBtn2.titleLabel.font = [UIFont systemFontOfSize:15];
    segBtn2.layer.borderWidth = 1;
    segBtn2.layer.borderColor = [JGNavBarColor CGColor];
    [segBtn2 addTarget:self action:@selector(OnSegBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:segBtn2];
    
    
    
}

#pragma mark - 搜索
- (void)OnSearchBtn:(UIButton *)searchBtn {
    
    
}

#pragma mark - 地图
- (void)OnBackBtn:(UIButton *)btn {
    
    
    
}

#pragma mark - 中间
- (void)OnSegBtn:(UIButton *)sender {
    NSInteger tag = sender.tag;
    UIButton *segBtn1 = (UIButton *)[self.view viewWithTag:20];
    UIButton *segBtn2 = (UIButton *)[self.view viewWithTag:21];
    [segBtn1 setBackgroundColor:[UIColor whiteColor]];
    [segBtn2 setBackgroundColor:[UIColor whiteColor]];
    segBtn1.selected = NO;
    segBtn2.selected = NO;
    sender.selected = YES;
    [sender setBackgroundColor:JGNavBarColor];
    if (tag == 20) {
        NSLog(@"20");
    }else{
        NSLog(@"21");
    }
}


#pragma mark - UITableViewDataSourse -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _MerchantArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 30)];
    headerView.backgroundColor = JGRGB(240, 239, 237);
    
    //
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kDeviceWidth-10-40, 30)];
    locationLabel.font = [UIFont systemFontOfSize:13];
    //    locationLabel.text = @"当前：海淀区中关村大街";
    locationLabel.text = [NSString stringWithFormat:@"当前位置：%@",_locationInfoStr];
    locationLabel.textColor = [UIColor lightGrayColor];
    [headerView addSubview:locationLabel];
    
    //
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshBtn.frame = CGRectMake(kDeviceWidth-30, 5, 20, 20);
    [refreshBtn setImage:[UIImage imageNamed:@"icon_dellist_locate_refresh"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(OnRefreshLocationBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:refreshBtn];
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"merchantCell";
    JGMerchantCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[JGMerchantCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    JGMerchantModel *MerM = _MerchantArray[indexPath.row];
    cell.MerM = MerM;
    
    return cell;
}

- (void)OnRefreshLocationBtn:(UIButton *)btn {
    
}

#pragma mark - JGMerchantFilterView代理方法 -
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withId:(NSNumber *)ID withName:(NSString *)name {
    
    
    NSLog(@"ID:%@  name:%@",ID,name);
    _KindID = [ID integerValue];
    
    _maskView.hidden = YES;
    [self getFirstPageData];
    
    
    
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
