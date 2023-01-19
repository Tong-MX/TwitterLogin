# TwitterLogin
Twitter登录集成
Twitter登录集成
1.申请Twitter账号
2.创建应用
3.获取应用编号
4.配置相关信息
5.xcode配置
6.代码集成

一、创建应用
1.需要登录Twitter开发者平台申请 https://developer.twitter.com/en/portal/dashboard
2.然后添加iOS平台 - 填写应用名称 - 创建应用编号 - 为应用添加产品，然后到设置中完善相关信息，然后保存，配置Bundle ID，这些都是按照流程一步步填写就可以了
3.配置完成之后你就可以得到xcode中info.plist文件中的配置信息
info.plist填写分成二部分
第一部分填写
URL types 填写自己对应的ID
![image.png](https://upload-images.jianshu.io/upload_images/1954867-c6ec2df0674d8ce5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
第二部分填写
白名单
![image.png](https://upload-images.jianshu.io/upload_images/1954867-62aeb162f18c6715.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

二、xcode配置（接入SDK）
加载安装包 pod 'TwitterKit', '~> 3.4.2' （这里有坑后边会说到）

三、代码集成
1.Appdelegate中
```
///从Twitter获得的 Appkey 和 AppSecret 放在里面
#import <TwitterKit/TWTRKit.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ///在appdelegate 配置
    [[TWTRTwitter sharedInstance] startWithConsumerKey:@"Appkey" consumerSecret:@"AppSecret"];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([url.scheme hasPrefix:@"twitter"]) {
        return [[Twitter sharedInstance] application:app openURL:url options:options];
    } 
    return false;
}
```
可以管理一个Manager去维护Twitter登录逻辑
```
#import <TwitterKit/TWTRKit.h>

@implementation BBLTwitterLogin
+ (void)twitterRequestWithViewController:(UIViewController *)viewController
                                 Complet:(void(^)(BOOL success, NSDictionary *__nullable dic, NSError *__nullable error))complete {
    TWTRTwitter *tw = [TWTRTwitter sharedInstance];
    [tw logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            NSLog(@"userName  = %@", [session userName]);
            NSLog(@"userID  = %@", [session userID]);
            NSLog(@"authToken  = %@", [session authToken]);
            NSLog(@"authTokenSecret  = %@", [session authTokenSecret]);
            NSString *userId = [session userID];
            NSString *userName = [session userName];
            TWTRAPIClient *client = [[TWTRAPIClient alloc] initWithUserID:userId];
          ///根据需要获取对应的信息
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
```
以上是集成的方法。到这里基本集成完成 并且如果你的key 和 secret 都没有错应该会唤起Twitter的登录但是前面说的坑在这里都是体现不出来的 因为Twitter是集成了UIWebview的 所以审核时会被拒解决办法就是替换掉Twitterkit 网上也有如何检测 检测项目中是否包含UIWebView
这个是完整简介https://www.jianshu.com/p/9c1507509896

#### 替换TwitterKit
在pod文件中，把 `pod 'TwitterKit'` 替换为 `pod 'TwitterKit5'`
进入TwitterSDK的github地址 [https://github.com/twitter-archive/twitter-kit-ios/issues/120](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Ftwitter-archive%2Ftwitter-kit-ios%2Fissues%2F120)，

代码传送



