//
//  ViewController.m
//  TwitterLogin
//
//  Created by Tong on 2023/1/19.
//

#import "ViewController.h"
#import "TwitterLoagin.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [TwitterLoagin twitterRequestWithViewController:self Complet:^(BOOL success, NSDictionary * _Nullable dic, NSError * _Nullable error) {
        
    }];
}


@end
