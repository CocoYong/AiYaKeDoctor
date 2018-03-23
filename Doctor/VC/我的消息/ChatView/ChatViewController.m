/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "ChatViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "SRRefreshView.h"
#import "DXChatBarMoreView.h"
#import "DXRecordView.h"
#import "DXFaceView.h"


#import "EMChatViewCell.h"
#import "EMChatTimeCell.h"
#import "ChatSendHelper.h"

#import "MessageReadManager.h"
#import "MessageModelManager.h"
#import "LocationViewController.h"
//不要不要的
//#import "ChatGroupDetailViewController.h"

#import "UIViewController+HUD.h"
#import "NSDate+Category.h"
#import "DXMessageToolBar.h"

#import "ChatViewController+Category.h"

#import "TabBarViewController.h"
#import "EMCDDeviceManager.h"
#import "EMCDDeviceManagerDelegate.h"
#define KPageCount 20
#define KHintAdjustY    50

@interface ChatViewController ()<UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, SRRefreshDelegate, IChatManagerDelegate, DXChatBarMoreViewDelegate, DXMessageToolBarDelegate,LocationViewDelegate,EMCDDeviceManagerDelegate,UITextFieldDelegate>
{
    UIMenuController *_menuController;
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    NSIndexPath *_longPressIndexPath;
    
    NSInteger _recordingCount;
    
    dispatch_queue_t _messageQueue;
    
    NSMutableArray *_messages;
    BOOL _isScrollToBottom;
}

@property (nonatomic) BOOL isChatGroup;

@property (nonatomic) EMConversationType conversationType;

@property (strong, nonatomic) NSMutableArray *dataSource;//tableView数据源
@property (strong, nonatomic) SRRefreshView *slimeView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) DXMessageToolBar *chatToolBar;

@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (strong, nonatomic) MessageReadManager *messageReadManager;//message阅读的管理者
@property (strong, nonatomic) EMConversation *conversation;//会话管理者
@property (strong, nonatomic) NSDate *chatTagDate;

@property (strong, nonatomic) NSMutableArray *messages;
@property (nonatomic) BOOL isScrollToBottom;
@property (nonatomic) BOOL isPlayingAudio;
@property (nonatomic) BOOL isKicked;

@property (nonatomic,strong)UITextField *inputTextField;
@end

@implementation ChatViewController
{
    UIView *popUpWindow;
    UIView *grayWindow;
    NSInteger keyboardBeginHeight;
    NSInteger keyboardEndHeight;
}
- (instancetype)initWithChatter:(NSString *)chatter isGroup:(BOOL)isGroup
{
    EMConversationType type = isGroup ? eConversationTypeGroupChat : eConversationTypeChat;
    self = [self initWithChatter:chatter conversationType:type];
    if (self) {
    }
    
    return self;
}

- (instancetype)initWithChatter:(NSString *)chatter conversationType:(EMConversationType)type
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _isPlayingAudio = NO;
        _chatter = chatter;
        _conversationType = type;
        _messages = [NSMutableArray array];
        
        //根据接收者的username获取当前会话的管理者
        _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:chatter
                                                                    conversationType:type];
        [_conversation markAllMessagesAsRead:YES];
    }
    return self;
}

- (BOOL)isChatGroup
{
    return _conversationType != eConversationTypeChat;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self creatNavgationBarWithTitle:_titleName];
    [self addBackButt];
    [self registerBecomeActive];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBACOLOR(248, 248, 248, 1);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }

#warning 以下三行代码必须写，注册为SDK的ChatManager的delegate
    [EMCDDeviceManager sharedInstance].delegate = self;
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    //注册为SDK的ChatManager的delegate
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
//    [[EaseMob sharedInstance].callManager removeDelegate:self];
    // 注册为Call的Delegate
//    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllMessages:) name:@"RemoveAllMessages" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitGroup) name:@"ExitGroup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertCallMessage:) name:@"insertCallMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:@"applicationDidEnterBackground" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardDidChangeFrameNotification object:nil];
    _messageQueue = dispatch_queue_create("easemob.com", NULL);
    _isScrollToBottom = YES;
    
    //设置底部输入框
    [self creatBottomInputTextView];
    self.view.autoresizesSubviews=YES;
    
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.slimeView];
     
