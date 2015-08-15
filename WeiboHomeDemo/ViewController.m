//
//  ViewController.m
//  WeiboHomeDemo
//
//  Created by Joakim Liu on 15/8/11.
//  Copyright (c) 2015年 Joakim Liu. All rights reserved.
//

#import "ViewController.h"
#import "UINavigationBar+Awesome.h"
#import "Masonry.h"

static NSString *cellIdentitier = @"cellIdentitier";

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
/// table View
@property (nonatomic, strong) UITableView *tableView;
/// 三个数据源数组
@property (nonatomic, strong) NSMutableArray *firstArray;
@property (nonatomic, strong) NSMutableArray *secondArray;
@property (nonatomic, strong) NSMutableArray *thirdArray;
/// 表格头部视图
@property (nonatomic, strong) UIView *theHeadView;
/// 拉伸背景图片
@property (nonatomic, strong) UIImageView *pullImageView;
/// 导航栏顶部 搜索按钮
@property (nonatomic, strong) UIButton *searchButton;
/// 导航栏顶部 更多按钮
@property (nonatomic, strong) UIButton *moreButton;
/// 分组头部视图
@property (nonatomic, strong) UIView *sectionHeadView;
///
@property (nonatomic, assign) NSInteger selectedIndex;
/// 按钮数组
@property (nonatomic, strong) NSMutableArray *buttonArray;
@end

@implementation ViewController

#pragma mark - life cycle
- (void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    [self.tableView removeFromSuperview];
    self.tableView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUp];
    
    self.selectedIndex = 0;
    self.buttonArray = [NSMutableArray array];
    
    // 修改导航栏
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    [navigationBarAppearance setBackgroundColor:[UIColor clearColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - set up subviews
/**
 *  setUp
 */
- (void)setUp {
    
    [self setUpNavRightItems];
    [self setUpTableView];
}

/**
 *  设置导航栏右侧按钮
 */
- (void)setUpNavRightItems {
    self.searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
    [self.searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    [self.searchButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
    [self.moreButton setTitle:@"更多" forState:UIControlStateNormal];
    [self.moreButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.moreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.searchButton],[[UIBarButtonItem alloc] initWithCustomView:self.moreButton]];
}

/**
 *  setUp tableView
 */
- (void)setUpTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentitier];
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0));
    }];
    self.tableView.tableHeaderView = [self theHeadView];
}

/**
 *  headView lazy load
 *
 *  @return return value description
 */
- (UIView *)theHeadView {
    if (!_theHeadView) {
        _theHeadView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), 150.0)];
        _theHeadView.backgroundColor = [UIColor clearColor];
        
        // pull imageview
        self.pullImageView = [UIImageView new];
        self.pullImageView.backgroundColor = [UIColor clearColor];
        [_theHeadView addSubview:self.pullImageView];
        [self.pullImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_theHeadView).insets(UIEdgeInsetsMake(-120.0, 0.0, 0.0, 0.0));
        }];
        self.pullImageView.image = [UIImage imageNamed:@"HomeBg.jpg"];
        
        // head imageview
        UIImageView *headImageView = [UIImageView new];
        headImageView.backgroundColor = [UIColor clearColor];
        [_theHeadView addSubview:headImageView];
        [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_theHeadView.mas_top).offset(20.0);
            make.centerX.equalTo(_theHeadView.mas_centerX);
            make.width.equalTo(@60.0);
            make.height.equalTo(@60.0);
        }];
        headImageView.layer.cornerRadius = 60.0 / 2.0;
        headImageView.layer.borderWidth = 2.0;
        headImageView.layer.borderColor = [[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00] CGColor];
        headImageView.contentMode = UIViewContentModeScaleAspectFill;
        headImageView.layer.masksToBounds = YES;
        headImageView.image = [UIImage imageNamed:@"KGHead.jpg"];
        
        // name label
        UILabel *nameLabel = [UILabel new];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont boldSystemFontOfSize:16.0];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [_theHeadView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headImageView.mas_bottom).offset(5.0);
            make.centerX.equalTo(_theHeadView.mas_centerX);
            make.width.equalTo(_theHeadView.mas_width);
            make.height.equalTo(@20.0);
        }];
        nameLabel.text = @"牛易疯先森";
        
        // info label
        UILabel *infoLabel = [UILabel new];
        infoLabel.backgroundColor = [UIColor clearColor];
        infoLabel.font = [UIFont systemFontOfSize:12.0];
        infoLabel.textColor = [UIColor whiteColor];
        infoLabel.textAlignment = NSTextAlignmentCenter;
        [_theHeadView addSubview:infoLabel];
        [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_bottom).offset(5.0);
            make.centerX.equalTo(nameLabel.mas_centerX);
            make.width.equalTo(nameLabel.mas_width);
            make.height.equalTo(nameLabel.mas_height);
        }];
        infoLabel.text = @"简介:你不解决问题，就会成为问题。iOS菜逗一枚。";
    }
    
    return _theHeadView;
}

