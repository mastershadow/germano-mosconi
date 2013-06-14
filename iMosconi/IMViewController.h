//
//  IMViewController.h
//  iMosconi
//
//  Created by Eduard Roccatello on 13/06/13.
//  Copyright (c) 2013 Eduard Roccatello. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface IMViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *audioFiles;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end
