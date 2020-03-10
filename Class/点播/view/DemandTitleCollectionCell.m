//
//  DemandTitleCollectionCell.m
//  NetCamera
//
//  Created by 汪伟 on 2020/3/3.
//  Copyright © 2020 Guangzhou Eston Trade Co.,Ltd. All rights reserved.
//

#import "DemandTitleCollectionCell.h"


@interface DemandTitleCollectionCell ()

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *lineImageView;

@end
@implementation DemandTitleCollectionCell
-(void)doSetup
{
    [super doSetup];
 
    self.contentView.backgroundColor = UIColorClearColor;
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = kColorThirdTextColor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont customFontWithSize:kFontSizeTwelve];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel centerToView:self.contentView];
    [_titleLabel leftToView:self.contentView withSpace:15];
    [_titleLabel rightToView:self.contentView withSpace:15];

//    [_titleLabel addWidth:70];
//    [_titleLabel addHeight:15];
    
    
    _lineImageView = [UIImageView new];
    _lineImageView.hidden = YES;
    _lineImageView.image = UIImageWithFileName(@"demand_choose_backimage");
    [self.contentView addSubview:_lineImageView];
    [_lineImageView alignTop:nil leading:@"10" bottom:@"0" trailing:@"10" toView:self.contentView];
    [_lineImageView addHeight:2.5];
}

//- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
//{
//    UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
//    CGRect rect = [self.titleLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15) options:NSStringDrawingTruncatesLastVisibleLine|   NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont customFontWithSize:kFontSizeTwelve]} context:nil];
//    rect.size.width +=8;
//    rect.size.height+=8;
//
//    attributes.frame = rect;
//
//    return attributes;
//}
-(void)makeCellData:(NSDictionary *)dic
{
    _titleLabel.text = [dic objectForKey:@"title"];
    BOOL isSelect = [[dic objectForKey:@"select"] boolValue];
//    if (isSelect) {
//        _titleLabel.textColor = kColorMainColor;
//        _lineImageView.hidden = NO;
//    }
}
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) {
        _titleLabel.textColor = kColorMainColor;
        _lineImageView.hidden = NO;
    }else{
        _titleLabel.textColor = kColorThirdTextColor;
        _lineImageView.hidden = YES;
    }
    
    
}
@end
