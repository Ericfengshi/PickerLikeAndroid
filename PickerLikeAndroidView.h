//
//  PickerLikeAndroidView.h
//  PickerLikeAndroid https://github.com/Ericfengshi/PickerLikeAndroid
//
//  Created by fengs on 14-12-30.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerDataTableView.h"

@protocol PickerLikeAndroidViewDelegate <NSObject>
@optional
/**
 * 选择器选择完成
 * @param rowArray :
    选择器视图 每组选中的索引集合
 * @return
 */
-(void)selectDataOfRowArray:(NSMutableArray *)rowArray;
/**
 * 本组此索引对应的内容
 * @param row :
    选择器视图 此组下的内容索引
 * @param component :
    选择器视图 哪一组
 * @param rowArray :
    选择器视图 每组索引的集合
 * @return NSString
 */
-(NSString *)textOfRow:(NSInteger)row inComponent:(NSInteger)component rowArray:(NSMutableArray *)rowArray;
/**
 * 本组此索引下的数据集合
 * @param rowArray :
    选择器视图 每组索引的集合
 * @param component :
    选择器视图 哪一组
 * @return NSMutableArray
 */
-(NSMutableArray*)arrayOfRowArray:(NSMutableArray *)rowArray inComponent:(NSInteger)component;
@end

@interface PickerLikeAndroidView : UIView<UITableViewDataSource,UITableViewDelegate,PickerDataTableViewDelegate,UITextFieldDelegate>

@property (nonatomic,assign) id delegate;
@property (nonatomic,retain) UIWindow *window;
@property (nonatomic,retain) UIView *shadowView;
@property (nonatomic,retain) UITableView *dataTableView;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UILabel *messageLabel;
@property (nonatomic,retain) NSMutableArray *textTitleArray;
@property (nonatomic,retain) NSMutableArray *textValueArray;
@property (nonatomic,retain) UIView *contentView;
@property (nonatomic,assign) int numberOfComponents;
@property (nonatomic,assign) NSInteger component;
@property (nonatomic,retain) NSMutableArray *rowArray;
/**
 * view init
 * @param title
 * @param message
 * @param delegate
 * @param textTitleArray
 * @param numberOfComponents
 * @return id
 */
- (id)initWithTitle:(NSString*)title message:(NSString*)message delegate:(id<PickerLikeAndroidViewDelegate>)delegate textTitleArray:(NSMutableArray*)textTitleArray numberOfComponents:(NSInteger)numberOfComponents;
/**
 * 数据加载
 * @param rowArray :
    选择器视图 每组索引的集合
 * @return
 */
- (void)viewLoad:(NSMutableArray*)rowArray;
/**
 * PickerLikeAndroidView展现
 * @return
 */
- (void)showInView;
@end
