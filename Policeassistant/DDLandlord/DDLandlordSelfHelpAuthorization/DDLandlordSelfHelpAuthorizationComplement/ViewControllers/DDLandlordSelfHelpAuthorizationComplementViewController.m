//
//  DDLandlordSelfHelpAuthorizationComplementViewController.m
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/6.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "DDLandlordSelfHelpAuthorizationComplementViewController.h"
#import "DDLandlordSelfHelpAuthorizationCompleteViewController.h"
#import "DDLandlordChooseApplyForIdentifyView.h"
#import "DDFaceplusplusAPIManager.h"
#import "LHDCusstomAlbumAssetsViewController.h"
#import "LHDCusstomCameraViewController.h"
#import "AliCloudUtil.h"
#import "iPhoneUUID.h"

@interface DDLandlordSelfHelpAuthorizationComplementViewController ()

/**显示中间的内容背景，用UIScrollView，可以上下滑动*/
@property (nonatomic,strong) UIScrollView * contentBgScrollView;

/**申请身份 背景view*/
@property (nonatomic,strong) UIView * applyForIdentifyBgView;
/**申请身份*/
@property (nonatomic,strong) UILabel * applyForIdentifyLabel;
/**选择了第几个*/
@property (nonatomic,assign) NSInteger applyForIdentifySelectedRow;
/**身份选择背景 view*/
@property (nonatomic,strong) UIView * identifyCardChooseBgView;

/**身份证正面*/
@property (nonatomic,strong) UIImageView * identifyCardFrontImageView;
/**身份证反面照片*/
@property (nonatomic,strong) UIImageView * identifyCardBehindImageView;
/**手持身份证照片背景图片*/
@property (nonatomic,strong) UIImageView * handIdentifyCardBgImageView;
/**手持身份证照片*/
@property (nonatomic,strong) UIImageView * handIdentifyCardImageView;

#pragma mark -
/**上传图片的时候，在各个图片上显示的  加载框*/
/**上传正面身份证照片的时候*/
@property (weak, nonatomic) UIActivityIndicatorView * uploadIdentifyCardFrontLoadingView;
/**上传反面身份证照片的时候*/
@property (weak, nonatomic) UIActivityIndicatorView * uploadIdentifyCardBehindLoadingView;
/**上传手持身份证照片的时候*/
@property (weak, nonatomic) UIActivityIndicatorView * uploadHandIdentifyCardLoadingView;

/**编辑 身份证正面 图片*/
@property (nonatomic,strong) UIImageView * identifyCardFrontEditImageView;
/**编辑 身份证反面照片 图片*/
@property (nonatomic,strong) UIImageView * identifyCardBehindEditImageView;
/**编辑 手持身份证照片 图片*/
@property (nonatomic,strong) UIImageView * handIdentifyCardEditImageView;

#pragma mark - 上传后的身份证模型
/**身份证正面的模型*/
@property (nonatomic,strong) DDIdentifyCardSideFrontModel *identifyCardFrontModel;
/**身份证反面的模型*/
@property (nonatomic,strong) DDIdentifyCardSideBackModel *identifyCardBackModel;
/**用于标记是否选择了身份证手持照片*/
@property (nonatomic,assign) BOOL isSelectedHandIdentifyCard;

#pragma mark - 防止重复上传
/**是否正在上传身份证正面照片*/
@property (nonatomic,assign) BOOL isInProcessOfUploadIdentifyCardFront;
/**是否正在上传身份证反面照片*/
@property (nonatomic,assign) BOOL isInProcessOfUploadIdentifyCardBack;
/**是否正在上传手持身份证照片*/
@property (nonatomic,assign) BOOL isInProcessOfUploadIdentifyHandCard;

@end

@implementation DDLandlordSelfHelpAuthorizationComplementViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.authorizationModel.card_img1 = nil;
    self.authorizationModel.card_img2 = nil;
    self.authorizationModel.card_img3 = nil;
    self.title = @"补全信息";
    [self setRightItemWithTitle:@"提交"];
    [self configUI];
}