//    [self.view addSubview:self.chatToolBar];
 
    
    //将self注册为chatToolBar的moreView的代理
    if ([self.chatToolBar.moreView isKindOfClass:[DXChatBarMoreView class]]) {
        [(DXChatBarMoreView *)self.chatToolBar.moreView setDelegate:self];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden)];
    [self.view addGestureRecognizer:tap];
    
    //通过会话管理者获取已收发消息
    [self loadMoreMessages];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification :) name:@"callOutWithChatter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification:) name:@"callControllerClose" object:nil];
    
    if (_conversationType == eConversationTypeChatRoom)
    {
//        [self joinChatroom:_chatter];
    }
}
-(void)keyboardShow:(NSNotification*)notification
{
    NSDictionary *userinfo=[notification userInfo];
    CGRect rect=[[userinfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    keyboardBeginHeight=rect.size.height;
}
-(void)keyboardHidden:(NSNotification*)notification
{
    NSDictionary *userinfo=[notification userInfo];
    CGRect rect=[[userinfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardEndHeight=rect.size.height;
}
-(void)creatBottomInputTextView
{
    UIImageView* OneButtImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-80, kSCREEN_WIDTH, 80)];
    OneButtImageView.image=[UIImage imageNamed:@"0_359"];
    OneButtImageView.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    OneButtImageView.autoresizesSubviews=YES;
    [self.view addSubview:OneButtImageView];
    OneButtImageView.userInteractionEnabled=YES;
    
    UIImageView *textFieldBackView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 25, kSCREEN_WIDTH-60, 30)];
    textFieldBackView.image=[UIImage imageNamed:@"sousuo_03"];
    textFieldBackView.userInteractionEnabled=YES;
    [OneButtImageView addSubview:textFieldBackView];
    
    _inputTextField=[[UITextField alloc]initWithFrame:CGRectMake(30, 0, kSCREEN_WIDTH-90, 30)];
    _inputTextField.borderStyle=UITextBorderStyleNone;
    _inputTextField.delegate=self;
    _inputTextField.textColor=[UIColor whiteColor];
    _inputTextField.placeholder=@"请输入聊天内容";
    
    
    UIButton *addPhotoButt=[UIButton buttonWithType:UIButtonTypeCustom];
    addPhotoButt.frame=CGRectMake(5, 5, 20, 20);
    addPhotoButt.layer.cornerRadius=15;
    [addPhotoButt setBackgroundImage:[UIImage imageNamed:@"0_238"] forState:UIControlStateNormal];
    [addPhotoButt addTarget:self action:@selector(addImageFromCamera) forControlEvents:UIControlEventTouchUpInside];
//    [addPhotoButt setTitle:@"😄😄" forState:UIControlStateNormal];
    [textFieldBackView addSubview:addPhotoButt];
    [textFieldBackView addSubview:_inputTextField];
    
    UIButton *sendButt=[UIButton buttonWithType:UIButtonTypeCustom];
    sendButt.frame=CGRectMake(kSCREEN_WIDTH-50, 20, 40, 40);
    [sendButt setImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
    [sendButt addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [OneButtImageView addSubview:sendButt];
    
    UILabel *textLabel=[[UILabel alloc]initWithFrame:CGRectMake(kSCREEN_WIDTH-50, 60, 40, 20)];
    textLabel.text=@"发送";
    textLabel.textColor=[UIColor whiteColor];
    textLabel.font=[UIFont systemFontOfSize:14];
    textLabel.textAlignment=NSTextAlignmentCenter;
    [OneButtImageView addSubview:textLabel];
}
-(void)sendMessage
{
    if (_inputTextField.text==nil) {
        [SVProgressHUD showWithStatus:@"请输入发送的消息"];
    }else
    {
    [self sendTextMessage:_inputTextField.text];
        _inputTextField.text=nil;
    }
}
-(void)addImageFromCamera
{
    grayWindow=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    grayWindow.backgroundColor=[UIColor lightGrayColor];
    grayWindow.alpha=0.5f;
    [self.view addSubview:grayWindow];
    
    popUpWindow=[[UIView alloc]initWithFrame:CGRectMake(30, self.view.center.y-65, kSCREEN_WIDTH-60, 130)];
    popUpWindow.backgroundColor=[UIColor whiteColor];
    popUpWindow.layer.cornerRadius=5.0f;
    [self.view addSubview:popUpWindow];
    
    
    UIButton *cancelButt=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelButt.frame=CGRectMake(popUpWindow.frame.size.width-40, 0, 40, 40);
    [cancelButt setImage:[UIImage imageNamed:@"0_373"] forState:UIControlStateNormal];
    [cancelButt addTarget:self action:@selector(dismissPopWindow) forControlEvents:UIControlEventTouchUpInside];
    [popUpWindow addSubview:cancelButt];
    
    UIButton *takePhoto=[UIButton buttonWithType:UIButtonTypeCustom];
    takePhoto.frame=CGRectMake((popUpWindow.frame.size.width-160)/3, 10, 80, 80);
    [takePhoto setImage:[UIImage imageNamed:@"0_387"] forState:UIControlStateNormal];
    [takePhoto addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
    [popUpWindow addSubview:takePhoto];
    
    UIButton *photoLib=[UIButton buttonWithType:UIButtonTypeCustom];
    photoLib.frame=CGRectMake((popUpWindow.frame.size.width-160)*2/3+80, 10, 80, 80);
    [photoLib addTarget:self action:@selector(goPhotoLibary) forControlEvents:UIControlEventTouchUpInside];
    [photoLib setImage:[UIImage imageNamed:@"0_389"] forState:UIControlStateNormal];
    [popUpWindow addSubview:photoLib];
    
    
    UILabel *takePhotoLabel=[[UILabel alloc]initWithFrame:CGRectMake((popUpWindow.frame.size.width-160)/3, 100, 80, 20)];
    takePhotoLabel.text=@"拍照";
    takePhotoLabel.textAlignment=NSTextAlignmentCenter;
    [popUpWindow addSubview:takePhotoLabel];
    
    UILabel *photoLibLabel=[[UILabel alloc]initWithFrame:CGRectMake((popUpWindow.frame.size.width-160)*2/3+80, 100, 80, 20)];
    photoLibLabel.text=@"从相册选";
    photoLibLabel.textAlignment=NSTextAlignmentCenter;
    [popUpWindow addSubview:photoLibLabel];
}
-(void)dismissPopWindow
{
    [popUpWindow removeFromSuperview];
    [grayWindow removeFromSuperview];
}
-(void)takePicture
{
    [popUpWindow removeFromSuperview];
    [grayWindow removeFromSuperview];
    [self moreViewTakePicAction:nil];
    
}
-(void)goPhotoLibary
{
    [popUpWindow removeFromSuperview];
    [grayWindow removeFromSuperview];
    [self moreViewPhotoAction:nil];
}






- (void)handleCallNotification:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[NSDictionary class]]) {
        //开始call
        self.isInvisible = YES;
    }
    else
    {
        //结束call
        self.isInvisible = NO;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [(TabBarViewController*)self.tabBarController  tabbarImageView].hidden=YES;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isShowPicker"];
//    if (_isScrollToBottom) {
//        [self scrollViewToBottom:NO];
//    }
//    else{
//        _isScrollToBottom = YES;
//    }
    self.isInvisible = NO;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 设置当前conversation的所有message为已读
    [_conversation markAllMessagesAsRead:YES];
    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
    self.isInvisible = YES;
}

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _tableView = nil;
    
    _slimeView.delegate = nil;
    _slimeView = nil;
    
    _chatToolBar.delegate = nil;
    _chatToolBar = nil;
    
    [[EMCDDeviceManager sharedInstance] stopPlaying];
    [EMCDDeviceManager sharedInstance].delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#warning 以下第一行代码必须写，将self从ChatManager的代理中移除
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
//    [[EaseMob sharedInstance].callManager removeDelegate:self];
//    if (_conversation.conversationType == eConversationTypeChatRoom && !_isKicked)
//    {
//        //退出聊天室，删除会话
//        NSString *chatter = [_chatter copy];
//        [[EaseMob sharedInstance].chatManager asyncLeaveChatroom:chatter completion:^(EMChatroom *chatroom, EMError *error){
//            [[EaseMob sharedInstance].chatManager removeConversationByChatter:chatter deleteMessages:YES append2Chat:YES];
//        }];
//    }
}

- (void)back
{
    //判断当前会话是否为空，若符合则删除该会话
    EMMessage *message = [_conversation latestMessage];
    if (message == nil) {
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:_conversation.chatter deleteMessages:NO append2Chat:YES];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setIsInvisible:(BOOL)isInvisible
{
    _isInvisible =isInvisible;
    if (!_isInvisible)
    {
        NSMutableArray *unreadMessages = [NSMutableArray array];
        for (EMMessage *message in self.messages)
        {
            if ([self shouldAckMessage:message read:NO])
            {
                [unreadMessages addObject:message];
            }
        }
        if ([unreadMessages count])
        {
            [self sendHasReadResponseForMessages:unreadMessages];
        }
        [_conversation markAllMessagesAsRead:YES];
    }
}

#pragma mark - helper
- (NSURL *)convert2Mp4:(NSURL *)movUrl {
    NSURL *mp4Url = nil;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetHighestQuality];
        mp4Url = [movUrl copy];
        mp4Url = [mp4Url URLByDeletingPathExtension];
        mp4Url = [mp4Url URLByAppendingPathExtension:@"mp4"];
        exportSession.outputURL = mp4Url;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        dispatch_semaphore_t wait = dispatch_semaphore_create(0l);
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    NSLog(@"failed, error:%@.", exportSession.error);
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    NSLog(@"cancelled.");
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"completed.");
                } break;
                default: {
                    NSLog(@"others.");
                } break;
            }
            dispatch_semaphore_signal(wait);
        }];
        long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
            NSLog(@"timeout.");
        }
        if (wait) {
            //dispatch_release(wait);
            wait = nil;
        }
    }
    
    return mp4Url;
}

#pragma mark - getter

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (SRRefreshView *)slimeView
{
    if (_slimeView == nil) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
    }
    
    return _slimeView;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-140) style:UITableViewStylePlain];
//        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGBACOLOR(248, 248, 248, 1);
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        lpgr.minimumPressDuration = .5;
        [_tableView addGestureRecognizer:lpgr];
    }
    
    return _tableView;
}

