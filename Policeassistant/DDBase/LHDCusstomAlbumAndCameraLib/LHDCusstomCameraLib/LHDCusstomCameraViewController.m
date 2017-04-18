//
//  LHDCusstomCameraViewController.m
//  LHDCusstomAlbumAndCamera
//
//  Created by 秦沙沙 on 16/3/27.
//  Copyright © 2016年 刘和东. All rights reserved.
//

#import "LHDCusstomCameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LHDEditPhotoViewController.h"
#import "LHDCusstomCameraPreviewViewController.h"
#import <ImageIO/ImageIO.h>


typedef NS_ENUM(NSInteger, LHDCameraFlashType) {
    LHDCameraFlashTypeOff = 1,
    LHDCameraFlashTypeOpen = 2,
    LHDCameraFlashTypeAuto = 3
};

@interface LHDCusstomCameraViewController ()<UIGestureRecognizerDelegate>

/** session 用于数据传递*/
@property (nonatomic,strong) AVCaptureSession *captureSession;
/**输入设备*/
@property (strong, nonatomic) AVCaptureDevice * myDevice;

/**照片输出流*/
@property (nonatomic,strong) AVCaptureStillImageOutput *imageOutPut;
@property (nonatomic,strong) UIView *previewView;
/**预览图层*/
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic,assign) AVCaptureFlashMode flashMode;
@property (nonatomic,assign) LHDCameraFlashType flashType;
/**开始的缩放比例*/
@property (nonatomic,assign) CGFloat beginGestureScale;
/**最后的缩放比例*/
@property (nonatomic,assign) CGFloat effectiveScale;

@property (nonatomic,strong) UIView * topView;
@property (nonatomic,strong) UIButton * flashBtn;
@property (nonatomic,strong) UIView * choseFlashBgView;

@property (nonatomic,copy) LHDCusstomCameraGetPhotoImageBlock cameraBlock;

@end

@implementation LHDCusstomCameraViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.editWideHighRatio = 0.56;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.captureSession) {
        [self.captureSession startRunning];
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.captureSession) {
        [self.captureSession stopRunning];
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configCusstomCameraVCUI];
}

- (void)configCusstomCameraVCUI
{

    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    if (devices.count==0) {
        NSLog(@"SC: No devices found (for example: simulator)");
        return;
    }
    _myDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][0];

    if ([_myDevice isFlashAvailable] && _myDevice.flashActive && [_myDevice lockForConfiguration:nil]) {
        //NSLog(@"SC: Turning Flash Off ...");
        _myDevice.flashMode = AVCaptureFlashModeOff;
        [_myDevice unlockForConfiguration];
    }
    
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:_myDevice error:nil];
    
    if ([self.captureSession canAddInput:input]) {
        [self.captureSession addInput:input];
    }
    if ([self.captureSession canAddOutput:self.imageOutPut]) {
        [self.captureSession addOutput:self.imageOutPut];
    }
    [self.view addSubview:self.previewView];
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinch.delegate = self;
    [self.previewView addGestureRecognizer:pinch];
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
//    self.previewLayer.connection.videoOrientation = [self orientationForConnection];
    
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.previewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
    }
    else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.previewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
    }
    
    self.previewLayer.frame = self.previewView.bounds;
    //    self.view.layer.masksToBounds = YES;
    [self.previewView.layer addSublayer:self.previewLayer];
    self.effectiveScale = self.beginGestureScale = 1.f;
    [self configBottomViewUI];
    [self configTopViewUI];
    _flashType = LHDCameraFlashTypeAuto;
}

