//
//  ContactTableViewCell.m
//  WeChatContacts-demo
//
//  Created by shen_gh on 16/3/12.
//  Copyright © 2016年 com.joinup(Beijing). All rights reserved.
//

#import "ContactTableViewCell.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation ContactTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //布局View
        [self setUpView];
        self.editing = YES;
//        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - setUpView
- (void)setUpView{
    //头像
    [self.contentView addSubview:self.headImageView];
    //姓名
    [self.contentView addSubview:self.nameLabel];
}
- (UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0.013 * kScreenWidth, 0.0075 *kScreenHeight, 0.1 * kScreenWidth, 0.06 * kScreenHeight)];
        [_headImageView setContentMode:UIViewContentModeScaleAspectFill];
        _headImageView.clipsToBounds = YES;
        _headImageView.backgroundColor = [UIColor purpleColor];
    }
    return _headImageView;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0.133 * kScreenWidth, 0.0075 *kScreenHeight, kScreenWidth-0.16 * kScreenWidth, 0.06 * kScreenHeight)];
        [_nameLabel setFont:[UIFont systemFontOfSize:16.0]];
    }
    return _nameLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
