//
//  PickerDataTableView.h
//  PickerLikeAndroid https://github.com/Ericfengshi/PickerLikeAndroid
//
//  Created by fengs on 15-1-3.
//  Copyright (c) 2015年 fengs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickerDataTableViewDelegate <NSObject>
@optional
/**
 * 选择列
 * @param row : NSInteger
 * @return
 */
-(void)selectRow:(NSInteger)row;
@end

@interface PickerDataTableView : UIView<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,assign) id delegate;
@property (nonatomic,retain) UIWindow *window;
@property (nonatomic,retain) UIView *shadowView;
@property (nonatomic,retain) UITableView *dataTableView;
@property (nonatomic,retain) NSArray *listArray;
@property (nonatomic,assign) NSInteger row;

- (id)initWithFrame:(CGRect)frame delegate:(id<PickerDataTableViewDelegate>)delegate array:(NSArray*)array row:(NSInteger)row;
-(void)showInView;

@end
