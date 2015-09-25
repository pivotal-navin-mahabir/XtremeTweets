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
#import <CommonCrypto/CommonHMAC.h>
#import "Tweet.h"

@interface NetworkManager ()
@property (nonatomic) NSString * bearerToken;
@end

@implementation NetworkManager

static NSString * const BaseURLString = @"https://api.twitter.com";
static NSString * const ConsumerKey = @"wjUEkfJCBwcWS6aPLIpuqJTij";
static NSString * const ConsumerSecret = @"EZX665Sxap8TR94SJO6jEOWgd8FAXDMJNQAIDjgHUrlKD42zKz";
static NSString * const AccessToken = @"2975142664-HTI2PcaRB8fBHaIfyTND1ySyqsbKZKlHgrNZv0n";
static NSString * const AccessTokenSecret = @"I8z8BqcLY4z8nIYc87KRU0nvxv3SiKOQacaWPSY5n16uP";
static NSString * const letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

- (instancetype)init {
    self = [super init];
    if (self) {
        self.bearerToken=[self getBearerToken];
    }
    return self;
}

- (KSPromise *)getTweetsForHashtag:(NSString *) hashtag {
    __block KSDeferred * deferred = [KSDeferred defer];
    __weak NetworkManager * weakself=self;
    hashtag = [self URLEncodedString_ch: hashtag];
    if(self.bearerToken==nil) {
        NSURLRequest *request = [self constructBearerRequest];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        //success/fail block
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * responseDictionary = responseObject;
            if(responseDictionary[@"access_token"]){
                weakself.bearerToken = [responseDictionary valueForKey:@"access_token"];
                [[weakself fetchTweetsFromHashtag:hashtag]
                then:^id(NSArray * tweets) {
                    [deferred resolveWithValue:tweets];
                    return tweets;
                } error:^id(NSError *error) {
                    [deferred rejectWithError:error];
                    return error;
                }];
            } else {
                weakself.bearerToken = nil;
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            weakself.bearerToken = nil;
            [deferred rejectWithError:error];
        }];
        
        [operation start];
    } else {
        [[weakself fetchTweetsFromHashtag:hashtag]
         then:^id(NSArray * tweets) {
             [deferred resolveWithValue:tweets];
             return tweets;
         } error:^id(NSError *error) {
             [deferred rejectWithError:error];
             return error;
         }];
    }
    return deferred.promise;
}


#pragma mark - Private Helper methods

- (NSString *) getBearerToken {
    NSURLRequest *request = [self constructBearerRequest];
    __block  NSString *bearerToken;
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    //success/fail block
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * responseDictionary = responseObject;
        if(responseDictionary[@"access_token"]){
            bearerToken = [responseDictionary valueForKey:@"access_token"];
        }
        else{
            bearerToken = nil;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        bearerToken = nil;
    }];
    return bearerToken;
}

- (NSMutableURLRequest *) constructBearerRequest{
    //creating the url
    NSString *postString = [NSString stringWithFormat: @"%@/oauth2/token", BaseURLString];
    NSURL *postUrl = [NSURL URLWithString: postString];
    //encoding the keys
    NSString *encodedKeyConsumer = [self URLEncodedString_ch:ConsumerKey];
    NSString *encodedSecretConsumer = [self URLEncodedString_ch:ConsumerSecret];
    NSData *basicData = [[NSString stringWithFormat:@"%@:%@", encodedKeyConsumer, encodedSecretConsumer] dataUsingEncoding:NSUTF8StringEncoding];
    basicData = [basicData base64EncodedDataWithOptions:0];
    NSString *basic = [NSString stringWithFormat: @"Basic %@Content-Type: application/x-www-form-urlencoded;charset=UTF-8",[[NSString alloc] initWithData:basicData encoding:NSUTF8StringEncoding]];
    NSData *postData = [@"grant_type=client_credentials" dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    //creating the request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:postUrl];
    [request setHTTPMethod:@"POST"];
    [request setValue:basic forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:postData];
    return request;
}
- (NSString *) URLEncodedString_ch:(NSString *) key {
    NSMutableString * output = [NSMutableString string];
    const unsigned char * source = (const unsigned char *)[key UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

- (KSPromise *)fetchTweetsFromHashtag:(NSString *) hashtag {
    __block KSDeferred * deferred = [KSDeferred defer];
    //formatting url request
    NSString *string = [NSString stringWithFormat: @"%@/1.1/search/tweets.json?q=%@", BaseURLString, hashtag];
    NSURL *searchUrl = [NSURL URLWithString:string];
    
    //creating the request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:searchUrl];
    [request setHTTPMethod:@"GET"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@",self.bearerToken] forHTTPHeaderField:@"Authorization"];
    
    __block  NSString *bearerToken;
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    //success/fail block
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * responseDictionary = responseObject;
        NSArray * tweets = [self parseTweetsFromResponse: responseDictionary];
        [deferred resolveWithValue:tweets];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [deferred rejectWithError:error];
    }];
    
    [operation start];
   
    return deferred.promise;
}

- (NSArray *)parseTweetsFromResponse:(NSDictionary *) responseDictionary {
    NSMutableArray * tweets = [[NSMutableArray alloc] init];
    NSString * tempStatus;
    NSString * tempURL;
    NSArray * rawData = [responseDictionary valueForKey:@"statuses"];
    for (NSDictionary * dictionary in rawData) {
        if (dictionary[@"text"]){
            tempStatus = [dictionary valueForKey:@"text"];
            //tempURL = [[dictionary valueForKey:@"user"]valueForKey:@"profile_image_url"];
            tempURL = [[dictionary valueForKey:@"user"]valueForKey:@"screen_name"];
            Tweet * newTweet = [[Tweet alloc] init];
            [newTweet setUpWithStatus:tempStatus andImage:tempURL];
            [tweets addObject:newTweet];
        }
    }
    return tweets;
}
@end