/**
 *  sectionHeadView lazy load
 *
 *  @return <#return value description#>
 */
- (UIView *)sectionHeadView {
    if (!_sectionHeadView) {
        _sectionHeadView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), 40.0)];
        _sectionHeadView.backgroundColor = [UIColor colorWithRed:0.90 green:0.89 blue:0.84 alpha:1.00];
        _sectionHeadView.userInteractionEnabled = YES;
        
        
        [self.buttonArray removeAllObjects];
        UIColor *normalColor = [UIColor grayColor];
        UIColor *selectedColor = [UIColor blackColor];
        CGFloat btnHeight = 30.0, btnWidth = 60.0, space = 10.0;
        // 微博按钮
        UIButton *WBButton = [UIButton new];
        [_sectionHeadView addSubview:WBButton];
        [self.buttonArray addObject:WBButton];
        WBButton.tag = 101;
        [WBButton setTitle:@"微博" forState:UIControlStateNormal];
        [WBButton setTitleColor:normalColor forState:UIControlStateNormal];
        [WBButton setTitleColor:selectedColor forState:UIControlStateSelected];
        [WBButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [WBButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_sectionHeadView.mas_centerX);
            make.centerY.equalTo(_sectionHeadView.mas_centerY);
            make.width.equalTo(@(btnWidth));
            make.height.equalTo(@(btnHeight));
        }];
        
        // 主页按钮
        UIButton *ZYButton = [UIButton new];
        [_sectionHeadView addSubview:ZYButton];
        [self.buttonArray addObject:ZYButton];
        ZYButton.tag = 100;
        [ZYButton setTitle:@"主页" forState:UIControlStateNormal];
        [ZYButton setTitleColor:normalColor forState:UIControlStateNormal];
        [ZYButton setTitleColor:selectedColor forState:UIControlStateSelected];
        [ZYButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [ZYButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_sectionHeadView.mas_centerY);
            make.right.equalTo(WBButton.mas_left).offset(-space);
            make.width.equalTo(WBButton.mas_width);
            make.height.equalTo(WBButton.mas_height);
        }];
        
        // 相册按钮
        UIButton *XCButton = [UIButton new];
        [_sectionHeadView addSubview:XCButton];
        [self.buttonArray addObject:XCButton];
        XCButton.tag = 102;
        [XCButton setTitle:@"相册" forState:UIControlStateNormal];
        [XCButton setTitleColor:normalColor forState:UIControlStateNormal];
        [XCButton setTitleColor:selectedColor forState:UIControlStateSelected];
        [XCButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [XCButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_sectionHeadView.mas_centerY);
            make.left.equalTo(WBButton.mas_right).offset(space);
            make.width.equalTo(WBButton.mas_width);
            make.height.equalTo(WBButton.mas_height);
        }];
        
        // line label
        UILabel *lineLabel = [UILabel new];
        lineLabel.backgroundColor = normalColor;
        [_sectionHeadView addSubview:lineLabel];
        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_sectionHeadView.mas_bottom).offset(-0.5);
            make.width.equalTo(_sectionHeadView.mas_width);
            make.height.equalTo(@0.5);
        }];
        
        [self buttonClicked:ZYButton];
    }
    
    return _sectionHeadView;
}

#pragma mark - tableview dataSource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.selectedIndex + 1) * 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self sectionHeadView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentitier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ row%@",self.selectedIndex > 1 ? @"相册" : (self.selectedIndex > 0 ? @"微博" : @"主页"),@(indexPath.row+1)];
    return cell;
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat heightNavbar = 30.0;
    UIColor *color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    if (offsetY > heightNavbar) {
        CGFloat alpha = MIN(1, 1 - ((heightNavbar + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        
        self.title = @"牛易疯先森";
        [self.searchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        
        self.title = @"";
        [self.searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.moreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

#pragma mark - Button Response Method
- (void)buttonClicked:(UIButton *)sender {
    for (UIButton *button in self.buttonArray) {
        button.selected = NO;
        if (button.tag == sender.tag) {
            button.selected = YES;
        }
    }
    self.selectedIndex = sender.tag - 100;
    [self.tableView reloadData];
}

@end
