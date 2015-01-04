//
//  PickerLikeAndroidView.m
//  PickerLikeAndroid https://github.com/Ericfengshi/PickerLikeAndroid
//
//  Created by fengs on 14-12-30.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import "PickerLikeAndroidView.h"
#import <QuartzCore/QuartzCore.h>

#define leftRightSpace_ 22.0f
#define headerFooterSpace_ 22.0f
#define cellWidthSpace_ ([UIScreen mainScreen].applicationFrame.size.width - leftRightSpace_ - leftRightSpace_)
#define cellHeightSpace_ 44.0f
#define gapSpace_ 10.0f
#define cellTitleWidthSpace_ 60.0f
#define cellValueWidthSpace_ ([UIScreen mainScreen].applicationFrame.size.width - cellTitleWidthSpace_ - leftRightSpace_ - leftRightSpace_)

@implementation PickerLikeAndroidView
@synthesize window;
@synthesize shadowView = _shadowView;
@synthesize dataTableView = _dataTableView;
@synthesize titleLabel = _titleLabel;
@synthesize messageLabel = _messageLabel;
@synthesize textTitleArray = _textTitleArray;
@synthesize numberOfComponents = _numberOfComponents;
@synthesize contentView = _contentView;
@synthesize rowArray = _rowArray;

-(void)dealloc{
    
    self.shadowView = nil;
    self.dataTableView = nil;
    self.titleLabel = nil;
    self.messageLabel = nil;
    self.textTitleArray = nil;
    self.contentView = nil;
    self.rowArray = nil;

    [super dealloc];
}

#pragma mark -
#pragma mark - view init
/**
 * view init
 * @param title
 * @param message
 * @param delegate
 * @param textTitleArray
 * @param numberOfComponents
 * @return id
 */
