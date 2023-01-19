//
//  TwitterLoagin.m
//  TwitterLogin
//
//  Created by Tong on 2023/1/19.
//

#import "TwitterLoagin.h"
#import <TwitterKit/TWTRKit.h>

@implementation TwitterLoagin
+ (void)twitterRequestWithViewController:(UIViewController *)viewController
                                 Complet:(void(^)(BOOL success, NSDictionary *__nullable dic, NSError *__nullable error))complete {
    TWTRTwitter *tw = [TWTRTwitter sharedInstance];
    [tw logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
//            complete(YES, @{@"authToken": session.authToken, @"authTokenSecret": [session authTokenSecret]}, nil);
            NSLog(@"userName  = %@", [session userName]);
            NSLog(@"userID  = %@", [session userID]);
            NSLog(@"authToken  = %@", [session authToken]);
            NSLog(@"authTokenSecret  = %@", [session authTokenSecret]);
            NSString *userId = [session userID];
            NSString *userName = [session userName];
            TWTRAPIClient *client = [[TWTRAPIClient alloc] initWithUserID:userId];
            [client loadUserWithID:userId completion:^(TWTRUser * _Nullable user, NSError * _Nullable error) {
                NSLog(@"%@, %@", userId,user.profileURL.absoluteString);
                complete(YES, @{@"authToken": session.authToken,
                                @"authTokenSecret": [session authTokenSecret],
                                @"userName": userName.length > 0 ? userName : @"",
                                @"userID": userId.length > 0 ? userId : @""}, nil);
            }];
            [client requestEmailForCurrentUser:^(NSString * _Nullable email, NSError * _Nullable error) {
                NSLog(@"推特邮箱:%@",email);
            }];
        } else {
            complete(NO, @{}, nil);
        }
    }];
}
@end
