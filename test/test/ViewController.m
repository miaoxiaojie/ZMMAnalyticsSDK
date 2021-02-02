//
//  ViewController.m
//  test
//
//  Created by 赵苗苗 on 2021/1/28.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *list = @[@3,@4,@7,@2];
    NSMutableArray *muList = [list mutableCopy];
    for (NSInteger i = 0; i< muList.count - 1; i++) {
        
        NSInteger minpos = i;
        for (NSInteger j = i + 1; j < muList.count; j++) {
            minpos = (NSOrderedAscending ==[ muList[j] compare:muList[minpos]] )? j : minpos;

        }
        [muList exchangeObjectAtIndex:i withObjectAtIndex:minpos];
        
    }
    
    NSLog(@"%@",muList);
}


@end