- (DXMessageToolBar *)chatToolBar
{
    if (_chatToolBar == nil) {
        _chatToolBar = [[DXMessageToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [DXMessageToolBar defaultHeight], self.view.frame.size.width, [DXMessageToolBar defaultHeight])];
        _chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _chatToolBar.delegate = self;
        
        ChatMoreType type = self.isChatGroup == YES ? ChatMoreTypeGroupChat : ChatMoreTypeChat;
        _chatToolBar.moreView = [[DXChatBarMoreView alloc] initWithFrame:CGRectMake(0, (kVerticalPadding * 2 + kInputTextViewMinHeight), _chatToolBar.frame.size.width, 80) typw:type];
        _chatToolBar.moreView.backgroundColor = RGBACOLOR(240, 242, 247, 1);
        _chatToolBar.moreView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    
    return _chatToolBar;
}

- (UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.modalPresentationStyle= UIModalPresentationOverFullScreen;
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}

- (MessageReadManager *)messageReadManager
{
    if (_messageReadManager == nil) {
        _messageReadManager = [MessageReadManager defaultManager];
    }
    
    return _messageReadManager;
}

- (NSDate *)chatTagDate
{
    if (_chatTagDate == nil) {
        _chatTagDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:0];
    }
    
    return _chatTagDate;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.dataSource count]) {
        id obj = [self.dataSource objectAtIndex:indexPath.row];
        if ([obj isKindOfClass:[NSString class]]) {
            EMChatTimeCell *timeCell = (EMChatTimeCell *)[tableView dequeueReusableCellWithIdentifier:@"MessageCellTime"];
            if (timeCell == nil) {
                timeCell = [[EMChatTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageCellTime"];
                timeCell.backgroundColor = [UIColor clearColor];
                timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            timeCell.textLabel.text = (NSString *)obj;
            return timeCell;
        }
        else{
            MessageModel *model = (MessageModel *)obj;
            NSString *cellIdentifier = [EMChatViewCell cellIdentifierForMessageModel:model];
            EMChatViewCell *cell = (EMChatViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil){
                cell = [[EMChatViewCell alloc] initWithMessageModel:model reuseIdentifier:cellIdentifier];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.messageModel = model;
            return cell;
        }
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_inputTextField.isFirstResponder) {
        [_inputTextField resignFirstResponder];
    }
}
#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *obj = [self.dataSource objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[NSString class]]) {
        return 40;
    }
    else{
        return [EMChatViewCell tableView:tableView heightForRowAtIndexPath:indexPath withObject:(MessageModel *)obj];
    }
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_slimeView) {
        [_slimeView scrollViewDidScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_slimeView) {
        [_slimeView scrollViewDidEndDraging];
    }
}

#pragma mark - slimeRefresh delegate
//加载更多
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    _chatTagDate = nil;
    [self loadMoreMessages];
    [_slimeView endRefresh];
}

#pragma mark - GestureRecognizer

// 点击背景隐藏
-(void)keyBoardHidden
{
    [self.chatToolBar endEditing:YES];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan && [self.dataSource count] > 0) {
        CGPoint location = [recognizer locationInView:self.tableView];
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:location];
        id object = [self.dataSource objectAtIndex:indexPath.row];
        if ([object isKindOfClass:[MessageModel class]]) {
            EMChatViewCell *cell = (EMChatViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell becomeFirstResponder];
            _longPressIndexPath = indexPath;
            [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.messageModel.type];
        }
    }
}

- (void)reloadData{
    _chatTagDate = nil;
    self.dataSource = [[self formatMessages:self.messages] mutableCopy];
    [self.tableView reloadData];
    
    //回到前台时
    if (!self.isInvisible)
    {
        NSMutableArray *unreadMessages = [NSMutableArray array];
        for (EMMessage *message in self.messages)
        {
            if ([self shouldAckMessage:message read:NO])
            {
                [unreadMessages addObject:message];
            }
        }
        if ([unreadMessages count])
        {
            [self sendHasReadResponseForMessages:unreadMessages];
        }
        
        [_conversation markAllMessagesAsRead:YES];
    }
}

#pragma mark - UIResponder actions

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    MessageModel *model = [userInfo objectForKey:KMESSAGEKEY];
    if ([eventName isEqualToString:kRouterEventTextURLTapEventName]) {
        [self chatTextCellUrlPressed:[userInfo objectForKey:@"url"]];
    }
    else if ([eventName isEqualToString:kRouterEventAudioBubbleTapEventName]) {
        [self chatAudioCellBubblePressed:model];
    }
    else if ([eventName isEqualToString:kRouterEventImageBubbleTapEventName]){
        [self chatImageCellBubblePressed:model];
    }
    else if ([eventName isEqualToString:kRouterEventLocationBubbleTapEventName]){
        [self chatLocationCellBubblePressed:model];
    }
    else if([eventName isEqualToString:kResendButtonTapEventName]){
        EMChatViewCell *resendCell = [userInfo objectForKey:kShouldResendCell];
        MessageModel *messageModel = resendCell.messageModel;
        if ((messageModel.status != eMessageDeliveryState_Failure) && (messageModel.status != eMessageDeliveryState_Pending))
        {
            return;
        }
        id <IChatManager> chatManager = [[EaseMob sharedInstance] chatManager];
        [chatManager asyncResendMessage:messageModel.message progress:nil];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:resendCell];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }else if([eventName isEqualToString:kRouterEventChatCellVideoTapEventName]){
        [self chatVideoCellPressed:model];
    }
}

//链接被点击
- (void)chatTextCellUrlPressed:(NSURL *)url
{
    if (url) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

// 语音的bubble被点击
-(void)chatAudioCellBubblePressed:(MessageModel *)model
{
    id <IEMFileMessageBody> body = [model.message.messageBodies firstObject];
    EMAttachmentDownloadStatus downloadStatus = [body attachmentDownloadStatus];
    if (downloadStatus == EMAttachmentDownloading) {
        [self showHint:NSLocalizedString(@"message.downloadingAudio", @"downloading voice, click later")];
        return;
    }
    else if (downloadStatus == EMAttachmentDownloadFailure)
    {
        [self showHint:NSLocalizedString(@"message.downloadingAudio", @"downloading voice, click later")];
        [[EaseMob sharedInstance].chatManager asyncFetchMessage:model.message progress:nil];
        
        return;
    }
    
    // 播放音频
    if (model.type == eMessageBodyType_Voice) {
        //发送已读回执
        if ([self shouldAckMessage:model.message read:YES])
        {
            [self sendHasReadResponseForMessages:@[model.message]];
        }
        __weak ChatViewController *weakSelf = self;
        BOOL isPrepare = [self.messageReadManager prepareMessageAudioModel:model updateViewCompletion:^(MessageModel *prevAudioModel, MessageModel *currentAudioModel) {
            if (prevAudioModel || currentAudioModel) {
                [weakSelf.tableView reloadData];
            }
        }];
        
        if (isPrepare) {
            _isPlayingAudio = YES;
            __weak ChatViewController *weakSelf = self;
            [[EMCDDeviceManager sharedInstance] enableProximitySensor];
            [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:model.chatVoice.localPath completion:^(NSError *error) {
                [weakSelf.messageReadManager stopMessageAudioModel];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                    weakSelf.isPlayingAudio = NO;
                    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
                });
            }];
        }
        else{
            _isPlayingAudio = NO;
        }
    }
}

// 位置的bubble被点击
-(void)chatLocationCellBubblePressed:(MessageModel *)model
{
    _isScrollToBottom = NO;
    LocationViewController *locationController = [[LocationViewController alloc] initWithLocation:CLLocationCoordinate2DMake(model.latitude, model.longitude)];
    [self.navigationController pushViewController:locationController animated:YES];
}

- (void)chatVideoCellPressed:(MessageModel *)model{
    EMVideoMessageBody *videoBody = (EMVideoMessageBody*)model.messageBody;
    if (videoBody.attachmentDownloadStatus == EMAttachmentDownloadSuccessed)
    {
        NSString *localPath = model.message == nil ? model.localPath : [[model.message.messageBodies firstObject] localPath];
        if (localPath && localPath.length > 0)
        {
            //发送已读回执
            if ([self shouldAckMessage:model.message read:YES])
            {
                [self sendHasReadResponseForMessages:@[model.message]];
            }
            [self playVideoWithVideoPath:localPath];
            return;
        }
    }
    
    __weak ChatViewController *weakSelf = self;
    id <IChatManager> chatManager = [[EaseMob sharedInstance] chatManager];
    [weakSelf showHudInView:weakSelf.view hint:NSLocalizedString(@"message.downloadingVideo", @"downloading video...")];
    [chatManager asyncFetchMessage:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
        [weakSelf hideHud];
        if (!error) {
            //发送已读回执
            if ([weakSelf shouldAckMessage:model.message read:YES])
            {
                [weakSelf sendHasReadResponseForMessages:@[model.message]];
            }
            NSString *localPath = aMessage == nil ? model.localPath : [[aMessage.messageBodies firstObject] localPath];
            if (localPath && localPath.length > 0) {
                [weakSelf playVideoWithVideoPath:localPath];
            }
        }else{
            [weakSelf showHint:NSLocalizedString(@"message.videoFail", @"video for failure!")];
        }
    } onQueue:nil];
}