- (void)configTopViewUI
{
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    bgView.alpha = 0.5;
    bgView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bgView];
    
    _flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * flashImage = [UIImage imageNamed:@"camera_ico_flash"];
    [_flashBtn setBackgroundImage:flashImage forState:UIControlStateNormal];
    _flashBtn.frame = CGRectMake(20, 64-10-flashImage.size.height, flashImage.size.width, flashImage.size.height);
    [_flashBtn addTarget:self action:@selector(choseFlashBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _flashBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_flashBtn];
    
    UIButton * directionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [directionBtn setBackgroundImage:[UIImage imageNamed:@"camera_icon_camera"] forState:UIControlStateNormal];
    UIImage * directionImage = [UIImage imageNamed:@"camera_icon_camera"];
    directionBtn.frame = CGRectMake(self.view.width-15-directionImage.size.width, 64-10-flashImage.size.height, directionImage.size.width, directionImage.size.height);
    [directionBtn addTarget:self action:@selector(directionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    directionBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:directionBtn];
    self.choseFlashBgView.frame = CGRectMake(_flashBtn.right, _flashBtn.top, self.view.width-_flashBtn.right*2, _flashBtn.height);
    self.choseFlashBgView.clipsToBounds = YES;
    [self.view addSubview:self.choseFlashBgView];
    CGFloat width = self.choseFlashBgView.width/3.0;
    NSArray * titlArr = @[@"自动", @"打开", @"关闭"];
    for (NSInteger i = 0; i < 3; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:titlArr[i] forState:UIControlStateNormal];
        [btn setTitle:titlArr[i] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        btn.frame = CGRectMake(width*i, 0, width, self.choseFlashBgView.height);
        if (i == 0) {
            btn.selected = YES;
        }
        [btn addTarget:self action:@selector(choseFlBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100+i;
        [self.choseFlashBgView addSubview:btn];
    }
    self.choseFlashBgView.width = 0;
}

/**
 *  前置摄像头和后置摄像头江湖切换，默认是后置
 */
- (void)directionBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (_myDevice == [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][0]) {
        // rear active, switch to front
        _myDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][1];
        
        [self.captureSession beginConfiguration];
        AVCaptureDeviceInput * newInput = [AVCaptureDeviceInput deviceInputWithDevice:_myDevice error:nil];
        for (AVCaptureInput * oldInput in self.captureSession.inputs) {
            [self.captureSession removeInput:oldInput];
        }
        [self.captureSession addInput:newInput];
        [self.captureSession commitConfiguration];
    }
    else if (_myDevice == [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][1]) {
        // front active, switch to rear
        _myDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][0];
        [self.captureSession beginConfiguration];
        AVCaptureDeviceInput * newInput = [AVCaptureDeviceInput deviceInputWithDevice:_myDevice error:nil];
        for (AVCaptureInput * oldInput in self.captureSession.inputs) {
            [self.captureSession removeInput:oldInput];
        }
        [self.captureSession addInput:newInput];
        [self.captureSession commitConfiguration];
    }
    if (_myDevice.isFlashAvailable) {
        _flashBtn.hidden = NO;

    } else {
        _flashBtn.hidden = YES;
    }
}


/**
 *  三个按钮的点击事件
 */
- (void)choseFlBtnClicked:(UIButton *)sender
{
    for (NSInteger i = 0; i < 3; i++) {
        UIButton * btn = (UIButton *)[self.choseFlashBgView viewWithTag:100+i];
        btn.selected = NO;
    }
    sender.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.choseFlashBgView.width = 0;
    }];
    switch (sender.tag) {
        case 100://自动
        {
            self.flashType = LHDCameraFlashTypeAuto;
        }
            break;
        case 101://打开
        {
            self.flashType = LHDCameraFlashTypeOpen;
        }
            break;
        case 102://关闭
        {
            self.flashType = LHDCameraFlashTypeOff;
        }
            break;
            
        default:
            break;
    }
}

- (void)setFlashType:(LHDCameraFlashType)flashType
{
    if (flashType == _flashType) {
        return;
    }
    _flashType = flashType;
    NSString * imageName = nil;
    if (flashType == LHDCameraFlashTypeOff) {
        imageName = @"camera_ico_off-flash";
        self.flashMode = AVCaptureFlashModeOff;
    } else if (flashType == LHDCameraFlashTypeAuto) {
        imageName = @"camera_ico_flash";
        self.flashMode = AVCaptureFlashModeAuto;
    } else if (flashType == LHDCameraFlashTypeOpen) {
        imageName = @"camera_ico_on-flash";
        self.flashMode = AVCaptureFlashModeOn;
    }
    [_flashBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self setFlashModel];
}


- (void)setFlashModel
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //必须要先锁定
    [device lockForConfiguration:NULL];
    if ([device hasFlash]) {
        device.flashMode = self.flashMode;
    } else {
        NSLog(@"木有闪光灯");
    }
    [device unlockForConfiguration];
}



/**
 *
 */
