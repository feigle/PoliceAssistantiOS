//
//  LHDCusstomAlbumGroupView.m
//  LHDCusstomAlbumAndCamera
//
//  Created by 秦沙沙 on 16/3/20.
//  Copyright © 2016年 刘和东. All rights reserved.
//

#import "LHDCusstomAlbumGroupView.h"
#import "LHDCusstomAlbumGroupTableViewCell.h"
#import "LHDAlbumAssetsManager.h"
#import "LHDPopView.h"

@interface LHDCusstomAlbumGroupView ()<UITableViewDataSource,UITableViewDelegate>

{
    LHDCusstomAlbumGroupModel * _albumGroupModel;
}
@property (nonatomic, strong) UITableView * tableView;

/**
 *  里面保存的是相册组
 */
@property (nonatomic , strong) NSArray * albumGroups;

@property (nonatomic, copy) SelectAlbumGroupBlock selectBlock;

@property (nonatomic, strong) NSIndexPath * selectIndexPath;




@end

@implementation LHDCusstomAlbumGroupView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        [self configCusstomAlbumGroupViewUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self configCusstomAlbumGroupViewUI];
    }
    return self;
}

- (void)configCusstomAlbumGroupViewUI
{
    [self addSubview:self.tableView];
    [self getAlbumGroupsData];
}


/**
 *  初始化相册数据
 */
- (void)getAlbumGroupsData
{
    LHDAlbumAssetsManager * manager = [LHDAlbumAssetsManager defaultAlbum];
    __weak typeof(self) weakSelf = self;
    [manager getAllGroupWithAlbums:^(id objc) {
        weakSelf.albumGroups = (NSArray *)objc;
        weakSelf.groupNumber = weakSelf.albumGroups.count;
        if (weakSelf.albumGroups.count > 6) {
            weakSelf.groupNumber = 6;
        }
        [weakSelf choseFirstShowPhotosGroup];
    }];
}

- (void)setLastChoseGroupName:(NSString *)lastChoseGroupName
{
    _lastChoseGroupName = lastChoseGroupName;
    if (_lastChoseGroupName) {
        LHDCusstomAlbumGroupModel * gp = nil;
        for (LHDCusstomAlbumGroupModel *group in self.albumGroups) {
            if ([group.groupName isEqualToString:lastChoseGroupName]) {
                gp = group;
                break;
            }
        }
        if (!gp) {
            return;
        }
        _albumGroupModel = gp;
        [self.tableView reloadData];
        self.selectBlock(gp);
    }
}

/**
 *  选择第一个要展示的组
 */
- (void)choseFirstShowPhotosGroup
{
    LHDCusstomAlbumGroupModel * gp = nil;
    NSInteger photoNumber = 0;
    for (LHDCusstomAlbumGroupModel *group in self.albumGroups) {
        if (group.assetsCount > photoNumber) {
            photoNumber = group.assetsCount;
            gp = group;
        }
//        if ([group.groupName isEqualToString:@"Camera Roll"] || [group.groupName isEqualToString:@"相机胶卷"]) {
//            gp = group;
//            break;
//        }else if ([group.groupName isEqualToString:@"Saved Photos"] || [group.groupName isEqualToString:@"保存相册"]){
//            gp = group;
//            break;
//        }else if ([group.groupName isEqualToString:@"Stream"] || [group.groupName isEqualToString:@"我的照片流"]){
//            gp = group;
//            break;
//        }
    }
    if (gp == nil) {
        return;
    }
    _albumGroupModel = gp;
    [self.tableView reloadData];
    
    if (self.selectBlock) {
        self.selectBlock(gp);
    }
}


- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.delegate = self;
        _tableView.userInteractionEnabled = YES;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tableView.height = self.height;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.albumGroups.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LHDCusstomAlbumGroupTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LHDCusstomAlbumGroupTableViewCell"];
    if (cell == nil) {
        cell = [[LHDCusstomAlbumGroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NDCusstomAlbumGroupTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    LHDCusstomAlbumGroupModel * gModel = _albumGroups[indexPath.row];
    
    if (_albumGroupModel) {
        if ([_albumGroupModel.groupName isEqualToString:gModel.groupName]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.selectIndexPath = indexPath;
            _albumGroupModel = nil;
        }
    }
    cell.groupModel = _albumGroups[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == self.selectIndexPath.row) {
        [LHDPopView dismiss];
        return;
    }
    
    LHDCusstomAlbumGroupTableViewCell * cell = [tableView cellForRowAtIndexPath:self.selectIndexPath];
    //UITableViewCellAccessoryNone  UITableViewCellAccessoryCheckmark
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    LHDCusstomAlbumGroupTableViewCell * celld = [tableView cellForRowAtIndexPath:indexPath];

    celld.accessoryType = UITableViewCellAccessoryCheckmark;

    self.selectIndexPath = indexPath;
    LHDCusstomAlbumGroupModel * allbumGrou = _albumGroups[indexPath.row];
    if (self.selectBlock) {
        self.selectBlock(allbumGrou);
    }
}

- (void)selectedAlbumGroupBlock:(SelectAlbumGroupBlock)block
{
    self.selectBlock = block;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
