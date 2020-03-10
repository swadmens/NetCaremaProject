//
//  AddDeviceViewController.h
//  iDMSS
//
//  Created by nobuts on 12-9-27.
//
//

#import <UIKit/UIKit.h>
@class DHOptionViewController;
@protocol OptionViewControllerDelegate <NSObject>

- (void) Controller:(DHOptionViewController*)controller didSelectedIndexes:(NSArray*)indexes;

@end


@interface DHOptionViewController : UITableViewController
{
    NSArray* options;
    id<OptionViewControllerDelegate> delegate;
}

@property (nonatomic,retain) NSArray* options;
@property (nonatomic,retain) NSMutableArray* selectIndexes;
@property (nonatomic,assign) id delegate;
@property (nonatomic,assign) BOOL bMultiSelect;

@property (nonatomic,retain) NSIndexPath* m_nCursel;

//为了去掉":"
- (void) setOptionControllerTitle:(NSString*) optionTitle;

@end
