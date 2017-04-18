//
//  LHDCusstomAlbumAssetsViewController.m
//  LHDCusstomAlbumAndCamera
//
//  Created by 秦沙沙 on 16/3/10.
//  Copyright © 2016年 刘和东. All rights reserved.
//

#import "LHDCusstomAlbumAssetsViewController.h"
#import "LHDCusstomAlbumAssetsCollectionViewCell.h"
#import "LHDAlbumAssetsManager.h"
#import "LHDCusstomAlbumAssetsModel.h"
#import "LHDPopView.h"
#import "LHDCusstomAlbumGroupView.h"
#import "LHDChoseGroupTitleView.h"
#import "AppDelegate.h"
#import "LHDCusstomCameraViewController.h"
#import "LHDEditPhotoViewController.h"

static CGFloat CELL_ROW = 4;
static CGFloat CELL_MARGIN = 2;
static CGFloat CELL_LINE_MARGIN = 2;
static CGFloat TOOLBAR_HEIGHT = 49;


@interface LHDCusstomAlbumAssetsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    LHDChoseGroupTitleView * _choseGroupView;
    BOOL isFirstShow;
}
///**
// *  里面保存的是相册组
// */

@property (nonatomic, strong) NSMutableArray * imageDataArray;

@property (nonatomic, strong) UICollectionView * collectionView;

/**
 *  当前展示图片的组
 */
@property (nonatomic, strong) LHDCusstomAlbumGroupModel * albumGroup;

@property (nonatomic, strong) LHDCusstomAlbumGroupView * groupView;

@property (nonatomic, copy) GetAlbumThumImageAndOriginImageBlock  getImageArrBlock;

@end

@implementation LHDCusstomAlbumAssetsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.editWideHighRatio = 0.56;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _imageDataArray = [NSMutableArray array];
    //    self.maxCount = 1;
    
    [self configAlbumAssetsVC];
}

- (void)setLastGroupName:(NSString *)lastGroupName
{
    _lastGroupName = lastGroupName;
    if (_lastGroupName) {
        self.groupView.lastChoseGroupName = lastGroupName;
    }
}

- (NSMutableArray *)selectedImageArray
{
    if (!_selectedImageArray) {
        _selectedImageArray = [NSMutableArray array];
    }
    return _selectedImageArray;
}