- (id)initWithTitle:(NSString*)title message:(NSString*)message delegate:(id<PickerLikeAndroidViewDelegate>)delegate textTitleArray:(NSMutableArray*)textTitleArray numberOfComponents:(NSInteger)numberOfComponents{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
        if ([appDelegate respondsToSelector:@selector(window)]){
            window = [appDelegate performSelector:@selector(window)];
        }else{
            window = [[UIApplication sharedApplication] keyWindow];
        }
        
        self.numberOfComponents = numberOfComponents;
        
        self.shadowView = [[[UIView alloc] initWithFrame:window.frame] autorelease];
        self.shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        self.delegate = delegate;
        self.textTitleArray = [[[NSMutableArray alloc] init] autorelease];
        self.textTitleArray = textTitleArray;
        
        self.rowArray = [[[NSMutableArray alloc] init] autorelease];
        
        self.contentView = [[[UIView alloc] init] autorelease];
        self.contentView.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0];
        self.contentView.layer.borderColor = [[UIColor grayColor] CGColor];
        self.contentView.layer.cornerRadius = 10.0f;
        self.contentView.layer.borderWidth = 1.0f;
    
        CGFloat tempHeight = 0;
        /*title*/
        if(title){
            UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidthSpace_, cellHeightSpace_)] autorelease];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
            titleLabel.textAlignment = UITextAlignmentCenter;
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.numberOfLines = 1;
            titleLabel.text = title;

            self.titleLabel = titleLabel;
            tempHeight = self.titleLabel.frame.size.height;
            
            [self.contentView addSubview:self.titleLabel];
        }
        /*message*/
        if(message){
            // messageLabel default height：33.0f
            CGFloat height = [self resizeViewHeight:message width:cellWidthSpace_- gapSpace_*2 height:33];
            CGFloat originHeight = gapSpace_;
            if(title){
                originHeight = 0;
            }
            UILabel *messageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(gapSpace_, originHeight+tempHeight, cellWidthSpace_- gapSpace_*2, height)] autorelease];
            
            messageLabel.backgroundColor = [UIColor clearColor];
            messageLabel.font = [UIFont systemFontOfSize:13.0f];
            messageLabel.textAlignment = UITextAlignmentCenter;
            messageLabel.textColor = [UIColor blackColor];
            messageLabel.numberOfLines = 0;
            messageLabel.text = message;
            
            self.messageLabel = messageLabel;
            tempHeight += height + originHeight + gapSpace_;
            
            [self.contentView addSubview:self.messageLabel];
        }
        
        if (tempHeight != 0) {
            [self.contentView addSubview:[self drawImageView:CGRectMake( 0, tempHeight-1, cellWidthSpace_, 1)]];
        }
        
        /*UITableView*/
        CGFloat tableViewHeight = self.numberOfComponents*cellHeightSpace_;
        if(tableViewHeight > [UIScreen mainScreen].applicationFrame.size.height - 44.0/*Top navigationbar*/ - headerFooterSpace_*2 - 44.0/*bottom navigationbar*/ - tempHeight/*title,message*/ - 44.0/*UIToolbar*/){
            tableViewHeight = [UIScreen mainScreen].applicationFrame.size.height - 44.0 - headerFooterSpace_*2 - 44.0 - tempHeight - 44.0;
        }
        UITableView *tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, tempHeight, cellWidthSpace_, tableViewHeight) style:UITableViewStylePlain] autorelease];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.scrollEnabled = YES;
        tableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        tableView.dataSource = self;
        tableView.delegate = self;
        self.dataTableView = tableView;
        [self.contentView addSubview:self.dataTableView];
        
        tempHeight += tableViewHeight;
        
        /*UIButton*/
        UIView *btnView = [[[UIView alloc] initWithFrame:CGRectMake(0, tempHeight, cellWidthSpace_, cellHeightSpace_)] autorelease];
        UIButton *leftBtn = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, cellWidthSpace_/2, cellHeightSpace_)] autorelease];
        UILabel *leftLabel = [[[UILabel alloc] initWithFrame:leftBtn.frame] autorelease];
        leftLabel.backgroundColor = [UIColor clearColor];
        leftLabel.font = [UIFont systemFontOfSize:16.0f];
        leftLabel.textAlignment = UITextAlignmentCenter;
        leftLabel.textColor = [UIColor colorWithRed:0/255.0f green:122/255.0f blue:255/255.0f alpha:1.0];
        leftLabel.numberOfLines = 0;
        leftLabel.text = @"取消";
        [leftBtn addSubview:leftLabel];
        [leftBtn addTarget:self action:@selector(actionCancel) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:leftBtn];
        
        UIButton *rightBtn = [[[UIButton alloc] initWithFrame:CGRectMake(cellWidthSpace_/2+1, 0, cellWidthSpace_/2-1, cellHeightSpace_)] autorelease];
        UILabel *rightLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidthSpace_/2-1, cellHeightSpace_)] autorelease];
        rightLabel.backgroundColor = [UIColor clearColor];
        rightLabel.font = [UIFont systemFontOfSize:16.0f];
        rightLabel.textAlignment = UITextAlignmentCenter;
        rightLabel.textColor = [UIColor colorWithRed:0/255.0f green:122/255.0f blue:255/255.0f alpha:1.0];
        rightLabel.numberOfLines = 0;
        rightLabel.text = @"确定";
        [rightBtn addSubview:rightLabel];
        [rightBtn addTarget:self action:@selector(actionDone) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:rightBtn];
        
        [btnView addSubview:[self drawImageView:CGRectMake( 0, 0, cellWidthSpace_, 1)]];
        [btnView addSubview:[self drawImageView:CGRectMake( cellWidthSpace_/2, 0, 1, cellHeightSpace_)]];
        [self.contentView addSubview:btnView];

        tempHeight += cellHeightSpace_;
        
        [self.contentView setFrame:CGRectMake(0,  0, cellWidthSpace_, tempHeight)];
        [self addSubview:self.contentView];
        

        [self setFrame:CGRectMake(leftRightSpace_,  20+([UIScreen mainScreen].applicationFrame.size.height - self.contentView.frame.size.height)/2, cellWidthSpace_, self.contentView.frame.size.height)];
    }
    return self;
}

- (void)viewLoad:(NSMutableArray*)rowArray{
    if (rowArray.count>0) {
        self.rowArray = [[rowArray mutableCopy] autorelease];
    }else{
        [self.rowArray removeAllObjects];
        for (int i=0; i<self.numberOfComponents; i++) {
            [self.rowArray addObject:[NSNumber numberWithInt:0]];
        }
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.dataTableView reloadData];
        });
    });
}

#pragma mark -
#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.numberOfComponents;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" ] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *title = @"";
    if (self.textTitleArray.count > indexPath.row) {
        title = [self.textTitleArray objectAtIndex:indexPath.row];
    }
    UIView *view = [self drawTableViewCellWithTitle:title selectRow:[[self.rowArray objectAtIndex:indexPath.row] integerValue] inComponent:indexPath.row];
    if (indexPath.row != 0) {
        [view addSubview:[self drawImageView:CGRectMake( 0, 0, cellWidthSpace_, 1)]];
    }
    
    cell.accessoryView = view;
    
    return cell;
}

#pragma mark -
#pragma mark - draw UITableViewCell

/*
 * UITableViewCell 生成 
 * @param textTitle : textTitle
 * @param textValue : textValue
 * @param tag : tag
 * @return UIView
 */
-(UIView*)drawTableViewCellWithTitle:(NSString*)textTitle selectRow:(NSInteger)selectRow inComponent:(NSInteger)component{
    
    CGFloat cellHeight = cellHeightSpace_;
    UIView *view =  [[[UIView alloc] initWithFrame:CGRectMake(0, 0, cellWidthSpace_, cellHeightSpace_)] autorelease];
    
    UILabel *label = [self drawLabelWithFrame:CGRectMake(0, 0, cellTitleWidthSpace_, cellHeight) text:textTitle];
    [view addSubview:label];
    
    UITextField *textField = [self drawTextFieldWithFrame:CGRectMake( cellTitleWidthSpace_+5, 5, cellValueWidthSpace_-10, cellHeight-10) selectRow:selectRow inComponent:component];
    [view addSubview:textField];
    
    return view ;
}

