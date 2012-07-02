//
//  SHGoogleImageKit.h
//  GoogleImageSearchKit
//
//  Created by yin cai on 12-6-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>
#import "RegexKitLite.h"
#import "ASINetworkQueue.h"

typedef void(^SearchDidStartBlock)(void);
typedef void(^SearchDoneBlock)(NSArray* imageArray);
typedef void(^SearchFailBlock)(NSError* err);





@interface SHGoogleImageKit : NSObject{
    NSMutableArray* _imageArray;
    NSInteger _resultPerQuery;
    NSInteger _startPosition;
    NSInteger _filter;
    SearchDoneBlock _onSearchDoneAction;
    ASINetworkQueue* _netWorkQueue;
    
    SearchDidStartBlock _searchDidStartBlock;
    
    NSString* _imagesRegex;
    NSString* _dataRegex;
    NSString* _totalResultsRegex;
}
@property(nonatomic,assign) NSInteger resultPerQuery;
@property(nonatomic,assign) NSInteger startPosition;
@property(nonatomic,assign) NSInteger filter;

@property(nonatomic,copy) SearchDidStartBlock searchDidStartBlock;

+(SHGoogleImageKit*)Kit;
-(void)getPictureByKeyWord:(NSString*)keyWord doneBlock:(SearchDoneBlock)doneBlock failBlock:(SearchFailBlock)failBlock;
@end
