//
//  OTShopCartManager.m
//  OneTreasure
//
//  Created by Frederic on 2016/12/8.
//  Copyright © 2016年 honeyeeb. All rights reserved.
//

#import "OTShopCartManager.h"
#import "NSString+OTUtils.h"
#import "OTGoodsModel.h"
#import "OTCommon.h"
#import "OTShopCartPayRequest.h"
#import "OTSignatureModel+OTShopCartPay.h"
#import <YYModel/YYModel.h>
#import "OTAccountManager.h"
#import "OTUserModel.h"
#import "OTNetworkManager.h"
#import "OTCommon.h"
#import "OTStatistics.h"



@interface OTShopCartManager ()

/// 购物车中的商品
@property (nonatomic, strong) NSMutableArray *shopListArray;
/// 购物车中商品ID作为key
@property (nonatomic, strong) NSMutableDictionary *shopListIDDic;

@property (nonatomic, strong) dispatch_queue_t shopCartQueue;
/// 选中的商品
@property (nonatomic, strong) NSMutableArray* selectMutableArray;



@end


@implementation OTShopCartManager

+ (instancetype)sharedInstance {
    static OTShopCartManager *sharedShopCart = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedShopCart = [OTShopCartManager new];
    });
    return sharedShopCart;
}

- (instancetype)init {
    if (self = [super init]) {
        _shopCartQueue = dispatch_get_global_queue(100, 0);
        
    }
    return self;
}

- (void)dealloc {
}

- (NSMutableArray *)shopListArray {
    if (!_shopListArray) {
        _shopListArray = [NSMutableArray array];
    }
    return _shopListArray;
}

- (NSMutableDictionary *)shopListIDDic {
    if (!_shopListIDDic) {
        _shopListIDDic = [NSMutableDictionary dictionary];
    }
    return _shopListIDDic;
}

- (NSMutableArray *)selectMutableArray {
    if (!_selectMutableArray) {
        _selectMutableArray = [NSMutableArray array];
    }
    return _selectMutableArray;
}

- (NSArray *)selectedIDArray {
    return self.selectMutableArray;
}

- (NSString *)totalCount {
    return [NSString stringWithFormat:@"%ld", self.shopListArray.count];
}

- (NSArray *)shopCartArray {
    return self.shopListArray;
}

- (NSString *)selectedPrice {
    NSString *price;
    __block double prices = 0.00;
    [self.selectMutableArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        OTGoodsModel *model = (OTGoodsModel *)obj;
        prices += [model.price doubleValue] * model.cyrs;
    }];
    price = [NSString stringWithFormat:@"%.0f", prices];
    return price;
}

- (void)setPaySelectedAll:(BOOL)paySelectedAll {
    if (paySelectedAll) {
        self.selectMutableArray = self.shopListArray;
    } else {
        self.selectMutableArray = nil;
    }
}

- (BOOL)paySelectedAll {
    return self.selectMutableArray.count == self.shopListArray.count;
}

#pragma mark - Action

- (void)postNotification {
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        if (weakSelf.totalCount) {
            userInfo[kOTShopCartNotifiCountValue] = weakSelf.totalCount;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kOTShopCartCountPriceNotification object:nil userInfo:userInfo];
    });
}

- (BOOL)existForGoodsID:(NSString *)goodsID {
    if ([NSString isEmptyString:goodsID]) {
        return NO;
    }
    return ([self.shopListIDDic objectForKey:goodsID] != nil);
}

- (OTGoodsModel *)getGoodsModelWithID:(NSString *)uuid {
    if ([NSString isEmptyString:uuid]) {
        return nil;
    }
    NSArray *arr = self.shopListArray;
    __block OTGoodsModel *goods;
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        OTGoodsModel *tmp = (OTGoodsModel *)obj;
        if ([tmp.uuid isEqualToString:uuid]) {
            goods = tmp;
            *stop = YES;
        }
    }];
    return goods;
}

- (void)addGoods:(OTGoodsModel *)goodsModel {
    if (![NSString isEmptyString:goodsModel.uuid]) {
        OTLog(@"【添加商品】%@", goodsModel.uuid);
        if (![self existForGoodsID:goodsModel.uuid]) {
            // 不存在
            OTGoodsModel *model = goodsModel.copy;
            model.cyrs = 1;
            [self.shopListArray addObject:model];
            [self.shopListIDDic setObject:@(0) forKey:model.uuid];
            
            // 默认新加入的选中
            [self selectOrDeselectGoods:model];
        } else {
            // 存在
            OTGoodsModel *model = [self getGoodsModelWithID:goodsModel.uuid];
            model.cyrs += 1;
            
        }
        [self postNotification];
        
        // 添加购物车统计
        NSDictionary *dic = [goodsModel statisticsJSON];
        if (dic) {
            [OTStatistics event:@"ot_add_shop_cart_goods" attributes:dic];
        }
    }
}

