//
//  IMViewController.m
//  iMosconi
//
//  Created by Eduard Roccatello on 13/06/13.
//  Copyright (c) 2013 Eduard Roccatello. All rights reserved.
//

#import "IMViewController.h"
#define AUDIO_DIR @"audio"

@interface IMViewController ()

@end

@implementation IMViewController

- (void) enumerateAudioFiles {
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString * documentsPath = [resourcePath stringByAppendingPathComponent:AUDIO_DIR];
    NSError *error;
    NSArray *directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath
                                                                                     error:&error];
    
    self.audioFiles = [directoryContents sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (void) playAudio:(NSUInteger)row {
    
    NSString *audioFile = [self.audioFiles objectAtIndex:row];
	NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@/%@",
                                         [[NSBundle mainBundle] resourcePath],
                                         AUDIO_DIR,
                                         audioFile]];
	
	NSError *error;
    if (self.audioPlayer != nil) {
        [self stopPlay];
    }
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.audioPlayer.numberOfLoops = 0;
    self.audioPlayer.volume = 1.0;
    self.audioPlayer.delegate = self;
    
	if (self.audioPlayer == nil) {
		NSLog(@"%@", [error description]);
    } else {
		[self.audioPlayer play];
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopPlayAndHide)];
}

- (void) stopPlayAndHide {
    [self stopPlay];
    self.navigationItem.leftBarButtonItem = nil;
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];    
}

- (void) stopPlay {
    [self.audioPlayer stop];
    self.audioPlayer = nil;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self stopPlay];
    self.navigationItem.leftBarButtonItem = nil;
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self enumerateAudioFiles];
    
    self.title = NSLocalizedString(@"main.title", @"Main title");
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoButton addTarget:self action:@selector(infoButtonAction) forControlEvents:UIControlEventTouchUpInside];
	[self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:infoButton]
                                     animated:YES];
}

- (void) infoButtonAction {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"about.title", @"About Title")
                                                        message:NSLocalizedString(@"about.message", @"About Message")
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    NSString *audioFile = [[[[self.audioFiles objectAtIndex:indexPath.row]
                                stringByDeletingPathExtension]
                                stringByReplacingOccurrencesOfString:@"_" withString:@" "]
                                capitalizedString];
    [[cell textLabel] setText:audioFile];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self playAudio:indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.audioFiles count];
}

@end
