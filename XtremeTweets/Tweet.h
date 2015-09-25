//
//  TweetObject.h
//  XtremeTweets
//
//  Created by DX144-XL on 2015-09-25.
//  Copyright © 2015 Pivotal Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject
@property (nonatomic,readonly) NSString * status;
@property (nonatomic,readonly) NSString* image;

- (void) setUpWithStatus: (NSString *) status andImage: (NSString *) image;
@end
