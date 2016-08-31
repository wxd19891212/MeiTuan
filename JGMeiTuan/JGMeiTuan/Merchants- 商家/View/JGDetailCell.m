//
//  JGDetailCell.m
//  JGMeiTuan
//
//  Created by stkcctv on 16/8/31.
//  Copyright © 2016年 stkcctv. All rights reserved.
//

#import "JGDetailCell.h"

@implementation JGDetailCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellIndentifier = @"filterCell2";
    JGDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[JGDetailCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
        //下划线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 41.5, cell.frame.size.width, 0.5)];
        lineView.backgroundColor = JGRGB(192, 192, 192);
        [cell.contentView addSubview:lineView];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.backgroundColor = JGRGB(242, 242, 242);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)setDic:(NSDictionary *)dic {
    
    _dic = dic;
    
    self.textLabel.text = [dic objectForKey:@"name"];
    self.detailTextLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"count"]];
    
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
