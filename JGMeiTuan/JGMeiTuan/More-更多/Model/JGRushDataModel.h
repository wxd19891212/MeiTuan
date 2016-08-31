//
//  JGRushDataModel.h
//  JGMeiTuan
//
//  Created by stkcctv on 16/8/30.
//  Copyright © 2016年 stkcctv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGRushDataModel : NSObject

@property(nonatomic, strong) NSNumber *id;
@property(nonatomic, strong) NSMutableArray *share;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSNumber *start;
@property(nonatomic, strong) NSNumber *listJumpToTouch;

@property(nonatomic, strong) NSNumber *type;
@property(nonatomic, strong) NSString *descBefore;
@property(nonatomic, strong) NSMutableArray *deals;
@property(nonatomic, strong) NSNumber *end;
@property(nonatomic, strong) NSString *touchUrlForList;

@property(nonatomic, strong) NSString *descIn;
@property(nonatomic, strong) NSString *descAfter;

@end
