//
//  NetworkController.m
//  XtremeTweets
//
//  Created by DX144-XL on 2015-09-21.
//  Copyright © 2015 Pivotal Labs. All rights reserved.
//

#import "NetworkManager.h"
#import "AFNetworking.h"
#import "KSDeferred.h"
@implementation NetworkManager
-(KSPromise *) getTweetsForHashtags: (NSString *) hashtag {
    KSDeferred * deferred = [KSDeferred defer];
    
    [deferred resolveWithValue:nil];
    [deferred rejectWithError:nil];
    
    return deferred.promise;
}

@end
