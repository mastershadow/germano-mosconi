//
//  IMAppDelegate.h
//  iMosconi
//
//  Created by Eduard Roccatello on 13/06/13.
//  Copyright (c) 2013 Eduard Roccatello. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMViewController;

@interface IMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) IMViewController *viewController;

@end