- (void)choseFlashBtnClicked:(UIButton *)sender
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSLog(@"相机权限受限");
        return;
    }
    CGFloat choseWidth = self.view.width-_flashBtn.right*2;
    if (self.choseFlashBgView.width > 0) {
        choseWidth = 0;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.choseFlashBgView.width = choseWidth;
    }];
}


/**
 *  初始化底部的取消、拍照按钮
 */
- (void)configBottomViewUI
{
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage * image = [UIImage imageNamed:@"camera_buton_sure"];
    [sureBtn setBackgroundImage:image forState:UIControlStateNormal];
    sureBtn.frame = CGRectMake(0, self.view.height-image.size.height-40, image.size.width, image.size.height);
    sureBtn.centerX = self.view.width/2.0;
    [sureBtn addTarget:self action:@selector(sureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.backgroundColor = [UIColor clearColor];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    cancelBtn.backgroundColor = [UIColor orangeColor];
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    cancelBtn.frame = CGRectMake(sureBtn.left-80,0, 60, 30);
    cancelBtn.centerY = sureBtn.centerY;
    cancelBtn.centerX = sureBtn.left/2.0;
    [self.view addSubview:cancelBtn];
    
    
}


#pragma mark - 取消按钮点击事件
- (void)cancelBtnClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 确定按钮点击事件
- (void)sureBtnClicked
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSLog(@"相机权限受限");
        return;
    }
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _imageOutPut.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }

    WeakSelf;
    [self.imageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        StrongSelf
        if (!error) {//拍照成功
            CFDictionaryRef exifAttachments = CMGetAttachment(imageDataSampleBuffer, kCGImagePropertyExifDictionary, NULL);
            if (exifAttachments) {
            } else {
            }
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            
            UIImage * capturedImage = [[UIImage alloc]initWithData:imageData scale:1];
            
            if (_myDevice == [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][0]) {
                // rear camera active
                if (weakSelf.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
                    CGImageRef cgRef = capturedImage.CGImage;
                    capturedImage = [[UIImage alloc] initWithCGImage:cgRef scale:1.0 orientation:UIImageOrientationUp];
                }
                else if (weakSelf.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
                    CGImageRef cgRef = capturedImage.CGImage;
                    capturedImage = [[UIImage alloc] initWithCGImage:cgRef scale:1.0 orientation:UIImageOrientationDown];
                }
            }
            else if (_myDevice == [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][1]) {
                // front camera active
                // flip to look the same as the camera
                if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
                    capturedImage = [UIImage imageWithCGImage:capturedImage.CGImage scale:capturedImage.scale orientation:UIImageOrientationLeftMirrored];
                else {
                    if (weakSelf.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
                        capturedImage = [UIImage imageWithCGImage:capturedImage.CGImage scale:capturedImage.scale orientation:UIImageOrientationDownMirrored];
                    else if (weakSelf.interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
                        capturedImage = [UIImage imageWithCGImage:capturedImage.CGImage scale:capturedImage.scale orientation:UIImageOrientationUpMirrored];
                }
            }
            capturedImage = [weakSelf crop:capturedImage];
            if (_isNeedEditPhoto) {//需要编辑的时候
                
                CGRect  cFrame = CGRectMake(5, (KScreenHeight-(self.view.width-10)*self.editWideHighRatio)/2.0, self.view.width-10,  (self.view.width-10)*self.editWideHighRatio);
                
                if (_isHeader) {
                    cFrame = CGRectMake((KScreenWidth-300*kScreen6ScaleW)/2.0, (KScreenHeight-300*kScreen6ScaleW)/2.0, 300*kScreen6ScaleW, 300*kScreen6ScaleW);
                }

                
                LHDEditPhotoViewController * edVC = [[LHDEditPhotoViewController alloc] initWithImage:capturedImage editFrame:cFrame limitScaleRatio:3.0];

                [edVC getPhotoEditedImageBlock:^(LHDEditPhotoViewController *epVC, UIImage *editedImage) {
                    weakSelf.cameraBlock(weakSelf,editedImage);
                    [weakSelf cancelBtnClicked];
                }];
                [edVC dismissVCBlock:^(BOOL yes) {
                    if (yes) {
                        [weakSelf.captureSession startRunning];
                    }
                }];
                [strongSelf presentViewController:edVC animated:NO completion:^{
                    
                }];
            } else {//不需要编辑的时候
                LHDCusstomCameraPreviewViewController * cuVC = [[LHDCusstomCameraPreviewViewController alloc] init];
                cuVC.image = capturedImage;
                [cuVC getCusstomCameraPreviewImageBlock:^(LHDCusstomCameraPreviewViewController *cameraPreviewVC, UIImage *image) {
                    strongSelf.cameraBlock(strongSelf,image);
                    [strongSelf cancelBtnClicked];
                }];
                [cuVC dismissVCBlock:^(BOOL yes) {
                    if (yes) {
                        [strongSelf.captureSession startRunning];
                    }
                }];
                [strongSelf presentViewController:cuVC animated:NO completion:^{
                }];
            }
            [strongSelf.captureSession stopRunning];
        }else {//拍照失败
        }
    }];
}