/*
 * UILabel 生成
 * @param rect : CGRect
 * @param text : text
 * @return UILabel
 */
- (UILabel *)drawLabelWithFrame:(CGRect)rect text:(NSString *)text{
    UILabel *label = [[[UILabel alloc] initWithFrame:rect] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.lineBreakMode = UILineBreakModeTailTruncation;
    label.numberOfLines = 1;
    label.font = [UIFont systemFontOfSize:13.0];
    label.text = text;
    return label;
}

/*
 * UITextField 生成
 * @param rect : CGRect
 * @param text : text
 * @param tag : tag
 * @return UILabel
 */
- (UITextField *)drawTextFieldWithFrame:(CGRect)rect selectRow:(NSInteger)row inComponent:(NSInteger)component{
    UITextField *textField = [[[UITextField alloc] initWithFrame:rect] autorelease];
    UIImage *bgImage = [UIImage imageNamed:@"PickerLikeAndroid.bundle/textField_bg@2x.png"];
    UIEdgeInsets insets = UIEdgeInsetsMake(50.0f, 200.0f, 5.0f, 60.0f);
    //UIEdgeInsets insets = {top, left, bottom, right};
    textField.background = [bgImage resizableImageWithCapInsets:insets];
    textField.tag = component;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.textAlignment = UITextAlignmentLeft;
    textField.font = [UIFont systemFontOfSize:13.0];
    textField.delegate = self;
    if ([self.delegate respondsToSelector:@selector(textOfRow:inComponent:rowArray:)]) {
        textField.text = [self.delegate textOfRow:row inComponent:component rowArray:self.rowArray];
    }
    return textField;
}

/**
 * resize View height
 * @param text
 * @param width:
    const
 * @param height:
    default view height
 * @return CGFloat
 */
-(CGFloat)resizeViewHeight:(NSString *)text width:(CGFloat)width height:(CGFloat)height{
    
    CGSize constraint = CGSizeMake(width, 2000.0f);
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    return size.height>height?size.height:height;
}

#pragma mark -
#pragma mark - UIView show/dismiss

/**
 * UIView show
 * @return
 */
- (void)showInView{

    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^(void){
        [self.shadowView setFrame:window.frame];
        [window addSubview:self.shadowView];
        
        [self setFrame:CGRectMake(leftRightSpace_,  20+([UIScreen mainScreen].applicationFrame.size.height - self.contentView.frame.size.height)/2, cellWidthSpace_, self.contentView.frame.size.height)];
        [self.shadowView addSubview:self];
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
    [self.shadowView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^(void){
        self.shadowView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL isFinished){
        [window removeFromSuperview];
    }];
}

#pragma mark -
#pragma mark -textFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    self.component = textField.tag;
    NSMutableArray *array = [NSMutableArray array];
    if ([self.delegate respondsToSelector:@selector(arrayOfRowArray:inComponent:)]) {
        array = [self.delegate arrayOfRowArray:self.rowArray inComponent:self.component];
    }
    NSInteger row = [[self.rowArray objectAtIndex:self.component] integerValue];
    PickerDataTableView *dataTableView = [[PickerDataTableView alloc] initWithFrame:CGRectMake(0, 0, cellWidthSpace_-2*leftRightSpace_, cellHeightSpace_*array.count) delegate:self array:array row:row];
    [dataTableView showInView];
    return NO;
}

-(UIImageView*)drawImageView:(CGRect)frame{
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:frame];
    imgView.backgroundColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1.0];
    return [imgView autorelease];
}

#pragma mark -
#pragma mark - PickerDataTableViewDelegate
-(void)selectRow:(NSInteger)row{
    
    [self.rowArray replaceObjectAtIndex:self.component withObject:[NSNumber numberWithInteger:row]];
    for (int i=self.component; i<self.numberOfComponents-1; i++) {
        [self.rowArray replaceObjectAtIndex:i+1 withObject:[NSNumber numberWithInt:0]];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.dataTableView reloadData];
        });
    });
}

#pragma mark -
#pragma mark - actionDone/actionCancel

// 选择完成
-(void)actionDone
{
    if ([self.delegate respondsToSelector:@selector(selectDataOfRowArray:)]) {
        [self.delegate selectDataOfRowArray:[[self.rowArray mutableCopy] autorelease]];
    }
    [self actionCancel];
}

// 取消选择
-(void)actionCancel
{
    [self.rowArray removeAllObjects];
    [self hideView];
}

@end
