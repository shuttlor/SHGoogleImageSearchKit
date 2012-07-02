//
//  SHGoogleImageKit.m
//  GoogleImageSearchKit
//
//  Created by yin cai on 12-6-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SHGoogleImageKit.h"


static SHGoogleImageKit* _g_SHCoogleImageKit = nil;


@interface SHGoogleImageKit(private_function)
-(void)searchDidStart:(ASIHTTPRequest *)request;
-(void)searchDidFinished:(ASIHTTPRequest *)request;
-(void)searchDidFail:(ASIHTTPRequest *)request;
-(NSArray*)getImageURLArray:(NSString*)htmlCode;
@end

@implementation SHGoogleImageKit
@synthesize resultPerQuery = _resultPerQuery;
@synthesize startPosition = _startPosition;
@synthesize filter = _filter;
@synthesize searchDidStartBlock = _searchDidStartBlock;

+(SHGoogleImageKit*)Kit{
    if (!_g_SHCoogleImageKit) {
        _g_SHCoogleImageKit = [[SHGoogleImageKit alloc] init];
    }
    return _g_SHCoogleImageKit;
}


-(id)init{
    if ((self = [super init])) {
        _resultPerQuery = 20;
        _startPosition = 0;
        _filter = 0;
        
        _netWorkQueue = [[ASINetworkQueue alloc] init];
        [_netWorkQueue reset];
        [_netWorkQueue setDelegate:self];
        [_netWorkQueue setShouldCancelAllRequestsOnFailure:YES];
        [_netWorkQueue setRequestDidStartSelector:@selector(searchDidStart:)];
        [_netWorkQueue setRequestDidFinishSelector:@selector(searchDidFinished:)];
        [_netWorkQueue setRequestDidFailSelector:@selector(searchDidFail:)];
    }
    return self;
}

-(void)getPictureByKeyWord:(NSString*)keyWord doneBlock:(SearchDoneBlock)doneBlock failBlock:(SearchFailBlock)failBlock{
    
    if ([keyWord length] == 0) {
        if (failBlock) {
            failBlock(nil);
        }
        return;
    }
    
    _onSearchDoneAction = doneBlock;
    
    
    
    NSString* queryStrAfterRegex = [keyWord RKL_METHOD_PREPEND(stringByReplacingOccurrencesOfRegex):@"\\s{1,}" withString:@"+"];
    NSString* formatSearchURI = [NSString stringWithFormat:@"http://images.google.com/images?q=%@&ndsp=%d&start=%d&filter=%d&safe=%@",queryStrAfterRegex,_resultPerQuery,_startPosition,_filter,@"moderate"];
    
    NSLog(@"URI = %@",formatSearchURI);
    
    ASIHTTPRequest *request;
	request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:formatSearchURI]];
	[_netWorkQueue addOperation:request];
    [_netWorkQueue go];
}


#pragma private_function
-(void)searchDidStart:(ASIHTTPRequest *)request{
    NSLog(@"searchDidStart");
    if (_searchDidStartBlock) {
        _searchDidStartBlock();
    }
}

-(void)searchDidFinished:(ASIHTTPRequest *)request{
    NSString* responeseHTMLText = [NSString stringWithString:[request responseString]];
    NSRange range = [responeseHTMLText rangeOfString:@"<table class=\"images_table\""];
    NSString* subStringTail = [responeseHTMLText substringFromIndex:range.location];
    NSRange closeTagRange = [subStringTail rangeOfString:@"</table>"];
    
    NSRange tableRange;
    tableRange.location = 0;
    tableRange.length = closeTagRange.location;
    NSString* imagesTableCode = [subStringTail substringWithRange:tableRange];
    NSArray* urlArray = [self getImageURLArray:imagesTableCode];
    
    if (_onSearchDoneAction) {
        _onSearchDoneAction(urlArray);
    }
}

-(void)searchDidFail:(ASIHTTPRequest *)request{
    NSLog(@"searchDidFail");
}

-(NSArray*)getImageURLArray:(NSString*)htmlCode{
    
    if (!htmlCode || [htmlCode length] == 0) {
        return nil;
    }
    
    NSMutableArray* urlArray = [[NSMutableArray alloc] init];
    char* code = (char*)[htmlCode cStringUsingEncoding:NSUTF8StringEncoding];
    char temp[1024];
    memset(temp, 0, 1024);
    
    char* p = NULL;
    char* q = NULL;
    p = q = code;
    int tokenLen = strlen("href=\"/imgres?imgurl=");
    int tailTokenLen = strlen("&amp;imgrefurl=");
    
    for (q=p;(q!=NULL&&p!=NULL);) {
        p = strstr(code,"href=\"/imgres?imgurl=");
        if (!p) {
            break;
        }
        p = p + tokenLen;
        q = strstr(p,"&amp;imgrefurl=");
        memset(temp, 0, 1024);
        memcpy(temp,p,q-p);
        NSString* URL = [NSString stringWithCString:temp encoding:NSUTF8StringEncoding];
        [urlArray addObject:URL];
        q = q + tailTokenLen;
        p = q;
        code = p;
    }
    return urlArray;
}

@end
