//
//  PickerDataTableView.m
//  PickerLikeAndroid https://github.com/Ericfengshi/PickerLikeAndroid
//
//  Created by fengs on 15-1-3.
//  Copyright (c) 2015年 fengs. All rights reserved.
//

#import "PickerDataTableView.h"
#import <QuartzCore/QuartzCore.h>

#define cellHeightSpace_ 44.0f
#define headerFooterSpace_ 22.0f

@implementation PickerDataTableView
@synthesize window;
@synthesize shadowView = _shadowView;
@synthesize dataTableView = _dataTableView;
@synthesize listArray = _listArray;
@synthesize row = _row;

-(void)dealloc{
    
    self.shadowView = nil;
    self.dataTableView = nil;
    self.listArray = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame delegate:(id<PickerDataTableViewDelegate>)delegate array:(NSArray*)array row:(NSInteger)row
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
        if ([appDelegate respondsToSelector:@selector(window)]){
            window = [appDelegate performSelector:@selector(window)];
        }else{
            window = [[UIApplication sharedApplication] keyWindow];
        }
        self.shadowView = [[[UIView alloc] initWithFrame:window.frame] autorelease];
        self.shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        UITapGestureRecognizer *tapTouches = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTouches:)];
        [self.shadowView addGestureRecognizer:tapTouches];
        tapTouches.delegate = self;
        tapTouches.cancelsTouchesInView = NO;
        [tapTouches release];
        
        self.delegate = delegate;
        self.listArray = [[[NSArray alloc] init] autorelease];
        self.listArray = array;
        
        self.row = row;
        
        /*UITableView*/
        CGFloat tableViewHeight = self.listArray.count*cellHeightSpace_;
        if(tableViewHeight > [UIScreen mainScreen].applicationFrame.size.height - headerFooterSpace_*2){
            tableViewHeight = [UIScreen mainScreen].applicationFrame.size.height - headerFooterSpace_*2;
        }
        UITableView *tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, tableViewHeight) style:UITableViewStylePlain] autorelease];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.scrollEnabled = YES;
        tableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.layer.borderColor = [[UIColor grayColor] CGColor];
        tableView.layer.cornerRadius = 10.0f;
        tableView.layer.borderWidth = 1.0f;
        self.dataTableView = tableView;
        [self addSubview:self.dataTableView];
        
        [self setFrame:CGRectMake(([UIScreen mainScreen].applicationFrame.size.width - self.dataTableView.frame.size.width)/2, 20+([UIScreen mainScreen].applicationFrame.size.height - self.dataTableView.frame.size.height)/2, self.dataTableView.frame.size.width, self.dataTableView.frame.size.height)];
    }
    return self;
}

#pragma mark -
#pragma mark - UIGestureRecognizerDelegate
-(void)tapTouches:(UITapGestureRecognizer*)recognizer
{
    [self hideView];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if(touch.view != self.shadowView){
        return NO;
    }else
        return YES;
}

#pragma mark -
#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return cellHeightSpace_;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *  cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" ] autorelease];
    cell.textLabel.text = [self.listArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    if (self.row == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(selectRow:)]) {
        [self.delegate selectRow:indexPath.row];
    }
    [self hideView];
}

#pragma mark -
#pragma mark - UIView show/dismiss

/**
 * UIView show
 * @return
 */
- (void)showInView{
    
    [self.shadowView setFrame:window.frame];
    [window addSubview:self.shadowView];
    
    [self setFrame:CGRectMake(([UIScreen mainScreen].applicationFrame.size.width - self.dataTableView.frame.size.width)/2, 20+([UIScreen mainScreen].applicationFrame.size.height - self.dataTableView.frame.size.height)/2, self.dataTableView.frame.size.width, self.dataTableView.frame.size.height)];
    [self.shadowView addSubview:self];
    
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^(void){
        self.shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
    } completion:^(BOOL isFinished){
        
    }];
}

/**
 * hide UIView
 * @return
 */
-(void)hideView
{
    [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^(void){
        [self.shadowView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        self.shadowView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL isFinished){
        [window removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self hideView];
}
@end
