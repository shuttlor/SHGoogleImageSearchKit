//
//  SHViewController.m
//  GoogleImageSearchKit
//
//  Created by yin cai on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SHViewController.h"
#import "SHGoogleImageKit.h"

@interface SHViewController(priavte_function)
-(void)imageArrayFetched:(NSArray*)imageArray;
-(void)imageArrayFetchedFialure:(NSError*)err;
@end

@implementation SHViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SearchDoneBlock doneBlock = ^(NSArray* imageArray) {
        if ([self respondsToSelector:@selector(imageArrayFetched:)]) {
            [self performSelector:@selector(imageArrayFetched:) withObject:imageArray];
        }
    };
    
    SearchFailBlock failBlock = ^(NSError* err) {
        if ([self respondsToSelector:@selector(imageArrayFetchedFialure:)]) {
            [self performSelector:@selector(imageArrayFetchedFialure:) withObject:err];
        }
    };
    
    SHGoogleImageKit* searchKit = [SHGoogleImageKit Kit];
    [searchKit getPictureByKeyWord:@"Macbook iMac macbook air" doneBlock:doneBlock failBlock:failBlock];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma private_function
-(void)imageArrayFetched:(NSArray*)imageArray{
    NSLog(@"fetch %d images",[imageArray count]);
    for (NSString* str in imageArray) {
        NSLog(@"Iamge URL = %@",str);
    }
    
}

@end