- (void)playVideoWithVideoPath:(NSString *)videoPath
{
    _isScrollToBottom = NO;
    NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
    MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    [moviePlayerController.moviePlayer prepareToPlay];
    moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [self presentMoviePlayerViewControllerAnimated:moviePlayerController];
}

// 图片的bubble被点击
-(void)chatImageCellBubblePressed:(MessageModel *)model
{
    __weak ChatViewController *weakSelf = self;
    id <IChatManager> chatManager = [[EaseMob sharedInstance] chatManager];
    if ([model.messageBody messageBodyType] == eMessageBodyType_Image) {
        EMImageMessageBody *imageBody = (EMImageMessageBody *)model.messageBody;
        if (imageBody.thumbnailDownloadStatus == EMAttachmentDownloadSuccessed) {
            if (imageBody.attachmentDownloadStatus == EMAttachmentDownloadSuccessed)
            {
                //发送已读回执
                if ([self shouldAckMessage:model.message read:YES])
                {
                    [self sendHasReadResponseForMessages:@[model.message]];
                }
                NSString *localPath = model.message == nil ? model.localPath : [[model.message.messageBodies firstObject] localPath];
                if (localPath && localPath.length > 0) {
                    UIImage *image = [UIImage imageWithContentsOfFile:localPath];
                    self.isScrollToBottom = NO;
                    if (image)
                    {
                        [self.messageReadManager showBrowserWithImages:@[image]];
                    }
                    else
                    {
                        NSLog(@"Read %@ failed!", localPath);
                    }
                    return ;
                }
            }
            [weakSelf showHudInView:weakSelf.view hint:NSLocalizedString(@"message.downloadingImage", @"downloading a image...")];
            [chatManager asyncFetchMessage:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
                [weakSelf hideHud];
                if (!error) {
                    //发送已读回执
                    if ([weakSelf shouldAckMessage:model.message read:YES])
                    {
                        [weakSelf sendHasReadResponseForMessages:@[model.message]];
                    }
                    NSString *localPath = aMessage == nil ? model.localPath : [[aMessage.messageBodies firstObject] localPath];
                    if (localPath && localPath.length > 0) {
                        UIImage *image = [UIImage imageWithContentsOfFile:localPath];
                        weakSelf.isScrollToBottom = NO;
                        if (image)
                        {
                            [weakSelf.messageReadManager showBrowserWithImages:@[image]];
                        }
                        else
                        {
                            NSLog(@"Read %@ failed!", localPath);
                        }
                        return ;
                    }
                }
                [weakSelf showHint:NSLocalizedString(@"message.imageFail", @"image for failure!")];
            } onQueue:nil];
        }else{
            //获取缩略图
            [chatManager asyncFetchMessageThumbnail:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
                if (!error) {
                    [weakSelf reloadTableViewDataWithMessage:model.message];
                }else{
                    [weakSelf showHint:NSLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
                }
                
            } onQueue:nil];
        }
    }else if ([model.messageBody messageBodyType] == eMessageBodyType_Video) {
        //获取缩略图
        EMVideoMessageBody *videoBody = (EMVideoMessageBody *)model.messageBody;
        if (videoBody.thumbnailDownloadStatus != EMAttachmentDownloadSuccessed) {
            [chatManager asyncFetchMessageThumbnail:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
                if (!error) {
                    [weakSelf reloadTableViewDataWithMessage:model.message];
                }else{
                    [weakSelf showHint:NSLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
                }
            } onQueue:nil];
        }
    }
}

#pragma mark - IChatManagerDelegate

-(void)didSendMessage:(EMMessage *)message error:(EMError *)error
{
    [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         if ([obj isKindOfClass:[MessageModel class]])
         {
             MessageModel *model = (MessageModel*)obj;
             if ([model.messageId isEqualToString:message.messageId])
             {
                 model.message.deliveryState = message.deliveryState;
                 *stop = YES;
             }
         }
     }];
    [self.tableView reloadData];
}

- (void)didReceiveHasReadResponse:(EMReceipt*)receipt
{
    [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         if ([obj isKindOfClass:[MessageModel class]])
         {
             MessageModel *model = (MessageModel*)obj;
             if ([model.messageId isEqualToString:receipt.chatId])
             {
                 model.message.isReadAcked = YES;
                 *stop = YES;
             }
         }
     }];
    [self.tableView reloadData];
}

- (void)reloadTableViewDataWithMessage:(EMMessage *)message{
    __weak ChatViewController *weakSelf = self;
    dispatch_async(_messageQueue, ^{
        if ([weakSelf.conversation.chatter isEqualToString:message.conversationChatter])
        {
            for (int i = 0; i < weakSelf.dataSource.count; i ++) {
                id object = [weakSelf.dataSource objectAtIndex:i];
                if ([object isKindOfClass:[MessageModel class]]) {
                    MessageModel *model = (MessageModel *)object;
                    if ([message.messageId isEqualToString:model.messageId]) {
                        MessageModel *cellModel = [MessageModelManager modelWithMessage:message];
                        if ([self->_delelgate respondsToSelector:@selector(nickNameWithChatter:)]) {
                            NSString *showName = [self->_delelgate nickNameWithChatter:model.username];
                            cellModel.nickName = showName?showName:cellModel.username;
                        }else {
                            cellModel.nickName = cellModel.username;
                        }
                        
                        if ([self->_delelgate respondsToSelector:@selector(avatarWithChatter:)]) {
                            cellModel.headImageURL = [NSURL URLWithString:[self->_delelgate avatarWithChatter:cellModel.username]];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.tableView beginUpdates];
                            [weakSelf.dataSource replaceObjectAtIndex:i withObject:cellModel];
                            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                            [weakSelf.tableView endUpdates];
                        });
                        break;
                    }
                }
            }
        }
    });
}

- (void)didMessageAttachmentsStatusChanged:(EMMessage *)message error:(EMError *)error{
    if (!error) {
        id<IEMFileMessageBody>fileBody = (id<IEMFileMessageBody>)[message.messageBodies firstObject];
        if ([fileBody messageBodyType] == eMessageBodyType_Image) {
            EMImageMessageBody *imageBody = (EMImageMessageBody *)fileBody;
            if ([imageBody thumbnailDownloadStatus] == EMAttachmentDownloadSuccessed)
            {
                [self reloadTableViewDataWithMessage:message];
            }
        }else if([fileBody messageBodyType] == eMessageBodyType_Video){
            EMVideoMessageBody *videoBody = (EMVideoMessageBody *)fileBody;
            if ([videoBody thumbnailDownloadStatus] == EMAttachmentDownloadSuccessed)
            {
                [self reloadTableViewDataWithMessage:message];
            }
        }else if([fileBody messageBodyType] == eMessageBodyType_Voice){
            if ([fileBody attachmentDownloadStatus] == EMAttachmentDownloadSuccessed)
            {
                [self reloadTableViewDataWithMessage:message];
            }
        }
        
    }else{
        
    }
}

- (void)didFetchingMessageAttachments:(EMMessage *)message progress:(float)progress{
    NSLog(@"didFetchingMessageAttachment: %f", progress);
}

