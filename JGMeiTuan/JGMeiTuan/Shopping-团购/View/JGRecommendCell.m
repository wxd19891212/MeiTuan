//
//  JGRecommendCell.m
//  JGMeiTuan
//
//  Created by stkcctv on 16/8/31.
//  Copyright © 2016年 stkcctv. All rights reserved.
//

#import "JGRecommendCell.h"

@interface JGRecommendCell () {
    NSString *_type;
}

@end


@implementation JGRecommendCell


+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellIndentifier = @"recommendcell";
    JGRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[JGRecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
 
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //
        _type = @"none";
        [self initViews];
    }
    return self;
}

-(void)initViews{
    //图
    self.shopImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
    self.shopImage.layer.masksToBounds = YES;
    self.shopImage.layer.cornerRadius = 4.0;
    [self.contentView addSubview:self.shopImage];
    //免预约
    UIImageView *yuyueImgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    [yuyueImgV setImage:[UIImage imageNamed:@"ic_deal_noBooking"]];
    [self.contentView addSubview:yuyueImgV];
    
    //店名
    self.shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, kDeviceWidth-100-80, 30)];
    [self.contentView addSubview:self.shopNameLabel];
    
    //介绍
    self.shopInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, kDeviceWidth-100-10, 45)];
    self.shopInfoLabel.textColor = [UIColor lightGrayColor];
    self.shopInfoLabel.font = [UIFont systemFontOfSize:13];
    self.shopInfoLabel.numberOfLines = 2;
    self.shopInfoLabel.lineBreakMode = UILineBreakModeWordWrap|UILineBreakModeTailTruncation;
    [self.contentView addSubview:self.shopInfoLabel];
    
    //价格
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 80, 50, 20)];
    self.priceLabel.textColor = JGNavBarColor;
    [self.contentView addSubview:self.priceLabel];
    
}

-(void)setRecommendData:(JGRecommendModel *)recommendData{
    _type = @"recommend";
    _recommendData = recommendData;
    NSString *imageUrl = [_recommendData.squareimgurl stringByReplacingOccurrencesOfString:@"w.h" withString:@"160.0"];
    [self.shopImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"bg_customReview_image_default"]];
    
    self.shopNameLabel.text = recommendData.mname;
    self.shopInfoLabel.text = [NSString stringWithFormat:@"[%@]%@",recommendData.range,recommendData.title];
    NSString *priceStr = [NSString stringWithFormat:@"%d元",[recommendData.price intValue]];
//    NSLog(@"%@",priceStr);
    CGSize labelSize = [priceStr sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(200, 20) lineBreakMode:NSLineBreakByWordWrapping];
    self.priceLabel.text = priceStr;
    self.priceLabel.frame = CGRectMake(100, 75, labelSize.width+10, 20);
}


//-(void)setDealData:(JGDiscountModel *)dealData{
//    _type = @"discount";
//    _dealData = dealData;
//    NSString *imageUrl = [dealData.squareimgurl stringByReplacingOccurrencesOfString:@"w.h" withString:@"160.0"];
//    [self.shopImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"bg_customReview_image_default"]];
//    
//    self.shopNameLabel.text = dealData.mname;
//    self.shopInfoLabel.text = [NSString stringWithFormat:@"[%@]%@",dealData.range,dealData.title];
//    
//    NSString *priceStr = [NSString stringWithFormat:@"%d元",[dealData.price intValue]];
//    CGSize labelSize = [priceStr sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(200, 20) lineBreakMode:NSLineBreakByWordWrapping];
//    self.priceLabel.text = priceStr;
//    self.priceLabel.frame = CGRectMake(100, 75, labelSize.width+10, 20);
//}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