- (void)subtractGoods:(OTGoodsModel *)goodsModel {
    if (![self existForGoodsID:goodsModel.uuid]) {
        // 不存在
        
    } else {
        // 存在
        OTGoodsModel *model = [self getGoodsModelWithID:goodsModel.uuid];
        if (model.cyrs > 1) {
            model.cyrs -= 1;
        }
//        else {
//            [self removeGoods:goodsModel];
//        }
        
        [self postNotification];
    }
}

- (void)subtractGoodsWithIndex:(NSInteger)index {
    if (index < self.shopListArray.count) {
     
        OTGoodsModel *model = self.shopListArray[index];
        [self subtractGoods:model];
        
    }
}

- (void)removeGoods:(OTGoodsModel *)goodsModel {
    if (![self existForGoodsID:goodsModel.uuid]) {
        // 不存在
        
    } else {
        // 存在
        OTGoodsModel *model = [self getGoodsModelWithID:goodsModel.uuid];
        
        [self.shopListIDDic removeObjectForKey:goodsModel.uuid];
        if ([self.selectMutableArray containsObject:goodsModel]) {
            [self.selectMutableArray removeObject:goodsModel];
        }
        [self.shopListArray removeObject:model];
        
        [self postNotification];
    }
    
}

- (void)removeGoodsWithIndex:(NSInteger)index {
    if (index < self.shopListArray.count) {
        OTGoodsModel *model = self.shopListArray[index];
        [self removeGoods:model];
    }
}

- (void)removeAllGoods {
    [self.shopListArray removeAllObjects];
    [self.shopListIDDic removeAllObjects];
    
    [self.selectMutableArray removeAllObjects];
    [self postNotification];
}


- (void)selectOrDeselectGoods:(OTGoodsModel *)goodsModel {
    if (goodsModel) {
        if ([self.selectMutableArray containsObject:goodsModel]) {
            [self.selectMutableArray removeObject:goodsModel];
        } else {
            [self.selectMutableArray addObject:goodsModel];
        }
    }
}

- (void)selectOrDeselectGoodsWithIndex:(NSInteger)index {
    if (index < self.shopListArray.count) {
        OTGoodsModel *model = self.shopListArray[index];
        [self selectOrDeselectGoods:model];
    }
}

- (NSString *)getSelectedPayParams {
    NSString *param = nil;
    NSArray *tmpSelect = self.selectMutableArray;
    __block NSMutableArray *paramArr = [NSMutableArray array];
    [tmpSelect enumerateObjectsUsingBlock:^(OTGoodsModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *json = [obj yy_modelToJSONObject];
        OTShopCartPayRequest *request = [OTShopCartPayRequest yy_modelWithDictionary:json];
        NSDictionary *paraDic = [request yy_modelToJSONObject];
        OTLog(@"%@", paraDic);
        if (paraDic) {
            [paramArr addObject:paraDic];
        }
    }];
    NSError *jsonErr;
    NSData *data = [NSJSONSerialization dataWithJSONObject:paramArr options:NSJSONWritingPrettyPrinted error:&jsonErr];
    if (jsonErr) {
        OTLog(@"【购物车支付，转JSON】%@", jsonErr);
    }
    if (data) {
        param = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return param;
}

- (void)payResuestCompletion:(void (^)(NSInteger code, NSString *errMsg))handler {
    
    NSString *params = [self getSelectedPayParams];
    [self directPayWithPatams:params completion:handler];
}

- (void)directPayWithPatams:(NSString *)param completion:(void (^)(NSInteger code, NSString *errMsg))handler {
    OTSignatureModel *signature = [[OTSignatureModel alloc] init];
    signature.cartArray = param;
    NSString *hello = [OTAccountManager sharedManger].userModel.accessToken;
    [signature setHelloWorld:hello];
    signature.userID = [OTAccountManager sharedManger].userID;
    
    NSString *params = signature.seriaParamString;
    
    NSURLSessionDataTask *task = [[OTNetworkManager sharedManager] POST:[URL_HOST stringByAppendingString:URL_COIN_PAY] params:params completion:^(NSDictionary *data, NSString *errMsg) {
        if (data) {
            // code
            NSInteger code = [[NSString stringWithFormat:@"%@", data[@"code"]] integerValue];
            NSString *msg = data[@"msg"];
            if (!msg) {
                msg = kErrorMessage;
            }
            if (handler) {
                handler(code, msg);
            }
            
            // 购买成功统计
            NSString *valueParam = (100 < param.length && param.length > 0) ? param : @"";
            NSDictionary *dic = @{ @"value":  valueParam,
                                   @"userID": [OTAccountManager sharedManger].userID,
                                   @"mobile": [OTAccountManager sharedManger].userModel.mobile};
            
            [OTStatistics event:@"ot_pay_shop_cart_goods_success" attributes:dic];
        } else {
            if (handler) {
                handler(-1, kErrorMessage);
            }
            
            // 购买失败统计
            NSDictionary *dic = @{ @"userID": [OTAccountManager sharedManger].userID,
                                   @"mobile": [OTAccountManager sharedManger].userModel.mobile};
            [OTStatistics event:@"ot_pay_shop_cart_goods_failed" attributes:dic];
        }
    }];
    [task resume];
}

@end
