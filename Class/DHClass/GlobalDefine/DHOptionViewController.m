//
//  AddDeviceViewController.m
//  iDMSS
//
//  Created by nobuts on 12-9-27.
//
//

#import "DHOptionViewController.h"

@interface DHOptionViewController ()

@end

@implementation DHOptionViewController

@synthesize options,delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
//    UIButton *leftBackButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 1, 38, 38)];
//    [leftBackButton setBackgroundImage:[UIImage imageNamed:@"title_back.png"] forState:UIControlStateNormal];
//    [leftBackButton setBackgroundImage:[UIImage imageNamed:@"title_back_h.png"] forState:UIControlStateHighlighted];
//    [leftBackButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBackButton];
//    self.navigationItem.leftBarButtonItem = leftButtonItem;
//    [leftButtonItem release];
//	[leftBackButton release];
//    
//    self.tableView.backgroundColor = [UIColor colorWithRed:253/255.0 green:253/255.0 blue:253/255.0 alpha:1];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    
//    self.tableView.backgroundView = nil;
}

-(void)setnaviTitleColour
{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    title.center = CGPointMake(160, title.center.y);
    title.font = [UIFont systemFontOfSize:18];
    title.textColor = [UIColor blackColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = self.title;
    self.navigationItem.titleView = title;
    [title release];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self setnaviTitleColour];
    
    [self.tableView reloadData];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (IBAction)save:(id)sender
{
    NSArray* tmpArray = [self.selectIndexes sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 intValue] > [obj2 intValue]) {
            return NSOrderedDescending;
        }
        if ([obj1 intValue] < [obj2 intValue]) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
    
    [self.selectIndexes removeAllObjects];
    [self.selectIndexes addObjectsFromArray:tmpArray];

    
	if ([self.delegate respondsToSelector:@selector(Controller:didSelectedIndexes:)])
    {
        [self.delegate Controller:self didSelectedIndexes:self.selectIndexes];
    }

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#ifdef IPHONE5_COMPILE
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)shouldAutorotate
{
    return YES;
}

//- (BOOL)isIOS7
//{
//    float fios = [[[UIDevice currentDevice] systemVersion] floatValue];
//    
//    return fios > 6.9;
//}
#endif
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [options count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

//为了去掉":"
- (void) setOptionControllerTitle:(NSString*) optionTitle
{
    NSRange range = [optionTitle rangeOfString:@":"];
    if (range.location != NSNotFound)
    {
        self.title = [optionTitle substringToIndex:range.location];
    }
    else
    {
        self.title = optionTitle;
    }
}

#pragma mark - Table view delegate



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OptionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
                //cell背景色
                UIView* view = [[UIView alloc]initWithFrame:cell.frame];
                view.backgroundColor =[UIColor colorWithRed:(0xE7)/255.0 green:(0x6C)/255.0 blue:(0x12)/255.0 alpha:1];
                cell.selectedBackgroundView = view;

        //cell分割线
        UIView* bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, cell.frame.size.height - 1, cell.bounds.size.width, 1)];
        bottomLine.backgroundColor = [UIColor colorWithRed:(171)/255.0 green:(171)/255.0 blue:(171)/255.0 alpha:1];
        //        if ([self isIOS7]) {
        //            [cell.contentView  addSubview:bottomLine];
        //        }
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        //        [bottomLine release];
    }
    
    // Configure the cell...
    cell.textLabel.text = [options objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
    cell.textLabel.adjustsFontSizeToFitWidth = TRUE;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    for (NSNumber* selectIndex in self.selectIndexes)
    {
        if ([selectIndex  intValue] == indexPath.row)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.m_nCursel = indexPath;
            break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    NSNumber* curIndex = @(indexPath.row);
    
    if (! self.bMultiSelect) {
        UITableViewCell* preCell = [tableView cellForRowAtIndexPath:self.m_nCursel];
        preCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        [self.selectIndexes removeAllObjects];
        [self.selectIndexes addObject:curIndex];
    }
    else {
        UITableViewCell* curCell = [tableView cellForRowAtIndexPath:indexPath];
        
        if ([self.selectIndexes indexOfObject:curIndex] != NSNotFound)
        {
            curCell.accessoryType = UITableViewCellAccessoryNone;
            [self.selectIndexes removeObject:curIndex];
        }
        else
        {
            curCell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self.selectIndexes addObject:curIndex];
        }
    }
    
    self.m_nCursel = indexPath;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (! self.bMultiSelect) {
        [self save:NULL];
    }
     */
    
    if (! self.bMultiSelect)
    {
        if ([self.selectIndexes count] > 0 )
        {
            int index = [[self.selectIndexes lastObject] intValue];
            NSUInteger indexs[] = {0,index};
            NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:indexs length:2];
            
            UITableViewCell* preCell = [tableView cellForRowAtIndexPath:indexPath];
            preCell.accessoryType = UITableViewCellAccessoryNone;
            
            [self.selectIndexes removeAllObjects];
        }
    }
    
    UITableViewCell* curCell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSNumber* curIndex = [NSNumber numberWithInteger:indexPath.row];
    
    if ([self.selectIndexes indexOfObject:curIndex] != NSNotFound)
    {
        curCell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectIndexes removeObject:curIndex];
    }
    else
    {
        curCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectIndexes addObject:curIndex];
    }
    
    self.m_nCursel = indexPath;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (! self.bMultiSelect) {
        [self save:NULL];
    }
    
    //[self.navigationController popViewControllerAnimated:TRUE];
}

@end
