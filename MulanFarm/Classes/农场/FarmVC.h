//
//  FarmVC.h
//  MulanFarm
//
//  Created by zyl on 17/3/9.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "BaseVC.h"
#import "OpenGLView.h"

@interface FarmVC : BaseVC

@property (weak, nonatomic) IBOutlet OpenGLView *remoteView; //监控画面
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
@property (weak, nonatomic) IBOutlet UILabel *bellCountLab;
@property (weak, nonatomic) IBOutlet UIButton *bellBtn;
@property (weak, nonatomic) IBOutlet UILabel *petLab;
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (weak, nonatomic) IBOutlet UITextView *contentTF;
@property (weak, nonatomic) IBOutlet UIButton *clearNoteBtn;


- (IBAction)bellAction:(id)sender;

- (IBAction)signAction:(id)sender;

- (IBAction)showRecordAction:(id)sender;

- (IBAction)addCameraBtn:(id)sender;

- (IBAction)clearNoteAction:(id)sender;

- (IBAction)saveNoteAction:(id)sender;


@end