-(void)didReceiveMessage:(EMMessage *)message
{
    if ([_conversation.chatter isEqualToString:message.conversationChatter]) {
        [self addMessage:message];
        if ([self shouldAckMessage:message read:NO])
        {
            [self sendHasReadResponseForMessages:@[message]];
        }
        if ([self shouldMarkMessageAsRead])
        {
            [self markMessagesAsRead:@[message]];
        }
    }
}

-(void)didReceiveCmdMessage:(EMMessage *)message
{
    if ([_conversation.chatter isEqualToString:message.conversationChatter]) {
        [self showHint:NSLocalizedString(@"receiveCmd", @"receive cmd message")];
    }
}

- (void)didReceiveMessageId:(NSString *)messageId
                    chatter:(NSString *)conversationChatter
                      error:(EMError *)error
{
    if (error && [_conversation.chatter isEqualToString:conversationChatter]) {
        
        __weak ChatViewController *weakSelf = self;
        for (int i = 0; i < self.dataSource.count; i ++) {
            id object = [self.dataSource objectAtIndex:i];
            if ([object isKindOfClass:[MessageModel class]]) {
                MessageModel *currentModel = [self.dataSource objectAtIndex:i];
                EMMessage *currMsg = [currentModel message];
                if ([messageId isEqualToString:currMsg.messageId]) {
                    currMsg.deliveryState = eMessageDeliveryState_Failure;
                    MessageModel *cellModel = [MessageModelManager modelWithMessage:currMsg];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.tableView beginUpdates];
                        [weakSelf.dataSource replaceObjectAtIndex:i withObject:cellModel];
                        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                        [weakSelf.tableView endUpdates];
                        
                    });
                    
                    break;
                }
            }
        }
    }
}

- (void)didFinishedReceiveOfflineMessages:(NSArray *)offlineMessages
{
    if ([self shouldMarkMessageAsRead])
    {
        [_conversation markAllMessagesAsRead:YES];
    }
    if (![offlineMessages count])
    {
        return;
    }
    _chatTagDate = nil;
    [self loadMoreMessages];
    __weak typeof(self) weakSelf = self;
    dispatch_async(_messageQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf scrollViewToBottom:NO];
        });
    });
}

- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    if (![offlineMessages count])
    {
        return;
    }
    if ([self shouldMarkMessageAsRead])
    {
        [_conversation markAllMessagesAsRead:YES];
    }
    _chatTagDate = nil;
    [self loadMoreMessages];
    __weak typeof(self) weakSelf = self;
    dispatch_async(_messageQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf scrollViewToBottom:NO];
        });
    });
}

- (void)group:(EMGroup *)group didLeave:(EMGroupLeaveReason)reason error:(EMError *)error
{
    if (self.isChatGroup && [group.groupId isEqualToString:_chatter]) {
        [self.navigationController popToViewController:self animated:NO];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)didInterruptionRecordAudio
{
    [_chatToolBar cancelTouchRecord];
    
    // 设置当前conversation的所有message为已读
    [_conversation markAllMessagesAsRead:YES];
    
    [self stopAudioPlayingWithChangeCategory:YES];
}

- (void)groupDidUpdateInfo:(EMGroup *)group error:(EMError *)error
{
    if (!error && self.isChatGroup && [_chatter isEqualToString:group.groupId])
    {
        self.title = group.groupSubject;
    }
}

#pragma mark - IChatManagerDelegate 登录状态变化

- (void)didLoginFromOtherDevice
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)didRemovedFromServer
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

#pragma mark - EMChatBarMoreViewDelegate

- (void)moreViewPhotoAction:(DXChatBarMoreView *)moreView
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isShowPicker"];
    // 隐藏键盘
    [self keyBoardHidden];
    
    // 弹出照片选择
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
    self.isInvisible = YES;
}

- (void)moreViewTakePicAction:(DXChatBarMoreView *)moreView
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isShowPicker"];
    [self keyBoardHidden];
    
#if TARGET_IPHONE_SIMULATOR
    [self showHint:NSLocalizedString(@"message.simulatorNotSupportCamera", @"simulator does not support taking picture")];
#elif TARGET_OS_IPHONE
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
    self.isInvisible = YES;
#endif
}

- (void)moreViewLocationAction:(DXChatBarMoreView *)moreView
{
    // 隐藏键盘
    [self keyBoardHidden];
    
    LocationViewController *locationController = [[LocationViewController alloc] initWithNibName:nil bundle:nil];
    locationController.delegate = self;
    [self.navigationController pushViewController:locationController animated:YES];
}

- (void)moreViewAudioCallAction:(DXChatBarMoreView *)moreView
{
    // 隐藏键盘
    [self keyBoardHidden];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"callOutWithChatter" object:@{@"chatter":self.chatter, @"type":[NSNumber numberWithInt:eCallSessionTypeAudio]}];
}

- (void)moreViewVideoCallAction:(DXChatBarMoreView *)moreView
{
    // 隐藏键盘
    [self keyBoardHidden];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"callOutWithChatter" object:@{@"chatter":self.chatter, @"type":[NSNumber numberWithInt:eCallSessionTypeVideo]}];
}

#pragma mark - LocationViewDelegate

-(void)sendLocationLatitude:(double)latitude longitude:(double)longitude andAddress:(NSString *)address
{
    EMMessage *locationMessage = [ChatSendHelper sendLocationLatitude:latitude longitude:longitude address:address toUsername:_conversation.chatter messageType:[self messageType] requireEncryption:NO ext:nil];
    [self addMessage:locationMessage];
}

#pragma mark - DXMessageToolBarDelegate
- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView{
    [_menuController setMenuItems:nil];
}

- (void)didChangeFrameToHeight:(CGFloat)toHeight
{
    /*
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.tableView.frame;
        rect.origin.y = 60;
        rect.size.height = self.view.frame.size.height - toHeight-self.chatToolBar.frame.size.height;
        self.tableView.frame = rect;
    }];
    [self scrollViewToBottom:NO];
     */
}

- (void)didSendText:(NSString *)text
{
    if (text && text.length > 0) {
        [self sendTextMessage:text];
    }
}

/**
 *  按下录音按钮开始录音
 */
- (void)didStartRecordingVoiceAction:(UIView *)recordView
{
    if ([self canRecord]) {
        DXRecordView *tmpView = (DXRecordView *)recordView;
        tmpView.center = self.view.center;
        [self.view addSubview:tmpView];
        [self.view bringSubviewToFront:recordView];
        int x = arc4random() % 100000;
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];

        [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName
                                                                 completion:^(NSError *error)
         {
             if (error) {
                 NSLog(NSLocalizedString(@"message.startRecordFail", @"failure to start recording"));
             }
         }];
    }
}

/**
 *  手指向上滑动取消录音
 */
- (void)didCancelRecordingVoiceAction:(UIView *)recordView
{
    [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
}

/**
 *  松开手指完成录音
 */
- (void)didFinishRecoingVoiceAction:(UIView *)recordView
{
    __weak typeof(self) weakSelf = self;
    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if (!error) {
            EMChatVoice *voice = [[EMChatVoice alloc] initWithFile:recordPath
                                                       displayName:@"audio"];
            voice.duration = aDuration;
            [weakSelf sendAudioMessage:voice];
        }else {
            [weakSelf showHudInView:self.view hint:@"录音时间太短了"];
            weakSelf.chatToolBar.recordButton.enabled = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf hideHud];
                weakSelf.chatToolBar.recordButton.enabled = YES;
            });
        }
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *videoURL = info[UIImagePickerControllerMediaURL];
        [picker dismissViewControllerAnimated:YES completion:^{
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isShowPicker"];
        }];
        // video url:
        // file:///private/var/mobile/Applications/B3CDD0B2-2F19-432B-9CFA-158700F4DE8F/tmp/capture-T0x16e39100.tmp.9R8weF/capturedvideo.mp4
        // we will convert it to mp4 format
        NSURL *mp4 = [self convert2Mp4:videoURL];
        NSFileManager *fileman = [NSFileManager defaultManager];
        if ([fileman fileExistsAtPath:videoURL.path]) {
            NSError *error = nil;
            [fileman removeItemAtURL:videoURL error:&error];
            if (error) {
                NSLog(@"failed to remove file, error:%@.", error);
            }
        }
        EMChatVideo *chatVideo = [[EMChatVideo alloc] initWithFile:[mp4 relativePath] displayName:@"video.mp4"];
        [self sendVideoMessage:chatVideo];
        
    }else{
        UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
        [picker dismissViewControllerAnimated:YES completion:^{
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isShowPicker"];
        }];
        [self sendImageMessage:orgImage];
    }
    self.isInvisible = NO;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isShowPicker"];
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    self.isInvisible = NO;
}

