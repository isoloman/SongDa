//
//  WTRegionManager.m
//  SongDa
//
//  Created by 灰太狼 on 2018/10/10.
//  Copyright © 2018年 维途. All rights reserved.
//

#import "WTRegionManager.h"
#import <FMDB/FMDB.h>
#import "WTRegionModel.h"

@implementation WTRegionManager
/**通过省 或者市 获取同一省下所有市*/
+ (NSMutableArray <WTRegionModel *>*)getRegion:(NSString *)area isProvince:(BOOL)isProvince{
    
    NSString *dbPath = [[NSBundle mainBundle]pathForResource:@"city" ofType:@"db"];
    
    //2.创建对应路径下数据库
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    //3.在数据库中进行增删改查操作时，需要判断数据库是否open，如果open失败，可能是权限或者资源不足，数据库操作完成通常使用close关闭数据库
    [db open];
    if (![db open]) {
        NSLog(@"db open fail");
        return nil;
    }
    NSString * query ;
    if (isProvince) {
        query = [NSString stringWithFormat:@"SELECT * FROM region where region_grade = '1' and local_name LIKE '%%%@%%';",area];
    }
    else{
        query = [NSString stringWithFormat:@"SELECT * FROM region where region_grade <= '2' and local_name LIKE '%%%@%%';",area];
    }
    
    FMResultSet *result = [db executeQuery:query];
    WTRegionModel * proVinceItem = [[WTRegionModel alloc] init]; //给模型赋值
    while ([result next]) {
        proVinceItem.region_id = [result intForColumn:@"region_id"];
        proVinceItem.p_region_id = [result intForColumn:@"p_region_id"];
        proVinceItem.region_path = [result stringForColumn:@"region_path"];
        proVinceItem.region_grade = [result intForColumn:@"region_grade"];
        proVinceItem.local_name = [result stringForColumn:@"local_name"];
        proVinceItem.zipcode = [result stringForColumn:@"zipcode"];
        proVinceItem.cod = [result stringForColumn:@"cod"];
        NSLog(@"第一次从数据库查询到%@",[result stringForColumn:@"local_name"]);
    }
    
    query = [NSString stringWithFormat:@"SELECT * FROM region where p_region_id = '%zd';",isProvince||proVinceItem.region_grade==1? proVinceItem.region_id:proVinceItem.p_region_id];//proVinceItem.region_grade==1 判断北京市等直辖市
    result = [db executeQuery:query];
    
    NSMutableArray * areas = [NSMutableArray new];
    while ([result next]) {
        WTRegionModel * item = [[WTRegionModel alloc] init]; //给模型赋值
        item.region_id = [result intForColumn:@"region_id"];
        item.p_region_id = [result intForColumn:@"p_region_id"];
        item.region_path = [result stringForColumn:@"region_path"];
        item.region_grade = [result intForColumn:@"region_grade"];
        item.local_name = [result stringForColumn:@"local_name"];
        item.zipcode = [result stringForColumn:@"zipcode"];
        item.cod = [result stringForColumn:@"cod"];
        [areas addObject:item];
        NSLog(@"从数据库查询到二级地区%@",[result stringForColumn:@"local_name"]);
    }
    
    [db close]; //关闭
    
    return areas;
}

