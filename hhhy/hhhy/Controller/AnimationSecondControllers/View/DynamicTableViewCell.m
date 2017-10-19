//
//  DynamicTableViewCell.m
//  hhhy
//
//  Created by 王长磊 on 2017/7/10.
//  Copyright © 2017年 wangchanglei. All rights reserved.
//

#import "DynamicTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CommonUrl.h"

@interface DynamicTableViewCell()

@end

@implementation DynamicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setDynamicModel:(DynamicModel *)dynamicModel{
    
    [_headImageView sd_setImageWithURL:LOADIMAGE(dynamicModel.photo) placeholderImage:[UIImage imageNamed:@"paishe"]];
    _nameLabel.text = dynamicModel.nick_name;
    _dateLabel.text = dynamicModel.add_time;
    _contentLabel.text = dynamicModel.content;
    _dynamicModel = dynamicModel;
    for (UIView *view in self.contentView.subviews){
        if (view.tag>=500){
            [view removeFromSuperview];
        }
    }
    [self dynamicLayout];
    [self calculateDate];
}

-(void)setContentImageView:(UIImageView *)contentImageView{
    contentImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentImageViewAction:)];
    [contentImageView addGestureRecognizer:tap];
    _contentImageView = contentImageView;
}


//图片点击事件
-(void)contentImageViewAction:(UITapGestureRecognizer *)sender{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i=0;i<_dynamicModel.img_list.count;i++){
        [arr addObject:_dynamicModel.img_list[i][@"img_path"]];
    }
    
    [_delegate showPreviewPhotosViewController:arr withIndex:sender.view.tag-500];
}

-(void)calculateDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *addTimeStr = _dateLabel.text;
    NSDate *addTimeDate = [formatter dateFromString:addTimeStr];
   NSTimeInterval interval = -[addTimeDate timeIntervalSinceNow];
    int days = ((int)interval)/(3600*24);
    int hours = ((int)interval)/3600;
    int minutes = ((int)interval)/60;
    if (interval<60){
        _dateLaterLabel.text = [NSString stringWithFormat:@"%d秒前",(int)interval];
    }
    else if (minutes<60){
        _dateLaterLabel.text = [NSString stringWithFormat:@"%d分钟前",minutes];

    }
    else if (hours<24){
        _dateLaterLabel.text = [NSString stringWithFormat:@"%d小时前",hours];

    }
    else if (days>0){
        _dateLaterLabel.text = [NSString stringWithFormat:@"%d天前",days];
    }
}



/*一张图width=150 height=200               屏幕两端间距 10
  两张图width=100 height=150 图与图间距 10 屏幕两端间距 10
  三张图以上 height = 100 图与图间距 5 屏幕两端间距 10
 */
-(void)dynamicLayout{
    
    CGFloat contentImageViewWidth = (self.contentView.frame.size.width - 5 - 5 - 10 - 10) / 3;

     CGSize contentLabelSize =  [_contentLabel.text boundingRectWithSize:CGSizeMake(_contentLabel.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_contentLabel.font} context:nil].size;
    _contentLabel.frame = CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y, _contentLabel.frame.size.width, ceil(contentLabelSize.height)+1);
    
    dynamicHeight = _contentLabel.frame.origin.y + _contentLabel.frame.size.height;
    
    if (_dynamicModel.img_list.count==1&&![_dynamicModel.img_list[0][@"img_path"]  isEqualToString:@""]){
        
        self.contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, dynamicHeight+10, 150, 200)];
        self.contentImageView.tag = 500;
        [self.contentImageView sd_setImageWithURL:LOADIMAGE(_dynamicModel.img_list[0][@"img_path"]) placeholderImage:[UIImage imageNamed:@"paishe"]];
        [self.contentView addSubview:self.contentImageView];
    }
    
    else if (_dynamicModel.img_list.count==2){
        for (int i=0;i<_dynamicModel.img_list.count;i++){
            self.contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 + i*(100+10), dynamicHeight + 10, 100, 150)];
            self.contentImageView.tag = 500+i;
            [self.contentImageView sd_setImageWithURL:LOADIMAGE(_dynamicModel.img_list[i][@"img_path"]) placeholderImage:[UIImage imageNamed:@"paishe"]];
            [self.contentView addSubview:self.contentImageView];
        }
    }
    else if (_dynamicModel.img_list.count>2&&_dynamicModel.img_list.count<10){
        for (int i=0;i<_dynamicModel.img_list.count;i++){
            int line = i%3;
            int row = i/3;
            self.contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10+line*(contentImageViewWidth+5), dynamicHeight+10+row*(5+100), contentImageViewWidth, 100)];
            self.contentImageView.tag = 500+i;
            [self.contentImageView sd_setImageWithURL:LOADIMAGE(_dynamicModel.img_list[i][@"img_path"]) placeholderImage:[UIImage imageNamed:@"paishe"]];
            [self.contentView addSubview:self.contentImageView];
        }
    }
    else if (_dynamicModel.img_list.count > 9) {
        //大于九张图需要处理
        for (int i=0;i<_dynamicModel.img_list.count;i++){
            int line = i%3;
            int row = i/3;
            self.contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10+line*(contentImageViewWidth+5), dynamicHeight+10+row*(5+100), contentImageViewWidth, 100)];
            self.contentImageView.tag = 500+i;
            [self.contentImageView sd_setImageWithURL:LOADIMAGE(_dynamicModel.img_list[i][@"img_path"]) placeholderImage:[UIImage imageNamed:@"paishe"]];
            [self.contentView addSubview:self.contentImageView];
        }
    }
    if (_dynamicModel.img_list.count>0&&![_dynamicModel.img_list[0][@"img_path"]  isEqualToString:@""]){
    dynamicHeight = self.contentImageView.frame.origin.y + self.contentImageView.frame.size.height + 10 + 16 + 10;
    }
    else{
        dynamicHeight = _contentLabel.frame.origin.y + _contentLabel.frame.size.height + 10 + 16 + 10;
    }

}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