#pragma mark - MenuItem actions

- (void)copyMenuAction:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (_longPressIndexPath.row > 0) {
        MessageModel *model = [self.dataSource objectAtIndex:_longPressIndexPath.row];
        pasteboard.string = model.content;
    }
    
    _longPressIndexPath = nil;
}

- (void)deleteMenuAction:(id)sender
{
    if (_longPressIndexPath && _longPressIndexPath.row > 0) {
        MessageModel *model = [self.dataSource objectAtIndex:_longPressIndexPath.row];
        NSMutableIndexSet *indexs = [NSMutableIndexSet indexSetWithIndex:_longPressIndexPath.row];
        [_conversation removeMessage:model.message];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:_longPressIndexPath, nil];;
        if (_longPressIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [self.dataSource objectAtIndex:(_longPressIndexPath.row - 1)];
            if (_longPressIndexPath.row + 1 < [self.dataSource count]) {
                nextMessage = [self.dataSource objectAtIndex:(_longPressIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [indexs addIndex:_longPressIndexPath.row - 1];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(_longPressIndexPath.row - 1) inSection:0]];
            }
        }
        
        [self.dataSource removeObjectsAtIndexes:indexs];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
    
    _longPressIndexPath = nil;
}

#pragma mark - private

- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    
    return bCanRecord;
}

- (void)stopAudioPlayingWithChangeCategory:(BOOL)isChange
{
    //停止音频播放及播放动画
    [[EMCDDeviceManager sharedInstance] stopPlaying];
    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
    [EMCDDeviceManager sharedInstance].delegate = nil;
    MessageModel *playingModel = [self.messageReadManager stopMessageAudioModel];
    NSIndexPath *indexPath = nil;
    if (playingModel) {
        indexPath = [NSIndexPath indexPathForRow:[self.dataSource indexOfObject:playingModel] inSection:0];
    }
    
    if (indexPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        });
    }
}

- (void)loadMoreMessages
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(_messageQueue, ^{
        long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000 + 1;
        
        NSArray *messages = [weakSelf.conversation loadNumbersOfMessages:([weakSelf.messages count] + KPageCount) before:timestamp];
        if ([messages count] > 0) {
            weakSelf.messages = [messages mutableCopy];
            
            NSInteger currentCount = [weakSelf.dataSource count];
            weakSelf.dataSource = [[weakSelf formatMessages:messages] mutableCopy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[weakSelf.dataSource count] - currentCount - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            });
            
            //从数据库导入时重新下载没有下载成功的附件
            for (NSInteger i = 0; i < [weakSelf.dataSource count]; i++)
            {
                id obj = weakSelf.dataSource[i];
                if ([obj isKindOfClass:[MessageModel class]])
                {
                    [weakSelf downloadMessageAttachments:obj];
                }
            }
            
            NSMutableArray *unreadMessages = [NSMutableArray array];
            for (NSInteger i = 0; i < [messages count]; i++)
            {
                EMMessage *message = messages[i];
                if ([self shouldAckMessage:message read:NO])
                {
                    [unreadMessages addObject:message];
                }
            }
            if ([unreadMessages count])
            {
                [self sendHasReadResponseForMessages:unreadMessages];
            }
        }
    });
}

- (void)downloadMessageAttachments:(MessageModel *)model
{
    void (^completion)(EMMessage *aMessage, EMError *error) = ^(EMMessage *aMessage, EMError *error) {
        if (!error)
        {
            [self reloadTableViewDataWithMessage:model.message];
        }
        else
        {
            [self showHint:NSLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
        }
    };
    
    if ([model.messageBody messageBodyType] == eMessageBodyType_Image) {
        EMImageMessageBody *imageBody = (EMImageMessageBody *)model.messageBody;
        if (imageBody.thumbnailDownloadStatus != EMAttachmentDownloadSuccessed)
        {
            //下载缩略图
            [[[EaseMob sharedInstance] chatManager] asyncFetchMessageThumbnail:model.message progress:nil completion:completion onQueue:nil];
        }
    }
    else if ([model.messageBody messageBodyType] == eMessageBodyType_Video)
    {
        EMVideoMessageBody *videoBody = (EMVideoMessageBody *)model.messageBody;
        if (videoBody.thumbnailDownloadStatus != EMAttachmentDownloadSuccessed)
        {
            //下载缩略图
            [[[EaseMob sharedInstance] chatManager] asyncFetchMessageThumbnail:model.message progress:nil completion:completion onQueue:nil];
        }
    }
    else if ([model.messageBody messageBodyType] == eMessageBodyType_Voice)
    {
        EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody*)model.messageBody;
        if (voiceBody.attachmentDownloadStatus != EMAttachmentDownloadSuccessed)
        {
            //下载语言
            [[EaseMob sharedInstance].chatManager asyncFetchMessage:model.message progress:nil];
        }
    }
}

- (NSArray *)formatMessages:(NSArray *)messagesArray
{
    NSMutableArray *formatArray = [[NSMutableArray alloc] init];
    if ([messagesArray count] > 0) {
        for (EMMessage *message in messagesArray) {
            NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
            NSTimeInterval tempDate = [createDate timeIntervalSinceDate:self.chatTagDate];
            if (tempDate > 60 || tempDate < -60 || (self.chatTagDate == nil)) {
                [formatArray addObject:[createDate formattedTime]];
                self.chatTagDate = createDate;
            }
            
            MessageModel *model = [MessageModelManager modelWithMessage:message];
            if ([_delelgate respondsToSelector:@selector(nickNameWithChatter:)]) {
                NSString *showName = [_delelgate nickNameWithChatter:model.username];
                model.nickName = showName?showName:model.username;
            }else {
                model.nickName = model.username;
            }
            
            if ([_delelgate respondsToSelector:@selector(avatarWithChatter:)]) {
                model.headImageURL = [NSURL URLWithString:[_delelgate avatarWithChatter:model.username]];
            }
            
            if (model) {
                [formatArray addObject:model];
            }
        }
    }
    
    return formatArray;
}

-(NSMutableArray *)formatMessage:(EMMessage *)message
{
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
    NSTimeInterval tempDate = [createDate timeIntervalSinceDate:self.chatTagDate];
    if (tempDate > 60 || tempDate < -60 || (self.chatTagDate == nil)) {
        [ret addObject:[createDate formattedTime]];
        self.chatTagDate = createDate;
    }
    
    MessageModel *model = [MessageModelManager modelWithMessage:message];
    if ([_delelgate respondsToSelector:@selector(nickNameWithChatter:)]) {
        NSString *showName = [_delelgate nickNameWithChatter:model.username];
        model.nickName = showName?showName:model.username;
    }else {
        model.nickName = model.username;
    }
    
    if ([_delelgate respondsToSelector:@selector(avatarWithChatter:)]) {
        model.headImageURL = [NSURL URLWithString:[_delelgate avatarWithChatter:model.username]];
    }
    if (model) {
        [ret addObject:model];
    }
    
    return ret;
}

