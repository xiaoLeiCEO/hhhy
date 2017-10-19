//
//  CommonUrl.h
//  hhhy
//
//  Created by 王长磊 on 2017/6/30.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#ifndef CommonUrl_h
#define CommonUrl_h
//http://www.hahahuyu.com/api/hd/index.php?mark=0&&f=10&&cat_id=&&token=9f829ff261f7fcfa41dfcb2bff4f99b4&&page=12
//正式域名

#define DOMAINURL @"http://www.hahahuyu.com/"
#define JAVAURL @"http://oms.hahahuyu.com/"
#define LOADIMAGE(a) [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DOMAINURL,(a)]]
//用户注册
#define WLRegisterURL DOMAINURL@"api/hd/user/register.php"
//用户登录
#define WLLoginURL DOMAINURL@"api/hd/user/login.php"
//发送短信
#define WLSendMessageURL DOMAINURL@"api/hd/user/send_msg.php"
//退出登录
#define WLLogOutURL DOMAINURL@"api/hd/user/logout.php"
//上传头像
#define WLUploadHeadImgURL DOMAINURL@"api/hd/user/upload.php"

//活动、赛事列表
#define WLEventsListURL DOMAINURL@"api/hd/index.php"
//活动、赛事详情列表
#define WLEventsDetailURL DOMAINURL@"api/hd/detail.php"
//查询用户是否参与此赛事或活动
#define WLIsParticipateURL DOMAINURL@"api/hd/sign.php"

//存储通讯录字符
//#define WLAddressBookURL DOMAINURL@"api/hd/user/getstr.php"
//忘记密码，修改密码，个人信息，编辑个人资料
#define WLUserInfoURL DOMAINURL@"api/hd/user/user.php"
////实名认证，添加绑定银行卡，绑定银行卡列表
//#define WLRealNameAuthenticationURL DOMAINURL@"api/hd/user/cards.php"
////我的订单,添加订单,支付订单,删除订单
#define WLOrderURL DOMAINURL@"api/hd/order.php"
//获取活动票券
#define WLTicketListURL DOMAINURL@"api/hd/sign.php"
//上传视频
#define WLUploadVideoURL DOMAINURL@"api/hd/add_video.php"

//打赏
#define WLRewardURL DOMAINURL@"api/hd/a_reward.php"


////添加收藏,取消收藏,收藏列表
#define WLCollectURL DOMAINURL@"api/hd/shoucang.php"

////官方媒体栏目列表
//#define WLOfficialMediaColumnsURL DOMAINURL@"hdoms.momohudong.com/hd/Android/lanmu?siteId=6"
////官方媒体文章名称
//#define WLOfficialMediaArticleURL DOMAINURL@"hdoms.momohudong.com/hd/Android/title"
////官方媒体文章内容接口
//#define WLOfficialMediaContentURL DOMAINURL@"hdoms.momohudong.com/hd/Android/content"


//自媒体文章列表接口,自媒体特定人文章列表接口
#define WLWeMediaArticleURL DOMAINURL@"api/hd/my_zi_media.php"
//自媒体文章详情（调用H5）
//#define WLWeMediaArticleDetailURL DOMAINURL@"http://momohudong.com/hd/zi_media_article.php"
//我的日志发布，日志详情，日志列表，日志删除，发布动态，动态列表
#define WLLogURL DOMAINURL@"api/hd/myblog.php"
//账户记录
#define WLRecodeURL DOMAINURL@"api/hd/record.php"

//选手报名列表
#define WLPlayerListURL DOMAINURL@"api/hd/match_list.php"

//活动赛事详情视频列表
#define WLEventsDetailVideoURL DOMAINURL@"api/hd/get_video.php"
//获取分类形式
//#define WLColumnsCategoryURL DOMAINURL@"api/hd/category.php"
//添加，回复话题,话题留言列表
//#define WLCommentURL DOMAINURL@"api/hd/comment.php"
//关注，取消关注
//#define WLAttentionURL DOMAINURL@"api/hd/follow.php"
//打赏
//#define WLRewardURL DOMAINURL@"api/hd/a_reward.php"
//媒体文章列表
#define WLMediaAtricleURL DOMAINURL@"api/hd/meiti_article.php"

//APP版本信息
//#define WLAPPVersionURL DOMAINURL@"api/hd/version.php"
//图片上传（单图）
#define WLUploadImgURL DOMAINURL@"api/hd/myblog.php"


//个人中心相册列表
#define WLMinePhotosURL DOMAINURL@"api/hd/album.php"

//视频上传,视频列表
//#define WLUploadVedioURL DOMAINURL@"api/hd/vedio.php"

//搜索要添加的好友,添加好友,删除好友,我的好友组列表,新建好有组,编辑好友组
//#define WLFriendURL DOMAINURL@"api/hd/friend.php"

////发送好友私信	55
//#define WLLoginURL DOMAINURL@"api/hd/user/register.php"
////我的私信列表	55
//#define WLLoginURL DOMAINURL@"api/hd/user/register.php"
////移动到好友组	55
//#define WLLoginURL DOMAINURL@"api/hd/user/register.php"
//删除好友组	57
//#define WLLoginURL DOMAINURL@"api/hd/user/register.php"
////好友组内成员列表	57
//#define WLLoginURL DOMAINURL@"api/hd/user/register.php"

////充值接口
#define WLRechargeURL DOMAINURL@"api/hd/recharge.php"
////支付宝接口	59
//#define WLAliPayURL DOMAINURL@"api/hd/AliPay.php"
////开通服务商户接口	60
//#define WLOpenServiceURL DOMAINURL@"api/shop/fuwu_shop.php"
////省市县三级联动接口	61
//#define WLRegionURL DOMAINURL@"api/shop/get_region.php"


#endif /* CommonUrl_h */
