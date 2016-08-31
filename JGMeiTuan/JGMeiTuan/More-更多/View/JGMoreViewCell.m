//
//  JGMoreViewCell.m
//  JGMeiTuan
//
//  Created by stkcctv on 16/8/31.
//  Copyright © 2016年 stkcctv. All rights reserved.
//

#import "JGMoreViewCell.h"

@implementation JGMoreViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *cellIndentifier = @"moreCell";
    JGMoreViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[JGMoreViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    return cell;
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