/*获取市下所有区*/
+ (NSMutableArray <WTRegionModel *>*)getCityRegion:(NSInteger)region_id{
    NSString *dbPath = [[NSBundle mainBundle]pathForResource:@"city" ofType:@"db"];
    
    //2.创建对应路径下数据库
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    //3.在数据库中进行增删改查操作时，需要判断数据库是否open，如果open失败，可能是权限或者资源不足，数据库操作完成通常使用close关闭数据库
    [db open];
    if (![db open]) {
        NSLog(@"db open fail");
        return nil;
    }
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM region where region_grade <= '3' and p_region_id = '%zd';",region_id];
    FMResultSet *result = [db executeQuery:query];
    
    NSMutableArray * areas = [NSMutableArray new];
    while ([result next]) {
        WTRegionModel * item = [[WTRegionModel alloc] init]; //给模型赋值
        item.region_id = [result intForColumn:@"region_id"];
        item.p_region_id = [result intForColumn:@"p_region_id"];
        item.region_path = [result stringForColumn:@"region_path"];
        item.region_grade = [result intForColumn:@"region_grade"];
        item.local_name = [result stringForColumn:@"local_name"];
        item.zipcode = [result stringForColumn:@"zipcode"];
        item.cod = [result stringForColumn:@"cod"];
        [areas addObject:item];
        NSLog(@"从数据库查询到区%@",[result stringForColumn:@"local_name"]);
    }
    
    [db close]; //关闭
    
    return areas;
}

+ (WTRegionModel *)getRegionByLocalName:(NSString *)area{
    
    NSString *dbPath = [[NSBundle mainBundle]pathForResource:@"city" ofType:@"db"];
    
    //2.创建对应路径下数据库
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    //3.在数据库中进行增删改查操作时，需要判断数据库是否open，如果open失败，可能是权限或者资源不足，数据库操作完成通常使用close关闭数据库
    [db open];
    if (![db open]) {
        NSLog(@"db open fail");
        return nil;
    }
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM region where local_name LIKE '%%%@%%';",area];
    
    FMResultSet *result = [db executeQuery:query];
    WTRegionModel * proVinceItem = [[WTRegionModel alloc] init]; //给模型赋值
    while ([result next]) {
        if (proVinceItem.region_grade < [result intForColumn:@"region_grade"]) {
            proVinceItem.region_id = [result intForColumn:@"region_id"];
            proVinceItem.p_region_id = [result intForColumn:@"p_region_id"];
            proVinceItem.region_path = [result stringForColumn:@"region_path"];
            proVinceItem.region_grade = [result intForColumn:@"region_grade"];
            proVinceItem.local_name = [result stringForColumn:@"local_name"];
            proVinceItem.zipcode = [result stringForColumn:@"zipcode"];
            proVinceItem.cod = [result stringForColumn:@"cod"];
            NSLog(@"从数据库查询到%@",[result stringForColumn:@"local_name"]);
        }
    }
    
    [db close]; //关闭
    
    return proVinceItem;
}

+ (WTRegionModel *)getRegionByRegionID:(NSString *)regionID{
    NSString *dbPath = [[NSBundle mainBundle]pathForResource:@"city" ofType:@"db"];
    
    //2.创建对应路径下数据库
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    //3.在数据库中进行增删改查操作时，需要判断数据库是否open，如果open失败，可能是权限或者资源不足，数据库操作完成通常使用close关闭数据库
    [db open];
    if (![db open]) {
        NSLog(@"db open fail");
        return nil;
    }
    NSString * query = [NSString stringWithFormat:@"SELECT * FROM region where region_id = '%@';",regionID];
    
    FMResultSet *result = [db executeQuery:query];
    WTRegionModel * proVinceItem = [[WTRegionModel alloc] init]; //给模型赋值
    while ([result next]) {
        if (proVinceItem.region_grade < [result intForColumn:@"region_grade"]) {
            proVinceItem.region_id = [result intForColumn:@"region_id"];
            proVinceItem.p_region_id = [result intForColumn:@"p_region_id"];
            proVinceItem.region_path = [result stringForColumn:@"region_path"];
            proVinceItem.region_grade = [result intForColumn:@"region_grade"];
            proVinceItem.local_name = [result stringForColumn:@"local_name"];
            proVinceItem.zipcode = [result stringForColumn:@"zipcode"];
            proVinceItem.cod = [result stringForColumn:@"cod"];
            NSLog(@"从数据库查询到%@",[result stringForColumn:@"local_name"]);
        }
    }
    
    [db close]; //关闭
    
    return proVinceItem;
}

@end
