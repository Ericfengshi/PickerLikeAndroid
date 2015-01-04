//
//  ViewController.h
//  PickerLikeAndroid
//
//  Created by fengs on 14-12-30.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerLikeAndroidView.h"
#import "Logic.h"

@interface ViewController : UIViewController<UITextFieldDelegate,PickerLikeAndroidViewDelegate>
@property (nonatomic,retain) UITextField *oneComponentTextField;
@property (nonatomic,retain) PickerLikeAndroidView *oneComponentDataPicker;

@property (nonatomic,retain) UITextField *twoComponentTextField;
@property (nonatomic,retain) PickerLikeAndroidView *twoComponentDataPicker;

@property (nonatomic,retain) UITextField *threeComponentTextField;
@property (nonatomic,retain) PickerLikeAndroidView *threeComponentDataPicker;

@end
