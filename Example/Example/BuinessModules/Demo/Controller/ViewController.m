//
//  ViewController.m
//  Example
//
//  Created by 赵苗苗 on 2021/1/16.
//

#import "ViewController.h"
#import "ZMMAdefaultData.h"
#import <ZMMAnalyticsSDK/ZMMAnalyticsSDK.h>

@interface ViewController ()<
UITableViewDataSource,
UITableViewDelegate>

///tableView
@property (nonatomic ,strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_drawViews];
    [self p_setAllViesFrame];
    
}

#pragma mark - Private

- (void)p_drawViews
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                    style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.rowHeight = 44.0;
    _tableView.backgroundColor =  [UIColor clearColor];
    [_tableView setSeparatorColor:[UIColor colorWithWhite:255/255 alpha:0.2]];
    [self.view addSubview:_tableView];
}

- (void)p_setAllViesFrame
{
    [_tableView setFrame:CGRectMake(0, 84, self.view.bounds.size.width, self.view.bounds.size.height - 84)];
}

#pragma mark -UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ZMMAdefaultData getDefaultTestData].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"DemoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.textLabel.text = [[ZMMAdefaultData getDefaultTestData] objectAtIndex:indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [[ZMMAnalyticsSDK sharedInstance] track:@"testTrack" withProperties:@{@"testName":@"testTrack 测试"}];
            
            break;
            
        default:
            break;
    }
    
}



@end
