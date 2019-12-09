//
//  WTRegionModel.h
//  SongDa
//
//  Created by 灰太狼 on 2018/10/10.
//  Copyright © 2018年 维途. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTRegionModel : NSObject
@property (nonatomic, assign) NSInteger region_id;
@property (nonatomic, assign) NSInteger p_region_id;//父级 region_id
@property (nonatomic, assign) NSInteger region_grade;
@property (nonatomic, copy) NSString * region_path;
@property (nonatomic, copy) NSString * local_name;
@property (nonatomic, copy) NSString * zipcode;
@property (nonatomic, copy) NSString * cod;
@end