#pragma mark - 选择完了照片
- (void)completClicked
{
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    if (!self.getImageArrBlock) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    if (self.selectedImageArray.count == 0) {
        self.getImageArrBlock(nil,nil,nil,nil,NO);
    } else {
        if (self.isNeedEditPhoto && self.selectedImageArray.count == 1) {//选择了图片处理
            LHDCusstomAlbumAssetsModel * photoModel = self.selectedImageArray[0];
            
            CGRect  cFrame = CGRectMake(5*kScreen6ScaleW, (KScreenHeight-(self.view.width-10*kScreen6ScaleW)*self.editWideHighRatio)/2.0, self.view.width-10*kScreen6ScaleW,  (self.view.width-10*kScreen6ScaleW)*self.editWideHighRatio);
            
            if (_isHeader) {
                cFrame = CGRectMake((KScreenWidth-300*kScreen6ScaleW)/2.0, (KScreenHeight-300*kScreen6ScaleW)/2.0, 300*kScreen6ScaleW, 300*kScreen6ScaleW);
            }
            
            LHDEditPhotoViewController * edVC = [[LHDEditPhotoViewController alloc] initWithImage:photoModel.originImage editFrame:cFrame limitScaleRatio:3.0];
            __weak typeof(self) weakSelf = self;
            [edVC getPhotoEditedImageBlock:^(LHDEditPhotoViewController *epVC, UIImage *editedImage) {
                photoModel.originImage = editedImage;
                [weakSelf.selectedImageArray removeAllObjects];
                [weakSelf.selectedImageArray addObject:photoModel];
                weakSelf.getImageArrBlock(_albumGroup,_selectedImageArray,@[editedImage],@[editedImage],YES);
            }];
            [edVC dismissVCBlock:^(BOOL yes) {
                if (yes) {
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                }
            }];
            [self presentViewController:edVC animated:NO completion:^{
                
            }];
            
        } else {
            NSMutableArray * thumArr = [NSMutableArray array];
            NSMutableArray * orArr = [NSMutableArray array];
            for (LHDCusstomAlbumAssetsModel * photoModel in self.selectedImageArray) {
                [thumArr addObject:photoModel.thumbImage];
                [orArr addObject:photoModel.originImage];
            }
            self.getImageArrBlock(_albumGroup,_selectedImageArray,thumArr,orArr,YES);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

-(void)cancleLeftClicked
{
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getImagesBlock:(GetAlbumThumImageAndOriginImageBlock)block
{
    self.getImageArrBlock = block;
}



- (void)choseGroupClicked
{
    self.groupView.frame = CGRectMake(0, 0, self.groupView.frame.size.width, 60*self.groupView.groupNumber);
    [LHDPopView showContentView:self.groupView style:LHDPopViewBackgroundStyleDark FromPoint:CGPointMake(self.view.frame.size.width/2.0, 67)];
}

- (void)setAlbumGroup:(LHDCusstomAlbumGroupModel *)albumGroup
{
    _albumGroup = albumGroup;
    __weak typeof(self) weakSelf = self;
    self.title = albumGroup.groupName;
    [self.imageDataArray removeAllObjects];
    if (!isFirstShow) {
        [self selectedImageArray];
        isFirstShow = YES;
    } else {
        [self.selectedImageArray removeAllObjects];
    }
    [[LHDAlbumAssetsManager defaultAlbum] getGroupPhotosWithGroup:_albumGroup finished:^(NSArray * objc) {
        typeof(weakSelf) __strong strongSelf = weakSelf;
        [objc enumerateObjectsUsingBlock:^(ALAsset * obj, NSUInteger idx, BOOL *stop) {
            LHDCusstomAlbumAssetsModel * photoModel = [[LHDCusstomAlbumAssetsModel alloc] init];
            photoModel.asset = obj;
            [strongSelf.imageDataArray addObject:photoModel];
        }];
        [strongSelf.collectionView reloadData];
    }];
}

- (void)configAlbumAssetsVC
{
    [self addNavigationItemWithTitles:@[@"完成"] isLeft:NO target:self action:@selector(completClicked) tags:nil];
    [self addNavigationItemWithTitles:@[@"取消"] isLeft:YES target:self action:@selector(cancleLeftClicked) tags:nil];
    
    _choseGroupView = [[LHDChoseGroupTitleView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [_choseGroupView addTarget:self action:@selector(choseGroupClicked)];
    self.navigationItem.titleView = _choseGroupView;
    [self groupView];
    __weak typeof(self) weakSelf = self;
    
    [self.groupView selectedAlbumGroupBlock:^(LHDCusstomAlbumGroupModel *groupModel) {
        [weakSelf setAlbumGroup:groupModel];
    }];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
}

- (LHDCusstomAlbumGroupView *)groupView
{
    if (!_groupView) {
        _groupView = [[LHDCusstomAlbumGroupView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-10, 60*3)];
        _groupView.userInteractionEnabled = YES;
        _groupView.layer.cornerRadius = 3;
        _groupView.layer.masksToBounds = YES;
    }
    return _groupView;
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        CGFloat cellWidth = (self.view.frame.size.width - CELL_MARGIN * CELL_ROW + 1) / CELL_ROW;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(cellWidth, cellWidth);
        layout.minimumInteritemSpacing = 0;
        
        layout.minimumLineSpacing = CELL_LINE_MARGIN;
        layout.footerReferenceSize = CGSizeMake(self.view.frame.size.width, TOOLBAR_HEIGHT * 2);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[LHDCusstomAlbumAssetsCollectionViewCell class] forCellWithReuseIdentifier:@"LHDCusstomAlbumAssetsCollectionViewCell"];
        
    }
    return _collectionView;
}

#pragma mark -<UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.imageDataArray.count == 0) {
        return 0;
    }
    return self.imageDataArray.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LHDCusstomAlbumAssetsCollectionViewCell * collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LHDCusstomAlbumAssetsCollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        UIImage * image = [UIImage imageNamed:@"AlbumAssets_icon_photo"];
        collectionViewCell.imageView.image = image;
        collectionViewCell.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        collectionViewCell.imageView.center = collectionViewCell.contentView.center;
        collectionViewCell.selectedButton.hidden = YES;
    } else {
        collectionViewCell.selectedButton.hidden = NO;
        collectionViewCell.imageView.frame = collectionViewCell.contentView.frame;
        LHDCusstomAlbumAssetsModel * photoModel = _imageDataArray[indexPath.row-1];
        collectionViewCell.imageView.backgroundColor = [UIColor clearColor];
        collectionViewCell.imageView.image = [photoModel thumbImage];
        collectionViewCell.isSelected = NO;
        for (LHDCusstomAlbumAssetsModel * selectedPhotoModel in self.selectedImageArray) {
            if ([selectedPhotoModel.asset.defaultRepresentation.url isEqual:[photoModel asset].defaultRepresentation.url]) {
                collectionViewCell.isSelected = YES;
                collectionViewCell.selectedButton.selected = YES;
            }
        }
    }
    return collectionViewCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {//在这里点击进入相机
        if (self.selectedImageArray.count >= self.maxCount) {
//            showTextHudWithTitle([NSString stringWithFormat:@"亲,最多选择(%zi)张哦",self.maxCount], self.view);
            return;
        }
        LHDCusstomCameraViewController * cameraVC = [[LHDCusstomCameraViewController alloc] init];
        cameraVC.isNeedEditPhoto = NO;
        __weak typeof(self) weakSelf = self;
        [cameraVC cusstomCameraGetPhotoImageBlock:^(LHDCusstomCameraViewController *cameraVC, UIImage *image) {
//            image = [image fixOrientation];
            [[LHDAlbumAssetsManager defaultAlbum] saveImage:image callBack:^(id objc) {
                LHDCusstomAlbumAssetsModel * photoModel = (LHDCusstomAlbumAssetsModel *)objc;
                [weakSelf.imageDataArray insertObject:photoModel atIndex:0];
                [weakSelf.selectedImageArray addObject:photoModel];
                [weakSelf.collectionView reloadData];
            }];
        }];
        [self presentViewController:cameraVC animated:YES completion:nil];
    } else {
        LHDCusstomAlbumAssetsCollectionViewCell * cell = (LHDCusstomAlbumAssetsCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        
        if (!cell.isSelected) {
            if (self.maxCount == 1) {
                if (self.selectedImageArray.count == 1) {
                    NSInteger selectRow = [_imageDataArray indexOfObject:self.selectedImageArray[0]]+1;
                    LHDCusstomAlbumAssetsCollectionViewCell * selectCell = (LHDCusstomAlbumAssetsCollectionViewCell*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:selectRow inSection:0]];
                    selectCell.isSelected = NO;
                    [self.selectedImageArray removeAllObjects];
                }
                LHDCusstomAlbumAssetsModel * photoModel = _imageDataArray[indexPath.row-1];
                cell.isSelected = !cell.isSelected;
                [self.selectedImageArray addObject:photoModel];
                return;
            }
            if (self.selectedImageArray.count >= self.maxCount) {
//                showTextHudWithTitle([NSString stringWithFormat:@"亲,不要太贪心哦"], self.view);
                return;
            }
        }
        LHDCusstomAlbumAssetsModel * photoModel = _imageDataArray[indexPath.row-1];
        cell.isSelected = !cell.isSelected;
        if (cell.isSelected) {
            [self.selectedImageArray addObject:photoModel];
        } else {
            [self.selectedImageArray removeObject:photoModel];
        }
    }
    
}

- (void)show
{
    //add by ygy:2016.5.11 请求照片权限
    [[[ALAssetsLibrary alloc]init] enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        //因为只是请求权限，不需要遍历，输出stop停止遍历
        *stop = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_fromeViewController) {
                UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:self];
                [_fromeViewController  presentViewController:nav animated:YES completion:nil];
            } else{
                //        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:self];
                //        nav.navigationBar.hidden = NO;
                //        [[CusstomWindow getRootViewController]presentViewController:nav animated:YES completion:nil];
            }
        });
    } failureBlock:^(NSError *error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [MyAlertView showAlertViewWithTitle:@"无法访问相册" message:@"前往设置开启相册权限？" cancelButtonTitle:@"取消" otherButtonTitle:@[@"确定"] onDismiss:^(int buttonIndex) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if([[UIApplication sharedApplication] canOpenURL:url]) {
                    NSURL *url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:url];
                }
            } onCancel:^{
            }];
        });
    }];
}

- (void)dealloc
{
    NSLog(@"相册dealloc%@",NSStringFromClass([self class]));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
