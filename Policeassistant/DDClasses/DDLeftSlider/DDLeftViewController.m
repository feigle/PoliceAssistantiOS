//
//  DDLeftViewController.m
//  Policeassistant
//
//  Created by DoorDu on 16/7/1.
//  Copyright © 2016年 DoorDu. All rights reserved.
//

#import "DDLeftViewController.h"
#import "DDChangePwdViewController.h"
#import "DDLoginVC.h"
#import "DDLeftSliderManger.h"

@interface DDLeftViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIButton *iconbtn;
}

@property (nonatomic, strong) NSArray  *titleListArray;
@property (nonatomic, strong) UIImageView  *avatarImageView;
@property (nonatomic, strong) UIView  *headView;
@property (nonatomic, strong) UIView  *footView;

@end

@implementation DDLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationController.navigationBarHidden = NO;
    _titleListArray = @[
                        @{@"image":@"monad",@"type":@"隶属单位：南头派出所"},
                        @{@"image":@"jurisdiction",@"type":@"管辖片区：桃园片区"},
                        @{@"image":@"change_ password",@"type":@"修改密码"}
                        ];
    
    _listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width*0.75, self.view.frame.size.height) style:UITableViewStylePlain];
    _listTableView.dataSource = self;
    _listTableView.delegate = self;
    _listTableView.backgroundColor=RGB(10, 9, 25);
    _listTableView.tableFooterView = [UIView new];
    _listTableView.rowHeight=60;
    _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;    [self.view addSubview:_listTableView];
    _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, KScreenHeight*0.2)];
    _headView.backgroundColor=RGB(33, 34, 50);
    _listTableView.tableHeaderView=_headView;
    
    [self creatTableViewheadview];
    _footView=[[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight-89, self.view.frame.size.width, 89)];
    _footView.backgroundColor=RGB(10, 9, 25);
    [self.view addSubview:_footView];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width , 1)];
    line.backgroundColor=UIColorFromRGB(0x4F4F4C);
    [_footView addSubview:line];
    
    UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(30, 33, 22, 22)];
    imageview.image=[UIImage imageNamed:@"logout"];
    [_footView addSubview:imageview];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(60, 0, 200, 89)];
    label.text=@"退出账号";
    label.font=sysFont18;
    label.textColor=[UIColor whiteColor];
    [_footView addSubview:label];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushtootherVC)];
    [_footView addGestureRecognizer:tap];
    
    self.view.frame = CGRectMake(-(self.view.frame.size.width - self.view.frame.size.width / 4), 0, self.view.frame.size.width - self.view.frame.size.width / 4, self.view.frame.size.height);
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _titleListArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentify = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (nil == cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    cell.backgroundColor = RGB(10, 9, 25);
    NSDictionary *dict=_titleListArray[indexPath.row];
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.imageView.image=[UIImage imageNamed:dict[@"image"]];
    if (indexPath.row==0) {
        cell.selectionStyle=UITableViewCellEditingStyleNone;
        cell.textLabel.text =[NSString stringWithFormat:@"隶属单位：%@",[DDUserDefault getLoginInformation][@"agent_name"]];
        cell.textLabel.numberOfLines=0;
    }
    else if (indexPath.row==1) {
        cell.selectionStyle=UITableViewCellEditingStyleNone;
        cell.textLabel.text = [NSString stringWithFormat:@"管辖片区：%@",[DDUserDefault getLoginInformation][@"area_name"]];
        cell.textLabel.numberOfLines=0;
    }else if (indexPath.row==2) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = dict[@"type"];
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==2) {
        DDChangePwdViewController *vc = [[DDChangePwdViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [[DDLeftSliderManger sharedInstance].LeftSlideVC closeLeftView];//关闭左侧抽屉
        [[DDLeftSliderManger sharedInstance].mainNavigationController pushViewController:vc animated:NO];
    }
    
}
-(void)creatTableViewheadview{
    iconbtn=[[UIButton alloc]initWithFrame:CGRectMake(25, (KScreenHeight*0.2-73)/2, 73, 73)];
    iconbtn.layer.masksToBounds = YES;
    iconbtn.layer.cornerRadius = 73/2;
    [iconbtn setImage:[UIImage imageNamed:@"main_icon"] forState:UIControlStateNormal];
    [iconbtn addTarget:self action:@selector(changiconimage) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:iconbtn];
    
    NSString *str1=[NSString stringWithFormat:@"%@",[DDUserDefault getLoginInformation][@"real_name"]];
    DDLabel *lab=[[DDLabel alloc]initWithAlertViewHeight:17 mycolor:[UIColor whiteColor] myfram:CGRectMake(113, CGRectGetMinY(iconbtn.frame)+15, KScreenWidth*3/4-125, 50) mytext:str1];
    lab.numberOfLines=0;
    [_headView addSubview:lab];
    
    UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(118, CGRectGetMaxY(lab.frame)+12, 22, 22)];
    imageview.image=[UIImage imageNamed:@"Job_Title"];
   // [_headView addSubview:imageview];
    
  //  DDLabel *lab1=[[DDLabel alloc]initWithAlertViewHeight:14 mycolor:[UIColor whiteColor] myfram:CGRectMake(118, CGRectGetMaxY(lab.frame)+15, 200, 16) mytext:@"编号：NO.95427"];
  //  [_headView addSubview:lab1];
}
- (void)pushtootherVC{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"确定退出登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"clickedButtonAtIndex:%ld",(long)buttonIndex);
    switch (buttonIndex) {
        case 0:
            return;
            break;
            
        case 1:
            [self logoutfrom];
            break;
        default:
            break;
    }
}
- (void)logoutfrom{
//    DDLoginVC *vc = [[DDLoginVC alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [[DDLeftSliderManger sharedInstance].LeftSlideVC closeLeftView];//关闭左侧抽屉
//    [[DDLeftSliderManger sharedInstance].mainNavigationController pushViewController:vc animated:NO];
    [DDUserDefault setLogin:NO];
    [DDUserDefault setIdentityType:PoliceAssistantNoLoginType];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@(PoliceAssistantNoLoginType)];

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [self sendDeviceToken:@""];
}
- (void)sendDeviceToken:(NSString*)device_token{
    [SVProgressHUD showWithStatus:@"正在退出..."];
    NSString *urlStr=[NSString stringWithFormat:@"%@",API_BASE_URL(@"v1/site/getiosdevicetoken")];
    AFHTTPSessionManager *Afmanger=[DDNetManger sharedAFManager];
    [Afmanger.requestSerializer setAuthorizationHeaderFieldWithUsername:[DDUserDefault getUserName] password:[DDUserDefault getPwd]];
    NSMutableDictionary *dicts = [NSMutableDictionary dictionaryWithObjectsAndKeys:device_token,@"devicetoken",nil];
    [DDNetManger ba_requestWithType:DDHttpRequestTypeGet withUrlString:urlStr withParameters:dicts withSuccessBlock:^(id response){
        [SVProgressHUD dismiss];
        NSDictionary *dict=response;
        if (dict) {
            NSDictionary *dic=[dict objectForKey:@"response_params"];
            NSNumber *msgCode =[dic objectForKey:@"error_code"];
            NSString *msg=[NSString stringWithFormat:@"%@",msgCode];
            if ([Error_Code_Success isEqualToString:msg]) {
                [SVProgressHUD dismiss];
                
            }
            else if ([Error_Code_Failed isEqualToString:msg]){
//                [DDProgressHUD showCenterWithText:@"账号密码错误" duration:2.0];
            }else if ([Error_Code_RequestError isEqualToString:msg]){
//                [DDProgressHUD showCenterWithText:@"账号密码错误" duration:2.0];
            }
            
        }else{
            
        }
        NSLog(@"post请求数据成功： *** %@", response);
    }withFailureBlock:^(NSError *error){
        [SVProgressHUD dismiss];
        //  [DDProgressHUD showCenterWithText:@"网络异常" duration:2.0];
    }progress:^(int64_t bytesProgress, int64_t totalBytesProgress){
        
    }];
    
}

- (void)changiconimage{
    NSLog(@"gaitouxiang");
    /*
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照", @"从相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    */
//    [sheet showInView:self.view];
}

#pragma mark - action sheet delegte
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    return;
                case 1: //相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 2: //相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}
#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [iconbtn setImage:image forState:UIControlStateNormal];
  //  userImageView.image = image;
    
 //   NSData *imageData = UIImageJPEGRepresentation(image, COMPRESSED_RATE);
 //   UIImage *compressedImage = [UIImage imageWithData:imageData];
    
  //  [HttpRequestManager uploadImage:compressedImage httpClient:self.httpClient delegate:self];
    
}
@end