#pragma mark - 处理缩放摄像头
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer {
    BOOL allTouchesAreThePreviewLayer = YES;
    NSUInteger numTouches = [recognizer numberOfTouches];
    for (int i = 0; i<numTouches; ++i) {
        CGPoint location = [recognizer locationOfTouch:i inView:self.previewView];
        CGPoint convertedLocation = [self.previewLayer convertPoint:location fromLayer:self.previewLayer.superlayer];
        if (![self.previewLayer containsPoint:convertedLocation]) {
            allTouchesAreThePreviewLayer = NO;
            break;
        }
    }
    
    if (allTouchesAreThePreviewLayer) {
        self.effectiveScale = self.beginGestureScale * recognizer.scale;
        if (self.effectiveScale < 1) {
            self.effectiveScale = 1;
        }
        CGFloat maxScaleAndFactor = [[self.imageOutPut connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
        
        if (self.effectiveScale > maxScaleAndFactor) {
            self.effectiveScale = maxScaleAndFactor;
        }
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.025];
        [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
        [CATransaction commit];
    }
}

#pragma mark - UIGestureRecognizer 的代理方法，开始触发的时候
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}

- (AVCaptureSession *)captureSession
{
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
    }
    return _captureSession;
}


- (AVCaptureStillImageOutput *)imageOutPut
{
    if (!_imageOutPut) {
        _imageOutPut = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSetting = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
        [_imageOutPut setOutputSettings:outputSetting];
    }
    return _imageOutPut;
}

- (UIView *)previewView
{
    if (!_previewView) {
        _previewView = [[UIView alloc] initWithFrame:self.view.frame];
        _previewView.backgroundColor = [UIColor blackColor];
    }
    return _previewView;
}

- (UIView *)choseFlashBgView
{
    if (!_choseFlashBgView) {
        _choseFlashBgView = [[UIView alloc] initWithFrame:CGRectZero];
        _choseFlashBgView.userInteractionEnabled = YES;
    }
    return _choseFlashBgView;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)cusstomCameraGetPhotoImageBlock:(LHDCusstomCameraGetPhotoImageBlock)block
{
    self.cameraBlock = block;
}

- (UIImage *)crop:(UIImage *)img {
    CGFloat currentScale = [[self.previewView.layer valueForKeyPath:@"transform.scale"] floatValue];
    NSInteger newW = img.size.width / currentScale;
    NSInteger newH = img.size.height / currentScale;
    NSInteger newX1 = (img.size.width / 2) - (newW / 2);
    NSInteger newY1 = (img.size.height / 2) - (newH / 2);
    CGRect rect = { -newX1, -newY1, img.size.width, img.size.height };
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(newW, newH), true, 1.0);
    [img drawInRect:rect];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

- (void)show
{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_fromeViewController) {
                    [_fromeViewController  presentViewController:self animated:YES completion:nil];
                } else{
                    //        [[CusstomWindow getRootViewController]presentViewController:self animated:YES completion:nil];
                }
            });
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [MyAlertView showAlertViewWithTitle:@"无法访问相机" message:@"前往设置开启相机权限？" cancelButtonTitle:@"取消" otherButtonTitle:@[@"确定"] onDismiss:^(int buttonIndex) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if([[UIApplication sharedApplication] canOpenURL:url]) {
                        NSURL *url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        [[UIApplication sharedApplication] openURL:url];
                    }
                } onCancel:^{
                }];
            });
        }
    }];
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
