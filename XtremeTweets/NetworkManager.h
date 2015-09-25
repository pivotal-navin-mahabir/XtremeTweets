//
//  NetworkController.h
//  XtremeTweets
//
//  Created by DX144-XL on 2015-09-21.
//  Copyright © 2015 Pivotal Labs. All rights reserved.
//

#import <Foundation/Foundation.h>


@class KSPromise;

@interface NetworkManager : NSObject

-(KSPromise *) getTweetsForHashtag: (NSString *) hashtag;

@end
