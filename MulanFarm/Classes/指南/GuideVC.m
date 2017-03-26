//
//  GuideVC.m
//  MulanFarm
//
//  Created by zyl on 17/3/9.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "GuideVC.h"
#import "Articleinfo.h"
#import "SDCycleScrollView.h"

@interface GuideVC ()<SDCycleScrollViewDelegate>
{
    NSMutableArray *_picArray; //图片轮播数组
    NSMutableArray *_dataArr; //列表数组
    SDCycleScrollView *_cycleScrollView;
}
@end

@implementation GuideVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"指南";
    
    _picArray = [NSMutableArray array];
    _dataArr = [NSMutableArray array];

    [self getData];
}

- (void)getData {
    
    NSDictionary *dic = [NSDictionary dictionary];
    [[NetworkManager sharedManager] postJSON:URL_ArticleList parameters:dic completion:^(id responseData, RequestState status, NSError *error) {
        
        if (status == Request_Success) {
            
            [_picArray removeAllObjects];
            [_dataArr removeAllObjects];
            
            NSMutableArray *array = [Articleinfo mj_objectArrayWithKeyValuesArray:(NSArray *)responseData];
            
            for (int i = 0; i<array.count; i++) {
                Articleinfo *info = array[i];
                if ([info.type isEqualToString:@"image"]) {
                    [_picArray addObject:info];
                } else {
                    [_dataArr addObject:info];
                }
            }
            
            [_guideTableView reloadData];
        }
    }];
}

#pragma mark - UITableView 代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor clearColor];
    
    //图片轮播
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, 200) delegate:self placeholderImage:nil];
    _cycleScrollView.backgroundColor = PageColor;
    
    NSMutableArray *picArr = [NSMutableArray array];
    for (int i = 0; i<_picArray.count; i++) {
        Articleinfo *info = _picArray[i];
        [picArr addObject:info.thumbnail];
    }
    _cycleScrollView.imageURLStringsGroup = picArr;
    _cycleScrollView.delegate = self;
    _cycleScrollView.infiniteLoop = NO; //关闭无限循环
    _cycleScrollView.autoScroll = NO; //关闭自动滚动
    _cycleScrollView.pageDotColor = [UIColor grayColor]; //分页控件小圆标颜色
    _cycleScrollView.currentPageDotColor = AppThemeColor;
    _cycleScrollView.pageControlDotSize = CGSizeMake(2, 2); //分页控件小圆标大小
    _cycleScrollView.showPageControl = YES;
    [header addSubview:_cycleScrollView];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 200.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Articleinfo *info = _dataArr[indexPath.row];
    cell.textLabel.text = info.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //取消选择状态
    
    Articleinfo *info = _dataArr[indexPath.row];
    
    [BaseWebVC showWithContro:self withUrlStr:info.detailUrl withTitle:@"指南详情" isPresent:NO];
}

#pragma mark - SDCycleScrollViewDelegate

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    Articleinfo *info = _picArray[index];
    
    [BaseWebVC showWithContro:self withUrlStr:info.detailUrl withTitle:@"指南详情" isPresent:NO];
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
