//
//  DDLandlordSelfHelpAuthorizationComplementViewController.h
//  Policeassistant
//
//  Created by 刘和东 on 2017/3/6.
//  Copyright © 2017年 DoorDu. All rights reserved.
//

#import "HttpRequestViewController.h"
#import "DDLandlordSelfHelpAuthorizationModel.h"

@interface DDLandlordSelfHelpAuthorizationComplementViewController : HttpRequestViewController
/**授权模型*/
@property (nonatomic,strong) DDLandlordSelfHelpAuthorizationModel * authorizationModel;

@end
