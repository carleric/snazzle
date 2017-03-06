//
//  AppDelegate.h
//  SnazzleClient
//
//  Created by Carl Bolstad on 3/5/17.
//  Copyright © 2017 Carl Bolstad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

