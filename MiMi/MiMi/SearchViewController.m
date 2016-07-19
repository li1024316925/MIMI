//
//  SearchViewController.m
//  MiMi
//
//  Created by LLQ on 16/7/18.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"

@interface SearchViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_searchTableView;
}
@property(nonatomic, strong)NSMutableArray *dataList;

@end

@implementation SearchViewController

//视图即将显示
- (void)viewWillAppear:(BOOL)animated{
    //从本地查询
    NSError *error;
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/searchHistory.json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (data) {
        self.dataList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    }
}

//视图即将消失
- (void)viewWillDisappear:(BOOL)animated{
    //数据本地化
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.dataList options:NSJSONWritingPrettyPrinted error:&error];
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/searchHistory.json"];
    //存储到本地
    [data writeToFile:filePath atomically:YES];
}

//懒加载
- (NSMutableArray *)dataList{
    if (_dataList == nil) {
        _dataList = [[NSMutableArray alloc] init];
        //存储历史记录
        NSMutableArray *historyArr = [[NSMutableArray alloc] init];
        [_dataList addObject:historyArr];
        //存储热门
        NSMutableArray *hotArr = [[NSMutableArray alloc] init];
        [_dataList addObject:hotArr];
    }
    
    return _dataList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    //加载导航栏控件
    [self loadNaviItem];
    
    //加载表视图
    [self loadTableView];
    
}

//加载表视图
- (void)loadTableView{
    
    //创建表视图
    _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    _searchTableView.sectionHeaderHeight = 50;
    //注册头视图
    [_searchTableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"headerView"];
    
    [self.view addSubview:_searchTableView];
    
}

//修改导航栏
- (void)loadNaviItem{
    
    //右侧按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]} forState:UIControlStateNormal];
    
    //左侧搜索条
    //背景视图
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.layer.cornerRadius = 5;
    searchView.clipsToBounds = YES;
    //搜索小图标
    UIImageView *searchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    searchIcon.image = [UIImage imageNamed:@"search_icon_6P"];
    [searchView addSubview:searchIcon];
    //输入框
    UITextField *searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(27, 5, 300-22, 20)];
    searchTextField.borderStyle = UITextBorderStyleNone;
    searchTextField.placeholder = @"搜索";
    searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;   //不进行自动矫正
    searchTextField.enablesReturnKeyAutomatically = YES;   //输入为空时return不得点击
    searchTextField.delegate = self;
    [searchView addSubview:searchTextField];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:searchView];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

//右侧按钮点击方法
- (void)rightBarButtonItemAction{
    
    //返回根视图控制器
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


#pragma mark ------ UITextFieldDelegate

//点击return时调用
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    //添加数据
    NSMutableArray *historyArr = self.dataList[0];
    [historyArr addObject:textField.text];
    
    //清空输入框
    textField.text = @"";
    
    //刷新表视图
    [_searchTableView reloadData];
    
    return YES;
    
}


#pragma mark ------ UITableViewDataSource和UITableViewDelegate

//返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataList.count;
    
}

//返回每组单元格数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSMutableArray *array = _dataList[section];
    
    return array.count;
    
}

//返回单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //单元格复用
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.deleteBtn addTarget:self action:@selector(cellDeleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //属性赋值
    NSMutableArray *array = self.dataList[indexPath.section];
    cell.titleLabel.text = array[indexPath.row];
    cell.deleteBtn.tag = 100 + indexPath.row;
    
    return cell;
    
}

//返回组头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    //头视图复用
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    if (section == 0) {
        headerView.textLabel.text = @"历史";
    }else if (section == 1){
        headerView.textLabel.text = @"热门";
    }
    
    return headerView;
    
}


#pragma mark ------ 单元格删除按钮点击方法

- (void)cellDeleteBtnAction:(UIButton *)btn{
    
    //通过tag值删除数据数组中的数据
    NSMutableArray *array = _dataList[0];
    if (btn.tag-100<array.count) {
        [array removeObjectAtIndex:btn.tag-100];
        //删除单元格
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag-100 inSection:0];
        [_searchTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
    //刷新第0组表视图
    [_searchTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    
}

@end