-(void)addMessage:(EMMessage *)message
{
    [_messages addObject:message];
    __weak ChatViewController *weakSelf = self;
    dispatch_async(_messageQueue, ^{
        NSArray *messages = [weakSelf formatMessage:message];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.dataSource addObjectsFromArray:messages];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[weakSelf.dataSource count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
    });
}
- (void)scrollViewToBottom:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:animated];
    }
}

- (void)showRoomContact:(id)sender
{
    [self.view endEditing:YES];
    if (self.conversationType == eConversationTypeGroupChat) {
//        ChatGroupDetailViewController *detailController = [[ChatGroupDetailViewController alloc] initWithGroupId:_chatter];
//        [self.navigationController pushViewController:detailController animated:YES];
    }
//    else if (self.conversationType == eConversationTypeChatRoom)
//    {
//        ChatroomDetailViewController *detailController = [[ChatroomDetailViewController alloc] initWithChatroomId:_chatter];
//        [self.navigationController pushViewController:detailController animated:YES];
//    }
}

- (void)removeAllMessages:(id)sender
{
    if (_dataSource.count == 0) {
        [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        return;
    }
    
    if ([sender isKindOfClass:[NSNotification class]]) {
        NSString *groupId = (NSString *)[(NSNotification *)sender object];
        if (self.isChatGroup && [groupId isEqualToString:_conversation.chatter]) {
            [_conversation removeAllMessages];
            [_messages removeAllObjects];
            _chatTagDate = nil;
            [_dataSource removeAllObjects];
            [_tableView reloadData];
            [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        }
    }
    else{
//        __weak typeof(self) weakSelf = self;
//        
//        [EMAlertView showAlertWithTitle:NSLocalizedString(@"prompt", @"Prompt")
//                                message:NSLocalizedString(@"sureToDelete", @"please make sure to delete")
//                        completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
//                            if (buttonIndex == 1) {
//                                [weakSelf.conversation removeAllMessages];
//                                [weakSelf.messages removeAllObjects];
//                                weakSelf.chatTagDate = nil;
//                                [weakSelf.dataSource removeAllObjects];
//                                [weakSelf.tableView reloadData];
//                            }
//                        } cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel")
//                      otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
    }
}

- (void)showMenuViewController:(UIView *)showInView andIndexPath:(NSIndexPath *)indexPath messageType:(MessageBodyType)messageType
{
    if (_menuController == nil) {
        _menuController = [UIMenuController sharedMenuController];
    }
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"copy", @"Copy") action:@selector(copyMenuAction:)];
    }
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"delete", @"Delete") action:@selector(deleteMenuAction:)];
    }
    
    if (messageType == eMessageBodyType_Text) {
        [_menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem]];
    }
    else{
        [_menuController setMenuItems:@[_deleteMenuItem]];
    }
    
    [_menuController setTargetRect:showInView.frame inView:showInView.superview];
    [_menuController setMenuVisible:YES animated:YES];
}

- (void)exitGroup
{
    [self.navigationController popToViewController:self animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)insertCallMessage:(NSNotification *)notification
{
    id object = notification.object;
    if (object) {
        EMMessage *message = (EMMessage *)object;
        [self addMessage:message];
    }
}

- (void)applicationDidEnterBackground
{
    [_chatToolBar cancelTouchRecord];
    
    // 设置当前conversation的所有message为已读
    [_conversation markAllMessagesAsRead:YES];
}

- (BOOL)shouldAckMessage:(EMMessage *)message read:(BOOL)read
{
    NSString *account = [[EaseMob sharedInstance].chatManager loginInfo][kSDKUsername];
    if (message.messageType != eMessageTypeChat || message.isReadAcked || [account isEqualToString:message.from] || ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) || self.isInvisible)
    {
        return NO;
    }
    
    id<IEMMessageBody> body = [message.messageBodies firstObject];
    if (((body.messageBodyType == eMessageBodyType_Video) ||
         (body.messageBodyType == eMessageBodyType_Voice) ||
         (body.messageBodyType == eMessageBodyType_Image)) &&
        !read)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL)shouldMarkMessageAsRead
{
    if (([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) || self.isInvisible)
    {
        return NO;
    }
    
    return YES;
}

- (EMMessageType)messageType
{
    EMMessageType type = eMessageTypeChat;
    switch (_conversationType) {
        case eConversationTypeChat:
            type = eMessageTypeChat;
            break;
        case eConversationTypeGroupChat:
            type = eMessageTypeGroupChat;
            break;
        case eConversationTypeChatRoom:
            type = eMessageTypeChatRoom;
            break;
        default:
            break;
    }
    return type;
}

#pragma mark - public

- (void)hideImagePicker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    self.isInvisible = NO;
}

#pragma mark - send message

-(void)sendTextMessage:(NSString *)textMessage
{
    MessageModel *model=[[MessageModel alloc]init];
    model.nickName=[UserManager currentUserManager].user.name;
    model.isSender=YES;
    model.username=[UserManager currentUserManager].user.uid;
    model.messageType=eMessageTypeChat;
    NSDictionary *modelDic;
        if (model.isSender) {
            NSString *selfImage=[UserManager currentUserManager].user.picUrl;
            modelDic=@{@"fromPerson":model.nickName,@"toPerson":[_extDictionary objectForKey:@"nickname"],@"fromPhoto":selfImage,@"toPhoto":[_extDictionary objectForKey:@"picUrl"]};
        }
           EMMessage *tempMessage = [ChatSendHelper sendTextMessageWithString:textMessage
                                                            toUsername:_conversation.chatter
                                                           messageType:[self messageType]
                                                     requireEncryption:YES
                                                                   ext:modelDic];
    [self addMessage:tempMessage];
}
- (void)didReceiveHasDeliveredResponse:(EMReceipt *)resp
{
    NSLog(@"dsfjsaljfklsajfsjalf");
}
-(void)sendImageMessage:(UIImage *)image
{
    MessageModel *model=[self.dataSource lastObject];
    model.nickName=[UserManager currentUserManager].user.name;
    model.isSender=YES;
    model.username=[UserManager currentUserManager].user.uid;
    model.messageType=eMessageTypeChat;
    NSDictionary *modelDic;
    if (model.isSender) {
        NSString *selfImage=[UserManager currentUserManager].user.picUrl;
        modelDic=@{@"fromPerson":model.nickName,@"toPerson":[_extDictionary objectForKey:@"nickname"],@"fromPhoto":selfImage,@"toPhoto":[_extDictionary objectForKey:@"picUrl"]};
    }
    EMMessage *tempMessage = [ChatSendHelper sendImageMessageWithImage:image
                                                            toUsername:_conversation.chatter
                                                           messageType:[self messageType]
                                                     requireEncryption:YES
                                                                   ext:modelDic];
    [self addMessage:tempMessage];
}

-(void)sendAudioMessage:(EMChatVoice *)voice
{
    EMMessage *tempMessage = [ChatSendHelper sendVoice:voice
                                            toUsername:_conversation.chatter
                                           messageType:[self messageType]
                                     requireEncryption:NO ext:nil];
    [self addMessage:tempMessage];
}

-(void)sendVideoMessage:(EMChatVideo *)video
{
    EMMessage *tempMessage = [ChatSendHelper sendVideo:video
                                            toUsername:_conversation.chatter
                                           messageType:[self messageType]
                                     requireEncryption:NO ext:nil];
    [self addMessage:tempMessage];
}

- (void)sendHasReadResponseForMessages:(NSArray*)messages
{
    dispatch_async(_messageQueue, ^{
        for (EMMessage *message in messages)
        {
            [[EaseMob sharedInstance].chatManager sendReadAckForMessage:message];
        }
    });
}

- (void)markMessagesAsRead:(NSArray*)messages
{
    EMConversation *conversation = _conversation;
    dispatch_async(_messageQueue, ^{
        for (EMMessage *message in messages)
        {
            [conversation markMessageWithId:message.messageId asRead:YES];
        }
    });
}