#pragma mark - 点击事件
/**提交点击事件在这里*/
- (void)navRightItemClick:(NSInteger)index
{
    if (![self.authorizationModel.auth_type toString].length) {
        [DDProgressHUD showCenterWithText:@"请选择申请身份" duration:1.5];
        return;
    }
    /**检测身份证照片是否已经选择了*/
    if (!self.identifyCardFrontModel) {
        [DDProgressHUD showCenterWithText:@"请上传身份证正面照片！" duration:1.5];
        return;
    }
    if (!self.identifyCardBackModel) {
        [DDProgressHUD showCenterWithText:@"请上传身份证反面照片！" duration:1.5];
        return;
    }
    if (!self.isSelectedHandIdentifyCard) {
        [DDProgressHUD showCenterWithText:@"请上传手持身份证照片！" duration:1.5];
        return;
    }
    if (![self.authorizationModel.real_name isEqualToString:self.identifyCardFrontModel.name]) {
        [DDProgressHUD showCenterWithText:@"所填姓名与身份证上的姓名不匹配" duration:1.5];
        return;
    }
    /**以上代表已经选择完了，这里判断是否已经上传完了*/
    if (!self.authorizationModel.card_img1 || !self.authorizationModel.card_img2 ||!self.authorizationModel.card_img3) {
        WeakSelf
        [SVProgressHUD showWithStatus:@"授权中..."];
        if (!self.authorizationModel.card_img1) {//身份证正面照
            [self uploadIdentifyCardFrontData:^(BOOL isNeed) {
                StrongSelf
                if (isNeed) {
                    [strongSelf authorizationRequestData];
                } else {
                    [SVProgressHUD dismiss];
                    [DDProgressHUD showCenterWithText:@"上传身份证正面照片失败，请稍后重试！" duration:1.5];
                }
            }];
        }
        if (!self.authorizationModel.card_img2) {//身份证反面照
            [self uploadIdentifyCardBackData:^(BOOL isNeed) {
                StrongSelf
                if (isNeed) {
                    [strongSelf authorizationRequestData];
                } else {
                    [SVProgressHUD dismiss];
                    [DDProgressHUD showCenterWithText:@"上传身份证反面照片失败，请稍后重试！" duration:1.5];
                }
            }];
        }
        if (!self.authorizationModel.card_img3) {//身份证手持照
            [self uploadHandIdentifyCarData:^(BOOL isNeed) {
                StrongSelf
                if (isNeed) {
                    [strongSelf authorizationRequestData];
                } else {
                    [SVProgressHUD dismiss];
                    [DDProgressHUD showCenterWithText:@"上传手持身份证照片失败，请稍后重试！" duration:1.5];
                }
            }];
        }
    } else {
        [SVProgressHUD showWithStatus:@"授权中..."];
        [self authorizationRequestData];
    }
}
#pragma mark - 请求授权 接口
- (void)authorizationRequestData
{
    if (!self.authorizationModel.card_img1 && !self.authorizationModel.card_img2 &&!self.authorizationModel.card_img3) {
        return;
    }
    self.authorizationModel.identifyCardFrontModel = self.identifyCardFrontModel;
    self.authorizationModel.identifyCardBackModel = self.identifyCardBackModel;
    NSDictionary * dict = [self.authorizationModel returnDataDict];
    WeakSelf
    [self postWithUrlString:DDLandlordAuthorizationsRecordsUrlStr parms:dict success:^(NSData *requestData, NSDictionary *requestDict, NSInteger statusCode) {
        [SVProgressHUD dismiss];
        StrongSelf
        DDLandlordSelfHelpAuthorizationCompleteViewController * vc = [[DDLandlordSelfHelpAuthorizationCompleteViewController alloc] init];
        [strongSelf pushVC:vc];
    } failure:^(NSInteger statusCode, NSError *error, NSString *errorMessage) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - 选择申请身份点击
- (void)chooseApplyForIdentifyClicked
{
    DDLandlordChooseApplyForIdentifyView * view = [[DDLandlordChooseApplyForIdentifyView alloc] initWithDataArray:@[@"租客",@"家人",@"临时客人"]];
    WeakSelf;
    [view getIdentifyDataBlock:^(NSInteger index) {
        StrongSelf//授权信息，授权类型：0业主，1家人，2租客，3临时客人
        strongSelf.applyForIdentifyLabel.text = @[@"租客",@"家人",@"临时客人"][index];
        strongSelf.applyForIdentifySelectedRow = index;
        strongSelf.authorizationModel.auth_type = @"2";//默认租客
        if (index == 1) {//家人
            strongSelf.authorizationModel.auth_type = @"1";
        } else if (index == 2){//临时客人
            strongSelf.authorizationModel.auth_type = @"3";
        }
    }];
    [view show];
}
#pragma mark - 选择身份证  正面  点击
- (void)chooseIdentifyCardFrontClicked
{
    WeakSelf
    LHDCusstomCameraViewController * cameraVC = [[LHDCusstomCameraViewController alloc] init];
    cameraVC.isNeedEditPhoto = YES;
    cameraVC.editWideHighRatio = 0.63125;
    cameraVC.fromeViewController = self;
    [cameraVC cusstomCameraGetPhotoImageBlock:^(LHDCusstomCameraViewController *cameraVC, UIImage *image) {
        StrongSelf
        strongSelf.identifyCardFrontImageView.image = image;
        strongSelf.uploadIdentifyCardFrontLoadingView.hidden = NO;
        strongSelf.identifyCardFrontImageView.userInteractionEnabled = NO;
        strongSelf.identifyCardFrontModel = nil;
        /**上传身份证照片正面*/
        [DDFaceplusplusAPIManager uploadImageWithImage:strongSelf.identifyCardFrontImageView.image finished:^(NSDictionary *requestDict, IdentifyCardSideType sideType, DDIdentifyCardSideFrontModel *frontModel, DDIdentifyCardSideBackModel *backModel) {
            /**清空数据*/
            strongSelf.uploadIdentifyCardFrontLoadingView.hidden = YES;
            [strongSelf.uploadIdentifyCardFrontLoadingView removeFromSuperview];
            strongSelf.uploadIdentifyCardFrontLoadingView = nil;
            strongSelf.identifyCardFrontImageView.userInteractionEnabled = YES;
            /**检测上传身份证照片是否是正面*/
            if (sideType == IdentifyCardSideFrontType) {//是正面的
                strongSelf.identifyCardFrontEditImageView.hidden = NO;
                strongSelf.identifyCardFrontModel = frontModel;
                [strongSelf uploadIdentifyCardFrontData:nil];
            } else {//不是正面的
                [DDProgressHUD showCenterWithText:@"请上传身份证正面照片！" duration:1.5];
                strongSelf.identifyCardFrontEditImageView.hidden = YES;
                strongSelf.identifyCardFrontImageView.image = [UIImage imageNamed:@"DDLandlordSelfHelpAuthorizationIdentifyCardFront"];
                strongSelf.identifyCardFrontModel = nil;
            }
        }];

    }];
    [cameraVC show];
}

#pragma mark - 选择身份证  反面  点击
- (void)chooseIndentifyCardBehindClicked
{
    WeakSelf
    LHDCusstomCameraViewController * cameraVC = [[LHDCusstomCameraViewController alloc] init];
    cameraVC.isNeedEditPhoto = YES;
    cameraVC.editWideHighRatio = 0.63125;
    cameraVC.fromeViewController = self;
    [cameraVC cusstomCameraGetPhotoImageBlock:^(LHDCusstomCameraViewController *cameraVC, UIImage *image) {
        StrongSelf
        strongSelf.identifyCardBehindImageView.image = image;
        strongSelf.uploadIdentifyCardBehindLoadingView.hidden = NO;
        strongSelf.identifyCardBackModel = nil;
        /**上传身份证照片反面*/
        [DDFaceplusplusAPIManager uploadImageWithImage:strongSelf.identifyCardBehindImageView.image finished:^(NSDictionary *requestDict, IdentifyCardSideType sideType, DDIdentifyCardSideFrontModel *frontModel, DDIdentifyCardSideBackModel *backModel) {
            /**清空数据*/
            strongSelf.uploadIdentifyCardBehindLoadingView.hidden = YES;
            [strongSelf.uploadIdentifyCardBehindLoadingView removeFromSuperview];
            strongSelf.uploadIdentifyCardBehindLoadingView = nil;
            strongSelf.identifyCardBehindImageView.userInteractionEnabled = YES;
            /**检测上传身份证照片是否是反面*/
            if (sideType == IdentifyCardSideBackType) {//是反面的
                strongSelf.identifyCardBehindEditImageView.hidden = NO;
                strongSelf.identifyCardBackModel = backModel;
                [strongSelf uploadIdentifyCardBackData:nil];
            } else {//不是反面的
                [DDProgressHUD showCenterWithText:@"请上传身份证反面照片！" duration:1.5];
                strongSelf.identifyCardBehindEditImageView.hidden = YES;
                strongSelf.identifyCardBehindImageView.image = [UIImage imageNamed:@"DDLandlordSelfHelpAuthorizationIdentifyCardBehind"];
                strongSelf.identifyCardBackModel = nil;
            }
        }];
    }];
    [cameraVC show];
}

#pragma mark - 手持  身份证照片  点击
- (void)handIdentifyCardClicked
{
    WeakSelf
    LHDCusstomCameraViewController * cameraVC = [[LHDCusstomCameraViewController alloc] init];
    cameraVC.isNeedEditPhoto = YES;
    cameraVC.editWideHighRatio = 1.1;
    cameraVC.fromeViewController = self;
    [cameraVC cusstomCameraGetPhotoImageBlock:^(LHDCusstomCameraViewController *cameraVC, UIImage *image) {
        StrongSelf
        strongSelf.authorizationModel.card_img3 = nil;
        strongSelf.handIdentifyCardImageView.image = image;
        strongSelf.uploadHandIdentifyCardLoadingView.hidden = NO;
        strongSelf.handIdentifyCardImageView.userInteractionEnabled = NO;
        strongSelf.isSelectedHandIdentifyCard = YES;
        [strongSelf uploadHandIdentifyCarData:nil];
    }];
    [cameraVC show];
}

#pragma mark - 图片上传，身份证照片上传到阿里云
/**上传身份证正面照片*/
- (void)uploadIdentifyCardFrontData:(CallBackRefreshDataBlock)block
{
    if (self.isInProcessOfUploadIdentifyCardFront) {
        if (block) {
            block(NO);
        }
        return;
    }
    WeakSelf
    self.isInProcessOfUploadIdentifyCardFront = YES;
    DDLandlordUserModel * userModel = landlordUserModel;
    [[[AliCloudUtil alloc] initWithUserID:userModel.user_id deviceUDID:[iPhoneUUID getUUIDString]] uploadImageWithimageData:[DDFaceplusplusAPIManager returnIdentifyCardWithImage:self.identifyCardFrontImageView.image] imageName:[[NSUUID UUID] UUIDString] AliCloudDirType:AliCloudDirTypeIdCards successBlock:^(NSString *objectKey) {
        StrongSelf
        strongSelf.isInProcessOfUploadIdentifyCardFront = NO;
        strongSelf.authorizationModel.card_img1 = objectKey;
        if (block) {
            block(YES);
        }
    } failBlock:^{
        StrongSelf
        strongSelf.isInProcessOfUploadIdentifyCardFront = NO;
        strongSelf.authorizationModel.card_img1 = nil;
        if (block) {
            block(NO);
        }
    }];
}
/**上传身份证反面照片*/
- (void)uploadIdentifyCardBackData:(CallBackRefreshDataBlock)block
{
    if (self.isInProcessOfUploadIdentifyCardBack) {
        if (block) {
            block(NO);
        }
        return;
    }
    DDLandlordUserModel * userModel = landlordUserModel;
    WeakSelf
    self.isInProcessOfUploadIdentifyCardBack = YES;
    [[[AliCloudUtil alloc] initWithUserID:userModel.user_id deviceUDID:[iPhoneUUID getUUIDString]] uploadImageWithimageData:[DDFaceplusplusAPIManager returnIdentifyCardWithImage:self.identifyCardBehindEditImageView.image] imageName:[[NSUUID UUID] UUIDString] AliCloudDirType:AliCloudDirTypeIdCards successBlock:^(NSString *objectKey) {
        StrongSelf
        strongSelf.isInProcessOfUploadIdentifyCardBack = NO;
        strongSelf.authorizationModel.card_img2 = objectKey;
        if (block) {
            block(YES);
        }
    } failBlock:^{
        StrongSelf
        strongSelf.isInProcessOfUploadIdentifyCardBack = NO;
        strongSelf.authorizationModel.card_img2 = nil;
        if (block) {
            block(NO);
        }
    }];
}
/**上传手持身份证照片*/
- (void)uploadHandIdentifyCarData:(CallBackRefreshDataBlock)block
{
    if (self.isInProcessOfUploadIdentifyHandCard) {
        if (block) {
            block(NO);
        }
        return;
    }
    WeakSelf
    self.isInProcessOfUploadIdentifyHandCard = YES;
    self.handIdentifyCardImageView.userInteractionEnabled = NO;
    self.handIdentifyCardEditImageView.hidden = YES;
    DDLandlordUserModel * userModel = landlordUserModel;
    [[[AliCloudUtil alloc] initWithUserID:userModel.user_id deviceUDID:[iPhoneUUID getUUIDString]] uploadImageWithimageData:[DDFaceplusplusAPIManager returnIdentifyCardWithImage:self.handIdentifyCardImageView.image] imageName:[[NSUUID UUID] UUIDString] AliCloudDirType:AliCloudDirTypeIdCards successBlock:^(NSString *objectKey) {
        StrongSelf
        strongSelf.isInProcessOfUploadIdentifyHandCard = NO;
        strongSelf.handIdentifyCardEditImageView.hidden = NO;
        strongSelf.uploadHandIdentifyCardLoadingView.hidden = YES;
        [strongSelf.uploadHandIdentifyCardLoadingView removeFromSuperview];
        strongSelf.uploadHandIdentifyCardLoadingView = nil;
        strongSelf.handIdentifyCardImageView.userInteractionEnabled = YES;
        strongSelf.authorizationModel.card_img3 = objectKey;
        if (block) {
            block(YES);
        }
    } failBlock:^{
        StrongSelf
        strongSelf.isInProcessOfUploadIdentifyHandCard = NO;
        strongSelf.handIdentifyCardEditImageView.hidden = YES;
        strongSelf.uploadHandIdentifyCardLoadingView.hidden = YES;
        [strongSelf.uploadHandIdentifyCardLoadingView removeFromSuperview];
        strongSelf.uploadHandIdentifyCardLoadingView = nil;
        strongSelf.handIdentifyCardImageView.userInteractionEnabled = YES;
        strongSelf.authorizationModel.card_img3 = nil;
        if (block) {
            block(NO);
        }
    }];

}
#pragma mark - 界面布局
- (void)configUI
{
    self.view.backgroundColor = ColorHex(@"#EFEFF4");
    self.contentBgScrollView.backgroundColor = ColorHex(@"#EFEFF4");
    [self.view addSubview:self.contentBgScrollView];
#pragma mark - 选择身份    UI布局
    [self.contentBgScrollView addSubview:self.applyForIdentifyBgView];
#pragma mark - 备注，备注：您的信息仅供审核，不作其它用途，我们将为您保密
    UILabel * remarkOneLabel = [ControlManager lableFrame:CGRectZero title:@"您的信息仅供审核，不作其它用途，我们将为您保密" font:font6Size(24/2.0) textColor:ColorHex(@"#999999")];
    [remarkOneLabel sizeToFit];
    remarkOneLabel.centerX = KScreenWidth/2.0;
    remarkOneLabel.top6 = self.applyForIdentifyBgView.bottom6+15;
    [self.contentBgScrollView addSubview:remarkOneLabel];
#pragma mark - 身份证选择布局
    [self.contentBgScrollView addSubview:self.identifyCardChooseBgView];
    self.identifyCardChooseBgView.top6 = remarkOneLabel.bottom6+15;
    /**添加正面*/
    [self.identifyCardChooseBgView addSubview:self.identifyCardFrontImageView];
    UILabel * identifyCardFrontDesLabel = [self identifyDesLabelTitle:@"上传身份证正面"];
    [self.identifyCardChooseBgView addSubview:identifyCardFrontDesLabel];
    identifyCardFrontDesLabel.top6 = self.identifyCardFrontImageView.bottom6+10;
    identifyCardFrontDesLabel.centerX = self.identifyCardFrontImageView.centerX;
    /**添加反面*/
    [self.identifyCardChooseBgView addSubview:self.identifyCardBehindImageView];
    UILabel * identifyCardBehindDesLabel = [self identifyDesLabelTitle:@"上传身份证反面"];
    [self.identifyCardChooseBgView addSubview:identifyCardBehindDesLabel];
    identifyCardBehindDesLabel.top6 = self.identifyCardBehindImageView.bottom6+10;
    identifyCardBehindDesLabel.centerX = self.identifyCardBehindImageView.centerX;
    /**添加分割线*/
    UIView * identifyBottomLineView = [self lineViewTop:identifyCardBehindDesLabel.bottom-0.25+10*kScreen6ScaleH];
    [self.identifyCardChooseBgView addSubview:identifyBottomLineView];
    UIView * identifyVerticalLineView = [self lineViewTop:15*kScreen6ScaleH];
    identifyVerticalLineView.height = identifyBottomLineView.top-identifyVerticalLineView.top;
    identifyVerticalLineView.width = 0.5;
    identifyVerticalLineView.centerX = KScreenWidth/2.0;
    [self.identifyCardChooseBgView addSubview:identifyVerticalLineView];
    [self.identifyCardChooseBgView addSubview:identifyVerticalLineView];
    
    /**手持身份证*/
    [self.identifyCardChooseBgView addSubview:self.handIdentifyCardBgImageView];
    self.handIdentifyCardBgImageView.top6 = identifyBottomLineView.bottom6+10;
    UILabel * handIdentifyCardDesLabel = [self identifyDesLabelTitle:@"上传手持身份证照"];
    handIdentifyCardDesLabel.centerX = KScreenWidth/2.0;
    handIdentifyCardDesLabel.top6 = self.handIdentifyCardBgImageView.bottom6 + 10;
    [self.identifyCardChooseBgView addSubview:handIdentifyCardDesLabel];
    self.identifyCardChooseBgView.height6 = handIdentifyCardDesLabel.bottom6 + 10;
#pragma mark - 拍照要求布局
    UILabel * photographDemandDesLabel = [self identifyDesLabelTitle:@"拍摄照片要求"];
    photographDemandDesLabel.centerX = KScreenWidth/2.0;
    photographDemandDesLabel.top6 = self.identifyCardChooseBgView.bottom6 + 10;
    [self.contentBgScrollView addSubview:photographDemandDesLabel];
    /**线*/
    CGFloat photographDemandLineWidth = (KScreenWidth - photographDemandDesLabel.width - (30+50)*kScreen6ScaleW)/2.0;
    /**左边的线*/
    UIView * photographDemandLeftLineView = [self lineViewTop:0];
    photographDemandLeftLineView.width = photographDemandLineWidth;
    photographDemandLeftLineView.x6 = 15;
    photographDemandLeftLineView.centerY = photographDemandDesLabel.centerY;
    photographDemandLeftLineView.backgroundColor = ColorHex(@"#979797");
    [self.contentBgScrollView addSubview:photographDemandLeftLineView];
    /**右边的线*/
    UIView * photographDemandRightLineView = [self lineViewTop:0];
    photographDemandRightLineView.width = photographDemandLineWidth;
    photographDemandRightLineView.right6 = kScreen6Width - 15;
    photographDemandRightLineView.centerY = photographDemandDesLabel.centerY;
    photographDemandRightLineView.backgroundColor = ColorHex(@"#979797");
    [self.contentBgScrollView addSubview:photographDemandRightLineView];
    /**添加照片要求图片*/
    NSArray * photographDemandImageArray = @[@"DDLandlordSelfHelpAuthorizationPhotoRequireOne",@"DDLandlordSelfHelpAuthorizationPhotoRequireTwo",@"DDLandlordSelfHelpAuthorizationPhotoRequireThree",@"DDLandlordSelfHelpAuthorizationPhotoRequireFour"];
    //106   116
    CGFloat photographDemandImageWidth = 106/2.0*kScreen6ScaleW;
    CGFloat photographDemandImageSpace = (KScreenWidth - photographDemandImageWidth * 4)/5.0;
    for (NSInteger i = 0; i < photographDemandImageArray.count; i++) {
        UIImageView * imageView  = [ControlManager imageViewWithFrame:CGRectMake6(0,photographDemandDesLabel.bottom6+10 , photographDemandImageWidth, 116/2.0) imageName:photographDemandImageArray[i]];
        imageView.x = photographDemandImageSpace + (photographDemandImageSpace+photographDemandImageWidth)*i;
        [self.contentBgScrollView addSubview:imageView];
        if (imageView.bottom > self.contentBgScrollView.contentSize.height) {
            self.contentBgScrollView.contentSize = CGSizeMake(KScreenWidth, imageView.bottom+15*kScreen6ScaleH);
        }
    }
}
#pragma mark - 全局的  懒加载在这里
/**显示中间的内容背景，用UIScrollView，可以上下滑动*/
- (UIScrollView *)contentBgScrollView
{
    if (!_contentBgScrollView) {
        _contentBgScrollView = [ControlManager scrollViewWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64) isBounces:NO isShowIndicator:NO];
        WeakSelf
        [_contentBgScrollView addLHDClickedHandle:^(id sender) {
            StrongSelf
            [strongSelf.view endEditing:YES];
        }];
    }
    return _contentBgScrollView;
}
/**申请身份 背景view*/
- (UIView *)applyForIdentifyBgView
{
    if (!_applyForIdentifyBgView) {
        _applyForIdentifyBgView = [ControlManager viewWithFrame:CGRectMake(-1, 0, KScreenWidth+2, 0) backgroundColor:[UIColor whiteColor]];
        _applyForIdentifyBgView.height6 = 120/2.0;
        _applyForIdentifyBgView.top6 = 10;
        ViewBorderRadius(_applyForIdentifyBgView, 0, 0.5, ColorHex(@"#DDDDDD"));
        UILabel * choseDesLabel = [ControlManager lableFrame:CGRectZero title:@"选择申请身份" font:font6Size(36/2.0) textColor:ColorHex(@"4A4A4A")];
        [choseDesLabel sizeToFit];
        choseDesLabel.x6 = 15;
        choseDesLabel.centerY = _applyForIdentifyBgView.height/2.0;
        [_applyForIdentifyBgView addSubview:choseDesLabel];
        UIImageView * arrowImageView = [ControlManager imageViewWithImageName:@"DDLandlordCommonarrowright"];
        arrowImageView.right6 = _applyForIdentifyBgView.width6-15;
        arrowImageView.centerY = _applyForIdentifyBgView.height/2.0;
        [_applyForIdentifyBgView addSubview:arrowImageView];
        _applyForIdentifyLabel = [ControlManager lableFrame:CGRectMake(0, 0, 0, font6Size(36/2.0).lineHeight) font:font6Size(36/2.0) textColor:ColorHex(@"999999") textAligment:NSTextAlignmentRight];
        _applyForIdentifyLabel.text = @"";
        _applyForIdentifyLabel.width6 = _applyForIdentifyBgView.width6-choseDesLabel.right6-arrowImageView.left6-30;
        _applyForIdentifyLabel.right6 = arrowImageView.left6-15;
        _applyForIdentifyLabel.centerY = arrowImageView.centerY;
        [_applyForIdentifyBgView addSubview:_applyForIdentifyLabel];
        WeakSelf
        [_applyForIdentifyBgView addLHDClickedHandle:^(id sender) {
            StrongSelf
            [strongSelf chooseApplyForIdentifyClicked];
        }];
    }
    return _applyForIdentifyBgView;
}
/**身份选择背景 view*/
- (UIView *)identifyCardChooseBgView
{
    if (!_identifyCardChooseBgView) {
        _identifyCardChooseBgView = [ControlManager viewWithFrame:CGRectMake(0, 0, KScreenWidth, 200) backgroundColor:[UIColor whiteColor]];
        _identifyCardChooseBgView.userInteractionEnabled = YES;
    }
    return _identifyCardChooseBgView;
}
/**身份证正面*/
- (UIImageView *)identifyCardFrontImageView
{
    if (!_identifyCardFrontImageView) {
        _identifyCardFrontImageView = [ControlManager imageViewWithFrame:CGRectMake6(15, 15, 320/2.0, 201/2.0) imageName:@"DDLandlordSelfHelpAuthorizationIdentifyCardFront"];
        WeakSelf
        [_identifyCardFrontImageView addLHDClickedHandle:^(id sender) {
            StrongSelf
            [strongSelf chooseIdentifyCardFrontClicked];
        }];
        [_identifyCardFrontImageView addSubview:self.identifyCardFrontEditImageView];
        self.identifyCardFrontEditImageView.bottom = _identifyCardFrontImageView.height;
    }
    return _identifyCardFrontImageView;
}
/**身份证反面照片*/
- (UIImageView *)identifyCardBehindImageView
{
    if (!_identifyCardBehindImageView) {
        _identifyCardBehindImageView = [ControlManager imageViewWithFrame:CGRectMake6(15, 15, 320/2.0, 201/2.0) imageName:@"DDLandlordSelfHelpAuthorizationIdentifyCardBehind"];
        _identifyCardBehindImageView.right6 = kScreen6Width - 15;
        WeakSelf
        [_identifyCardBehindImageView addLHDClickedHandle:^(id sender) {
            StrongSelf
            [strongSelf chooseIndentifyCardBehindClicked];
        }];
        [_identifyCardBehindImageView addSubview:self.identifyCardBehindEditImageView];
        self.identifyCardBehindEditImageView.bottom = _identifyCardBehindImageView.height;
    }
    return _identifyCardBehindImageView;
}
/**手持身份证照片背景图片*/
- (UIImageView *)handIdentifyCardBgImageView
{
    if (!_handIdentifyCardBgImageView) {
        _handIdentifyCardBgImageView = [ControlManager imageViewWithFrame:CGRectMake6(15, 0, 688/2.0, 370/2.0) imageName:@""];
        _handIdentifyCardBgImageView.backgroundColor = [UIColor colorWithRed:0.59 green:0.59 blue:0.59 alpha:1.00];
        [_handIdentifyCardBgImageView addSubview:self.handIdentifyCardImageView];
        [_handIdentifyCardBgImageView addSubview:self.handIdentifyCardEditImageView];
        WeakSelf
        [_handIdentifyCardBgImageView addLHDClickedHandle:^(id sender) {
            StrongSelf
            [strongSelf handIdentifyCardClicked];
        }];
        self.handIdentifyCardEditImageView.bottom = _handIdentifyCardBgImageView.height;
    }
    return _handIdentifyCardBgImageView;
}
/**手持身份证照片*/
- (UIImageView *)handIdentifyCardImageView
{
    if (!_handIdentifyCardImageView) {
        _handIdentifyCardImageView = [ControlManager imageViewWithFrame:CGRectMake6(0, 0, 688/2.0, 370/2.0) imageName:@"DDLandlordSelfHelpAuthorizationIdentifyCardHand"];
        _handIdentifyCardImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _handIdentifyCardImageView;
}
/**编辑 身份证正面 图片*/
- (UIImageView *)identifyCardFrontEditImageView
{
    if (!_identifyCardFrontEditImageView) {
        _identifyCardFrontEditImageView = [ControlManager imageViewWithFrame:CGRectMake6(0, 0, 56/2.0, 56/2.0) imageName:@"DDLandlordSelfHelpAuthorizationIdentifyCardEdit"];
        _identifyCardFrontEditImageView.hidden = YES;
    }
    return _identifyCardFrontEditImageView;
}
/**编辑 身份证反面照片 图片*/
- (UIImageView *)identifyCardBehindEditImageView
{
    if (!_identifyCardBehindEditImageView) {
        _identifyCardBehindEditImageView = [ControlManager imageViewWithFrame:CGRectMake6(0, 0, 56/2.0, 56/2.0) imageName:@"DDLandlordSelfHelpAuthorizationIdentifyCardEdit"];
        _identifyCardBehindEditImageView.hidden = YES;
    }
    return _identifyCardBehindEditImageView;
}
/**编辑 手持身份证照片 图片*/
- (UIImageView *)handIdentifyCardEditImageView
{
    if (!_handIdentifyCardEditImageView) {
        _handIdentifyCardEditImageView = [ControlManager imageViewWithFrame:CGRectMake6(0, 0, 56/2.0, 56/2.0) imageName:@"DDLandlordSelfHelpAuthorizationIdentifyCardEdit"];
        _handIdentifyCardEditImageView.hidden = YES;
    }
    return _handIdentifyCardEditImageView;
}

/**上传正面身份证照片的时候*/
- (UIActivityIndicatorView *)uploadIdentifyCardFrontLoadingView
{
    if (!_uploadIdentifyCardFrontLoadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        loadingView.hidesWhenStopped = YES;
        loadingView.hidden = YES;
        [loadingView startAnimating];
        loadingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
        loadingView.center = CGPointMake(self.identifyCardFrontImageView.width/2.0, self.identifyCardFrontImageView.height/2.0);
        [self.identifyCardFrontImageView addSubview:loadingView];
        _uploadIdentifyCardFrontLoadingView = loadingView;
    }
    return _uploadIdentifyCardFrontLoadingView;
}
/**上传反面身份证照片的时候*/
- (UIActivityIndicatorView *)uploadIdentifyCardBehindLoadingView
{
    if (!_uploadIdentifyCardBehindLoadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        loadingView.hidesWhenStopped = YES;
        loadingView.hidden = YES;
        [loadingView startAnimating];
        loadingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
        loadingView.center = CGPointMake(self.identifyCardBehindImageView.width/2.0, self.identifyCardBehindImageView.height/2.0);
        [self.identifyCardBehindImageView addSubview:loadingView];
        _uploadIdentifyCardBehindLoadingView = loadingView;
    }
    return _uploadIdentifyCardBehindLoadingView;
}
/**上传手持身份证照片的时候*/
- (UIActivityIndicatorView *)uploadHandIdentifyCardLoadingView
{
    if (!_uploadHandIdentifyCardLoadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        loadingView.hidesWhenStopped = YES;
        loadingView.hidden = YES;
        [loadingView startAnimating];
        loadingView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
        loadingView.center = CGPointMake(self.handIdentifyCardBgImageView.width/2.0, self.handIdentifyCardBgImageView.height/2.0);
        [self.handIdentifyCardBgImageView addSubview:loadingView];
        _uploadHandIdentifyCardLoadingView = loadingView;
    }
    return _uploadHandIdentifyCardLoadingView;
}
/**label，上传身份证正面、上传身份证反面、手持身份证反面  用的 label*/
- (UILabel *)identifyDesLabelTitle:(NSString *)title
{
    UILabel * label = [ControlManager lableFrame:CGRectZero title:title font:font6Size(24/2.0) textColor:ColorHex(@"#000000")];
    [label sizeToFit];
    return label;
}
/**一条线*/
- (UIView *)lineViewTop:(CGFloat)top
{
    UIView * lineView = [ControlManager viewWithFrame:CGRectMake(0, 0, KScreenWidth, 0.5) backgroundColor:ColorHex(@"#DDDDDD")];
    lineView.alpha = 0.6;
    lineView.top = top;
    return lineView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//    LHDCusstomAlbumAssetsViewController * cusstomAlbumVC = [[LHDCusstomAlbumAssetsViewController alloc] init];
//    cusstomAlbumVC.maxCount = 1;
//    [cusstomAlbumVC getImagesBlock:^(LHDCusstomAlbumGroupModel *groupModel, NSArray *selectArr, NSArray *thumImageArr, NSArray *originImageArray, BOOL isChose) {
//        StrongSelf
//        if (isChose) {
//            strongSelf.identifyCardFrontImageView.image = originImageArray[0];
//            strongSelf.uploadIdentifyCardFrontLoadingView.hidden = NO;
//            strongSelf.identifyCardFrontImageView.userInteractionEnabled = NO;
//            /**上传身份证照片正面*/
//            [DDFaceplusplusAPIManager uploadImageWithImage:strongSelf.identifyCardFrontImageView.image finished:^(NSDictionary *requestDict, IdentifyCardSideType sideType, DDIdentifyCardSideFrontModel *frontModel, DDIdentifyCardSideBackModel *backModel) {
//                /**清空数据*/
//                strongSelf.uploadIdentifyCardFrontLoadingView.hidden = YES;
//                [strongSelf.uploadIdentifyCardFrontLoadingView removeFromSuperview];
//                strongSelf.uploadIdentifyCardFrontLoadingView = nil;
//                strongSelf.identifyCardFrontImageView.userInteractionEnabled = YES;
//                /**检测上传身份证照片是否是正面*/
//                if (sideType == IdentifyCardSideFrontType) {//是正面的
//                    strongSelf.identifyCardFrontEditImageView.hidden = NO;
//                    strongSelf.identifyCardFrontModel = frontModel;
//                } else {//不是正面的
//                    [DDProgressHUD showCenterWithText:@"请上传身份证正面照片！" duration:1.5];
//                    strongSelf.identifyCardFrontEditImageView.hidden = YES;
//                    strongSelf.identifyCardFrontImageView.image = [UIImage imageNamed:@"DDLandlordSelfHelpAuthorizationIdentifyCardFront"];
//                    strongSelf.identifyCardFrontModel = nil;
//                }
//            }];
//        }
//    }];
//    cusstomAlbumVC.isNeedEditPhoto = YES;
//    cusstomAlbumVC.editWideHighRatio = 0.63125;
//    cusstomAlbumVC.fromeViewController = self;
//    [cusstomAlbumVC show];


//    LHDCusstomAlbumAssetsViewController * cusstomAlbumVC = [[LHDCusstomAlbumAssetsViewController alloc] init];
//    cusstomAlbumVC.maxCount = 1;
//    WeakSelf
//    [cusstomAlbumVC getImagesBlock:^(LHDCusstomAlbumGroupModel *groupModel, NSArray *selectArr, NSArray *thumImageArr, NSArray *originImageArray, BOOL isChose) {
//        StrongSelf
//        if (isChose) {
//            strongSelf.identifyCardBehindImageView.image = originImageArray[0];
//            strongSelf.uploadIdentifyCardBehindLoadingView.hidden = NO;
//            /**上传身份证照片反面*/
//            [DDFaceplusplusAPIManager uploadImageWithImage:strongSelf.identifyCardBehindImageView.image finished:^(NSDictionary *requestDict, IdentifyCardSideType sideType, DDIdentifyCardSideFrontModel *frontModel, DDIdentifyCardSideBackModel *backModel) {
//                /**清空数据*/
//                strongSelf.uploadIdentifyCardBehindLoadingView.hidden = YES;
//                [strongSelf.uploadIdentifyCardBehindLoadingView removeFromSuperview];
//                strongSelf.uploadIdentifyCardBehindLoadingView = nil;
//                strongSelf.identifyCardBehindImageView.userInteractionEnabled = YES;
//                /**检测上传身份证照片是否是反面*/
//                if (sideType == IdentifyCardSideBackType) {//是反面的
//                    strongSelf.identifyCardBehindEditImageView.hidden = NO;
//                    strongSelf.identifyCardBackModel = backModel;
//                } else {//不是反面的
//                    [DDProgressHUD showCenterWithText:@"请上传身份证反面照片！" duration:1.5];
//                    strongSelf.identifyCardBehindEditImageView.hidden = YES;
//                    strongSelf.identifyCardBehindImageView.image = [UIImage imageNamed:@"DDLandlordSelfHelpAuthorizationIdentifyCardBehind"];
//                    strongSelf.identifyCardBackModel = nil;
//                }
//            }];
//        }
//    }];
//    cusstomAlbumVC.isNeedEditPhoto = YES;
//    cusstomAlbumVC.editWideHighRatio = 0.63125;
//    cusstomAlbumVC.fromeViewController = self;
//    [cusstomAlbumVC show];


//    LHDCusstomAlbumAssetsViewController * cusstomAlbumVC = [[LHDCusstomAlbumAssetsViewController alloc] init];
//    cusstomAlbumVC.maxCount = 1;
//    WeakSelf
//    [cusstomAlbumVC getImagesBlock:^(LHDCusstomAlbumGroupModel *groupModel, NSArray *selectArr, NSArray *thumImageArr, NSArray *originImageArray, BOOL isChose) {
//        StrongSelf
//        if (isChose) {
//            strongSelf.handIdentifyCardImageView.image = originImageArray[0];
//            strongSelf.uploadHandIdentifyCardLoadingView.hidden = NO;
//        }
//    }];
//    cusstomAlbumVC.isNeedEditPhoto = YES;
//    cusstomAlbumVC.editWideHighRatio = 1.1;
//    cusstomAlbumVC.fromeViewController = self;
//    [cusstomAlbumVC show];

@end
