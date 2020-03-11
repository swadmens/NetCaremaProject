//
//  BECheckBox.m
//  
//
//  Created by jordenwu-Mac on 10-11-11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "BECheckBox.h"
@implementation BECheckBox

@synthesize isChecked;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
        self.unCheckedImage = [UIImage imageNamed:@"login_remember_n.png"];//默认未选中图片
        self.checkedImage   = [UIImage imageNamed:@"login_remember_h.png"];//默认选中图片
		self.contentHorizontalAlignment  = UIControlContentHorizontalAlignmentLeft;		
		[self setImage:_unCheckedImage forState:UIControlStateNormal];
		[self addTarget:self action:@selector(checkBoxClicked) forControlEvents:UIControlEventTouchUpInside];
	}
    return self;
}

-(void)setTarget:(id)tar fun:(SEL)ff
{
	target=tar;
	fun=ff;
}

-(void)setIsChecked:(BOOL)check
{   
	isChecked=check;
	if (check) {
		[self setImage:_checkedImage forState:UIControlStateNormal];
		
	}
	else {
		[self setImage:_unCheckedImage forState:UIControlStateNormal];
	}
}

-(IBAction) checkBoxClicked
{
	if(self.isChecked ==NO){
		self.isChecked =YES;
		[self setImage:_checkedImage forState:UIControlStateNormal];
		
	}else{
		self.isChecked =NO;
		[self setImage:_unCheckedImage forState:UIControlStateNormal];
		
	}
	[target performSelector:fun];
}

- (void)dealloc {
	target=nil;
    self.unCheckedImage = nil;
    self.checkedImage = nil;
    
    [super dealloc];
}


@end

