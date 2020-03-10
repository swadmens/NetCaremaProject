//
//  DHHudPrecess.m
//  iDMSS
//
//  Created by nobuts on 13-4-1.
//
//

#import "DHHudPrecess.h"

@implementation DHHudPrecess


SYNTHESIZE_SINGLETON_FOR_CLASS(DHHudPrecess);

- (id)init
{
	if((self = [super init]))
    {
       
	}
	
	return self;
}


- (void) ShowTips:(NSString*)strTips  delayTime:(NSTimeInterval)delay  atView:(UIView*)pView
{
    if (HUD != NULL &&  HUD.superview)
    {
        HUD.mode = MBProgressHUDModeText;
        HUD.labelText = strTips;
        
        sleep(delay);
    }
    else
    {
        
        if (pView == NULL)
        {
            UIWindow* max = nil;
            UIWindowLevel level = -3;
            for (UIWindow* wind in [UIApplication sharedApplication].windows)
            {
                if (wind.windowLevel > level&&wind.hidden == NO )
                {
                    max = wind;
                    level = wind.windowLevel;
                }
            }
            pView = max;
        }
        MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:pView animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = strTips;
        //hud.detailsLabelText = strTips;
        hud.margin = 10.f;
        hud.yOffset = 50.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:delay];
    }
}


- (void) showWaiting:(NSString*)strTips WhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated   atView:(UIView*)pView
{
    if (pView == NULL)
    {
        UIWindow* max = nil;
        UIWindowLevel level = -3;
        for (UIWindow* wind in [UIApplication sharedApplication].windows)
        {
            if (wind.windowLevel > level&&wind.hidden == NO )
            {
                max = wind;
                level = wind.windowLevel;
            }
        }
        pView = max;
        //pView = [[UIApplication sharedApplication] keyWindow];
    }
    
    HUD = [[MBProgressHUD alloc] initWithView:pView];
    HUD.delegate = self;
   
	[pView addSubview:HUD];
	
	HUD.labelText = strTips;
	
	[HUD showWhileExecuting:method onTarget:target withObject:object animated:animated];
}

- (void) showProgress:(NSString*)strTips WhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated   atView:(UIView*)pView
{
    if (pView == NULL)
    {
        UIWindow* max = nil;
        UIWindowLevel level = -3;
        for (UIWindow* wind in [UIApplication sharedApplication].windows)
        {
            if (wind.windowLevel > level&&wind.hidden == NO )
            {
                max = wind;
                level = wind.windowLevel;
            }
        }
        pView = max;
       // pView = [[UIApplication sharedApplication] keyWindow];
    }
    
    HUD = [[MBProgressHUD alloc] initWithView:pView];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeDeterminate;
    
	[pView addSubview:HUD];
	
	HUD.labelText = strTips;
	
	[HUD showWhileExecuting:method onTarget:target withObject:object animated:animated];
}

- (void) updateProgress:(float)progress
{
    if (HUD != NULL &&  HUD.superview)
    {
        HUD.progress = progress;
    }
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	[HUD release];
	HUD = nil;
}

@end
