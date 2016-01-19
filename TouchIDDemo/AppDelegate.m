//
//  AppDelegate.m
//  TouchIDDemo
//
//  Created by 宫城 on 16/1/19.
//  Copyright © 2016年 宫城. All rights reserved.
//

#import <LocalAuthentication/LAContext.h>
#import <LocalAuthentication/LAError.h>
#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    ViewController *rootVC = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootVC];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    [self touchIDAuthentication];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self touchIDAuthentication];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)touchIDAuthentication {
    LAContext *ctx = [[LAContext alloc] init];
    
    NSError *error = nil;
    if ([ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
        [ctx evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过Home键验证已有手机指纹" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                NSLog(@"success");
            }else {
                switch (error.code) {
                    case LAErrorAuthenticationFailed:
                        [self showReslutAlert:@"指纹校验失败"];
                        break;
                    case LAErrorUserCancel:
                        [self showReslutAlert:@"用户取消验证"];
                        break;
                    case LAErrorUserFallback:
                        [self showReslutAlert:@"用户回退"];
                        break;
                    case LAErrorSystemCancel:
                        [self showReslutAlert:@"系统取消"];
                        break;
                    default:
                        break;
                }
            }
        }];
    }else {
        switch (error.code) {
            case LAErrorPasscodeNotSet:
                [self showReslutAlert:@"密码未设置"];
                break;
            case LAErrorTouchIDNotAvailable:
                [self showReslutAlert:@"指纹不正确"];
                break;
            case LAErrorTouchIDNotEnrolled:
                [self showReslutAlert:@"没有录入指纹"];
                break;
            case LAErrorTouchIDLockout:
                [self showReslutAlert:@"TouchID被锁定"];
                break;
            case LAErrorAppCancel:
                [self showReslutAlert:@"App取消验证"];
                break;
            case LAErrorInvalidContext:
                [self showReslutAlert:@"非法的上下文环境"];
                break;
            default:
                break;
        }
    }
}

- (void)showReslutAlert:(NSString *)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:confirm];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

@end
