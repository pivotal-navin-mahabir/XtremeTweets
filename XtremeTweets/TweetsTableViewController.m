//
//  TweetsTableViewController.m
//  XtremeTweets
//
//  Created by DX144-XL on 2015-09-21.
//  Copyright © 2015 Pivotal Labs. All rights reserved.
//

#import "TweetsTableViewController.h"
#import "TweetTableViewCell.h"
#import "NetworkManager.h"
#import "KSPromise.h"
#import "Tweet.h"

@interface TweetsTableViewController ()

@property (nonatomic) NSArray *tweets;
@property (nonatomic) NetworkManager * networkManager;
@end

@implementation TweetsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.networkManager = [[NetworkManager alloc] init];
    [[self.networkManager getTweetsForHashtag:@"flyingtoaster0"] then:^id(NSArray * tweets) {
        self.tweets = tweets;
        [self.tableView reloadData];
        return nil;
    } error:^id(NSError *error) {
        UIAlertController * errorAlert = [UIAlertController alertControllerWithTitle: @"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:errorAlert animated:YES completion:nil];
        return nil;
    }];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.tweets.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCellId" forIndexPath:indexPath];
    cell.ProfileImageView.image=[UIImage imageNamed:@"Face"];
    cell.ContentLabelView.text=((Tweet *)self.tweets[indexPath.row]).status;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak TweetsTableViewController * weakSelf = self;
    [[self.networkManager getTweetsForHashtag:@"%23drake"] then:^id(NSArray * tweets) {
       weakSelf.tweets = tweets;
       [weakSelf.tableView reloadData];
       return nil;
    } error:^id(NSError *error) {
        UIAlertController * errorAlert = [UIAlertController alertControllerWithTitle: @"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        [weakSelf presentViewController:errorAlert animated:YES completion:nil];
        return nil;
    }];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