#pragma mark - EMCDDeviceManagerDelegate
- (void)proximitySensorChanged:(BOOL)isCloseToUser{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if (isCloseToUser)
    {
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    } else {
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        if (!_isPlayingAudio) {
            [[EMCDDeviceManager sharedInstance] disableProximitySensor];
        }
    }
    [audioSession setActive:YES error:nil];
}

#pragma mark - EMChatManagerChatroomDelegate

- (void)chatroom:(EMChatroom *)chatroom occupantDidJoin:(NSString *)username
{
    CGRect frame = self.chatToolBar.frame;
    [self showHint:[NSString stringWithFormat:@"%@加入%@", username, chatroom.chatroomId] yOffset:-frame.size.height + KHintAdjustY];
}

- (void)chatroom:(EMChatroom *)chatroom occupantDidLeave:(NSString *)username
{
    CGRect frame = self.chatToolBar.frame;
    [self showHint:[NSString stringWithFormat:@"%@离开%@", username, chatroom.chatroomId] yOffset:-frame.size.height + KHintAdjustY];
}

- (void)beKickedOutFromChatroom:(EMChatroom *)chatroom reason:(EMChatroomBeKickedReason)reason
{
    if ([_chatter isEqualToString:chatroom.chatroomId])
    {
        _isKicked = YES;
        CGRect frame = self.chatToolBar.frame;
        [self showHint:[NSString stringWithFormat:@"被踢出%@", chatroom.chatroomId] yOffset:-frame.size.height + KHintAdjustY];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - ICallManagerDelegate

- (void)callSessionStatusChanged:(EMCallSession *)callSession changeReason:(EMCallStatusChangedReason)reason error:(EMError *)error{
    if (reason == eCallReason_Null) {
        if ([[EMCDDeviceManager sharedInstance] isPlaying]) {
            [self stopAudioPlayingWithChangeCategory:NO];
        }
    }
}

#pragma mark - 创建带附件的消息体和批量导入消息的示例
//- (void)loadMessage
//{
//    NSDictionary *imageDic = @{EMMessageBodyAttrKeySecret:@"fmIgiuSuEeSdyLffbqYspd3oOH6uMSGkXaOvZUF9ayy5b26c",
//                               EMMessageBodyAttrKeySize:@{EMMessageBodyAttrKeySizeWidth:@640,EMMessageBodyAttrKeySizeHeight:@1136},
//                               EMMessageBodyAttrKeyFileName:@"image.jpg",
//                               EMMessageBodyAttrKeyType:EMMessageBodyAttrTypeImag,
//                               EMMessageBodyAttrKeyUrl:@"https://a1.easemob.com/easemob-demo/chatdemoui/chatfiles/7e622080-e4ae-11e4-8a29-c1c8b3fc3a16",
//                               EMMessageBodyAttrKeyFileLength:@178212};
//    EMImageMessageBody *imageBody = [EMImageMessageBody imageMessageBodyFromBodyDict:imageDic forChatter:_chatter];
//    EMMessage *image = [[EMMessage alloc] initMessageWithID:@"50152415936119390" sender:_chatter receiver:@"my_test4" bodies:@[imageBody]];
//    image.timestamp = ([[NSDate date] timeIntervalSince1970] - 10) * 1000;
//    image.isReadAcked = YES;
//    image.deliveryState = eMessageDeliveryState_Delivered;
//    image.isRead = YES;
//    image.isGroup = self.isChatGroup;
//    image.conversationChatter = @"my_test5";
//
//    NSDictionary *voiceDic = @{EMMessageBodyAttrKeySecret:@"ZTKmSuSxEeS2upsPo9JVK-E7e7W_Ieu6g55uSbYCQikqSmh1",
//                               EMMessageBodyAttrKeyFileName:@"audio chat",
//                               EMMessageBodyAttrKeyDuration:@6,
//                               EMMessageBodyAttrKeyType:EMMessageBodyAttrTypeAudio,
//                               EMMessageBodyAttrKeyUrl:@"https://a1.easemob.com/easemob-demo/chatdemoui/chatfiles/6532a640-e4b1-11e4-9a0a-019cf64935ae",
//                               EMMessageBodyAttrKeyFileLength:@8870};
//
//    EMVoiceMessageBody *voiceBody = [EMVoiceMessageBody voiceMessageBodyFromBodyDict:voiceDic forChatter:_chatter];
//    EMMessage *voice = [[EMMessage alloc] initMessageWithID:@"50152415936119490" sender:_chatter receiver:@"my_test4" bodies:@[voiceBody]];
//    voice.timestamp = ([[NSDate date] timeIntervalSince1970] - 5) * 1000;
//    voice.isReadAcked = YES;
//    voice.deliveryState = eMessageDeliveryState_Delivered;
//    voice.isRead = YES;
//    voice.isGroup = isChatGroup;
//    voice.conversationChatter = @"my_test5";
//
//    NSDictionary *videoDic = @{EMMessageBodyAttrKeySecret:@"ANfQauSzEeSWceXUdNLCzOoCWyafJ0jg5AticaEKlEVCeqD2",
//                               EMMessageBodyAttrKeyDuration:@12,
//                               EMMessageBodyAttrKeyThumbSecret:@"AHShyuSzEeS9Eo2-FC-hEqTv7L96P5LNxUCo2zGrbZfu9FWz",
//                               EMMessageBodyAttrKeySize:@{EMMessageBodyAttrKeySizeWidth:@68,EMMessageBodyAttrKeySizeHeight:@90},
//                               EMMessageBodyAttrKeyThumb:@"https://a1.easemob.com/easemob-demo/chatdemoui/chatfiles/0074a1c0-e4b3-11e4-9adb-9da24ed370c3",
//                               EMMessageBodyAttrKeyFileName:@"video.mp4",
//                               EMMessageBodyAttrKeyType:@"video",
//                               EMMessageBodyAttrKeyFileLength:@1235670,
//                               EMMessageBodyAttrKeyUrl:@"https://a1.easemob.com/easemob-demo/chatdemoui/chatfiles/00d7d060-e4b3-11e4-9906-8311a663fa09"};
//
//    EMVideoMessageBody *videoBody = [EMVideoMessageBody videoMessageBodyFromBodyDict:videoDic forChatter:_chatter];
//    EMMessage *video = [[EMMessage alloc] initMessageWithID:@"50152415936119590" sender:_chatter receiver:@"my_test4" bodies:@[videoBody]];
//    video.timestamp = ([[NSDate date] timeIntervalSince1970] - 1) * 1000;
//    video.isReadAcked = YES;
//    video.deliveryState = eMessageDeliveryState_Delivered;
//    video.isRead = YES;
//    video.isGroup = isChatGroup;
//    video.conversationChatter = @"my_test5";
//    [[EaseMob sharedInstance].chatManager insertMessagesToDB:@[image, voice, video]];
//    [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
//}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.view.frame;
        if (keyboardBeginHeight==0) {
        rect.size.height = self.view.frame.size.height-256;
        }else{
         rect.size.height = self.view.frame.size.height-keyboardEndHeight;
        }
        self.view.frame = rect;
        CGRect tableRect=self.tableView.frame;
        tableRect.origin.y=60;
        tableRect.size.height=self.view.frame.size.height-160;
        self.tableView.frame=tableRect;
    }];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.tableView endEditing:YES];
    [_inputTextField resignFirstResponder];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.view.frame.size.height!=kSCREEN_HEIGHT) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.view.frame;
            rect.size.height = kSCREEN_HEIGHT;
            self.view.frame = rect;
            
            CGRect tableRect=self.tableView.frame;
            tableRect.origin.y=60;
            tableRect.size.height=self.view.frame.size.height-140;
            self.tableView.frame=tableRect;
        }];
        [self.view layoutSubviews];
    }
  
}
@end
