//
//  TwitterLoagin.h
//  TwitterLogin
//
//  Created by Tong on 2023/1/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TwitterLoagin : NSObject
+ (void)twitterRequestWithViewController:(UIViewController *)viewController
                                 Complet:(void(^)(BOOL success, NSDictionary *__nullable dic, NSError *__nullable error))complete;
@end

NS_ASSUME_NONNULL_END
