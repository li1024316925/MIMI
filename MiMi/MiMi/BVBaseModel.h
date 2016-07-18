//
//  BVBaseModel.h
//  Weibo
//
//  Created by 孙 峰 on 15/10/26.
//  Copyright © 2015年 Bever. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface BVBaseModel : NSObject <NSCoding>{

}


@property (nonatomic,copy) NSString *text;

-(id)initWithDataDic:(NSDictionary*)data;
- (NSDictionary*)attributeMapDictionary;
- (void)setAttributes:(NSDictionary*)dataDic;
- (NSString *)customDescription;
- (NSString *)description;
- (NSData*)getArchivedData;

- (NSString *)cleanString:(NSString *)str;    //清除\n和\r的字符串


-(void)praseText;
@end
