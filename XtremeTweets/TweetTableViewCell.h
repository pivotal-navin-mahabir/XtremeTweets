//
//  TweetTableViewCell.h
//  XtremeTweets
//
//  Created by DX144-XL on 2015-09-21.
//  Copyright © 2015 Pivotal Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *ContentLabelView;

@end
