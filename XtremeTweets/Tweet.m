//
//  TweetObject.m
//  XtremeTweets
//
//  Created by DX144-XL on 2015-09-25.
//  Copyright © 2015 Pivotal Labs. All rights reserved.
//

#import "Tweet.h"


@interface Tweet()

@property (nonatomic,readwrite) NSString * status;
@property (nonatomic,readwrite) NSString * image;

@end


@implementation Tweet

- (instancetype) init {
    self = [super init];
    if (self){
        _status = @"New Status";
        _image = @"https://pbs.twimg.com/profile_images/554709152329498625/TrAvNStG_400x400.jpeg";
    }
    return self;
}

- (void)setUpWithStatus:(NSString *)status andImage:(NSString *)image {
    self.status = status;
    self.image = image;
}

@end
