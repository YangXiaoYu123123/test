//
//  ViewController.m
//  test
//
//  Created by xiaoyu on 2018/2/8.
//  Copyright © 2018年 xiaoyu. All rights reserved.
//

#import "ViewController.h"
#import "routePlanViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"地图详情";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard * loginSB   = [UIStoryboard storyboardWithName:@"job" bundle:[NSBundle mainBundle]];
    routePlanViewController * vc  = [loginSB instantiateViewControllerWithIdentifier:@"routePlanVC"];
    vc.endAddress = @"hahaha";
    vc.coordinate = CLLocationCoordinate2DMake(39.984304, 116.498011);
    [self.navigationController pushViewController:vc animated:YES];
}

@end
