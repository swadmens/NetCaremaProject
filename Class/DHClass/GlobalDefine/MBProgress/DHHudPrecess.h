//
//  DHHudPrecess.h
//  iDMSS
//
//  Created by nobuts on 13-4-1.
//
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "SynthesizeSingleton.h"

@interface DHHudPrecess : NSObject<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(DHHudPrecess);

- (void) ShowTips:(NSString*)strTips  delayTime:(NSTimeInterval)delay atView:(UIView*)pView;

- (void) showWaiting:(NSString*)strTips WhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated  atView:(UIView*)pView;

- (void) showProgress:(NSString*)strTips WhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated  atView:(UIView*)pView;

- (void) updateProgress:(float)progress;

@end

#define MSG(title,msg,ok) if(msg != nil && [msg length]>0) do { [[DHHudPrecess sharedInstance] ShowTips:msg delayTime:1.5  atView:nil];} while(0)
