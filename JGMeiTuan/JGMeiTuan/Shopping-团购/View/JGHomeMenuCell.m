//
//  JGHomeMenuCell.m
//  JGMeiTuan
//
//  Created by stkcctv on 16/8/30.
//  Copyright © 2016年 stkcctv. All rights reserved.
//

#import "JGHomeMenuCell.h"
#import "JZMTBtnView.h"


@interface JGHomeMenuCell () <UIScrollViewDelegate> {
    
    UIView *_backView1;
    UIView *_backView2;
    UIPageControl *_pageControl;
    
}



@end

@implementation JGHomeMenuCell

+(instancetype)cellWithTableView:(UITableView *)tableView menuArray:(NSMutableArray *)menuArray {
    
    static NSString *cellID = @"tangshuoqweqwqeqeqe";
    JGHomeMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil) {
        cell = [[JGHomeMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID menuArray:menuArray];
    }
    return cell;
    
    
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier menuArray:(NSMutableArray *)menuArray {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
        _backView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 160)];
        _backView2 = [[UIView alloc] initWithFrame:CGRectMake(kDeviceWidth, 0, kDeviceWidth, 160)];
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 180)];
        scrollView.contentSize = CGSizeMake(2*kDeviceWidth, 180);
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        
        [scrollView addSubview:_backView1];
        [scrollView addSubview:_backView2];
        [self addSubview:scrollView];
        
        //创建8个
        for (int i = 0; i < 16; i++) {
            if (i < 4) {
                CGRect frame = CGRectMake(i*kDeviceWidth/4, 0, kDeviceWidth/4, 80);
                NSString *title = [menuArray[i] objectForKey:@"title"];
                NSString *imageStr = [menuArray[i] objectForKey:@"image"];
                JZMTBtnView *btnView = [[JZMTBtnView alloc] initWithFrame:frame title:title imageStr:imageStr];
                btnView.tag = 10+i;
                [_backView1 addSubview:btnView];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBtnView:)];
                [btnView addGestureRecognizer:tap];
                
            }else if(i<8){
                CGRect frame = CGRectMake((i-4)*kDeviceWidth/4, 80, kDeviceWidth/4, 80);
                NSString *title = [menuArray[i] objectForKey:@"title"];
                NSString *imageStr = [menuArray[i] objectForKey:@"image"];
                JZMTBtnView *btnView = [[JZMTBtnView alloc] initWithFrame:frame title:title imageStr:imageStr];
                btnView.tag = 10+i;
                [_backView1 addSubview:btnView];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBtnView:)];
                [btnView addGestureRecognizer:tap];
            }else if(i < 12){
                CGRect frame = CGRectMake((i-8)*kDeviceWidth/4, 0, kDeviceWidth/4, 80);
                NSString *title = [menuArray[i] objectForKey:@"title"];
                NSString *imageStr = [menuArray[i] objectForKey:@"image"];
                JZMTBtnView *btnView = [[JZMTBtnView alloc] initWithFrame:frame title:title imageStr:imageStr];
                btnView.tag = 10+i;
                [_backView2 addSubview:btnView];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBtnView:)];
                [btnView addGestureRecognizer:tap];
            }else{
                CGRect frame = CGRectMake((i-12)*kDeviceWidth/4, 80, kDeviceWidth/4, 80);
                NSString *title = [menuArray[i] objectForKey:@"title"];
                NSString *imageStr = [menuArray[i] objectForKey:@"image"];
                JZMTBtnView *btnView = [[JZMTBtnView alloc] initWithFrame:frame title:title imageStr:imageStr];
                btnView.tag = 10+i;
                [_backView2 addSubview:btnView];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBtnView:)];
                [btnView addGestureRecognizer:tap];
            }
        }
        
        //
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(kDeviceWidth/2-20, 160, 0, 20)];
        _pageControl.center = CGPointMake(self.frame.size.width * 0.5, 170);
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = 2;
//                _pageControl.backgroundColor = [UIColor redColor];
        [self addSubview:_pageControl];
        [_pageControl setCurrentPageIndicatorTintColor:JGNavBarColor];
        [_pageControl setPageIndicatorTintColor:[UIColor grayColor]];
        
    }

    return self;
}


- (void)OnTapBtnView:(UITapGestureRecognizer *)tap {
    
    JGLog(@"tag:%ld",tap.view.tag);
    
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollViewW/2)/scrollViewW;
    _pageControl.currentPage = page;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
