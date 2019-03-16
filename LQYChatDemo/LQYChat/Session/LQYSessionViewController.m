//
//  LQYSessionViewController.m
//  IDoTo
//
//  Created by luoyuan on 2019/1/23.
//  Copyright © 2019年 luoyuan. All rights reserved.
//

#import "LQYSessionViewController.h"
#import "LQYChatConfig.h"
#import "LQYSessionTimeCell.h"
#import "LQYKeyboardInfo.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@interface LQYSessionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) CGFloat inputViewHeight;

@end

@implementation LQYSessionViewController

- (NSMutableArray<LQYMessageModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (UITableView *)tableView {
    return _tableView;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
    [self setupInputView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidHide:) name:UIMenuControllerDidHideMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:LQYKeyboardWillChangeFrameNotification object:nil];
    
}

- (void)setupTableView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [LQYChatConfig shared].sessionViewBackgroundColor;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    if ([self.sessionConfig respondsToSelector:@selector(sessionBackgroundImage)] && [self.sessionConfig sessionBackgroundImage]) {
//        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//        imgView.image = [self.sessionConfig sessionBackgroundImage];
//        imgView.contentMode = UIViewContentModeScaleAspectFill;
//        self.tableView.backgroundView = imgView;
//    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (void)setupInputView {
    _inputView = [[LQYInputView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    _inputView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
//    [_inputView setSession:self.session];
    [_inputView setInputDelegate:self];
    [_inputView setInputActionDelegate:self];
    [_inputView refreshStatus:LQYInputTypeText];
    [_inputView becomeFirstResponder];
    [self.view addSubview:_inputView];
}

- (void)reloadDataWithAnimation:(BOOL)animation {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView scrollToBottom:animation];
        if (self.tableView.contentSize.height <= self.tableView.frame.size.height) {
            [self adjustInputView];
            [self adjustTableView];
        }
    });
}

- (void)resetLayout {
    [self adjustInputView];
    [self adjustTableView];
}

- (void)adjustInputView {
    UIView *superView = self.inputView.superview;
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *))
    {
        safeAreaInsets = superView.safeAreaInsets;
    }
    CGRect frame = self.inputView.frame;
    frame.origin.y = superView.frame.size.height - safeAreaInsets.bottom - frame.size.height;
    self.inputView.frame = frame;
}

- (void)adjustTableView
{
    //输入框是否弹起
    BOOL inputViewUp = NO;
    switch (self.inputView.inputType)
    {
        case LQYInputTypeText:
            inputViewUp = [LQYKeyboardInfo shared].isVisiable;
            break;
        case LQYInputTypeAudio:
            inputViewUp = NO;
            break;
        case LQYInputTypeMore:
        case LQYInputTypeEmoticon:
            inputViewUp = YES;
        default:
            break;
    }
    self.tableView.userInteractionEnabled = !inputViewUp;
    CGRect rect = self.tableView.frame;
    
    //tableview 的位置
    UIView *superView = self.tableView.superview;
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *))
    {
        safeAreaInsets = superView.safeAreaInsets;
    }
    
    CGFloat containerSafeHeight = self.tableView.superview.frame.size.height - safeAreaInsets.bottom;
    
    rect.size.height = containerSafeHeight - self.inputView.toolBar.frame.size.height;
    
    
    //tableview 的内容 inset
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    CGFloat visiableHeight = 0;
    if (@available(iOS 11.0, *))
    {
        contentInsets = self.tableView.adjustedContentInset;
    }
    else
    {
        contentInsets = self.tableView.contentInset;
    }
    
    //如果气泡过少，少于总高度，输入框视图需要顶到最后一个气泡的下面。
    visiableHeight = visiableHeight + self.tableView.contentSize.height + contentInsets.top + contentInsets.bottom;
    visiableHeight = MIN(visiableHeight, rect.size.height);
    
    rect.origin.y    = containerSafeHeight - visiableHeight - self.inputView.frame.size.height;
    rect.origin.y    = rect.origin.y > 0 ? 0 : rect.origin.y;
    
    
    BOOL tableChanged = !CGRectEqualToRect(self.tableView.frame, rect);
    if (tableChanged)
    {
        [self.tableView setFrame:rect];
        [self.tableView scrollToBottom:YES];
    }
}

- (void)adjustOffset:(NSInteger)row {
    if (row >= 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        });
    }
}


- (void)changeLayout:(CGFloat)inputViewHeight
{
    BOOL change = _inputViewHeight != inputViewHeight;
    if (change)
    {
        _inputViewHeight = inputViewHeight;
        [self adjustInputView];
        [self adjustTableView];
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.styleDelegate && [self.styleDelegate respondsToSelector:@selector(LQYTableView:heightForHeaderInSection:)]) {
        return [self.styleDelegate LQYTableView:tableView heightForHeaderInSection:section];
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.styleDelegate && [self.styleDelegate respondsToSelector:@selector(LQYTableView:viewForHeaderInSection:)]) {
        return [self.styleDelegate LQYTableView:tableView viewForHeaderInSection:section];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LQYMessageModel *model = self.dataArr[indexPath.row];
    
    if (model.isTimestamp) {
        return model.timestampCellHieght;
    }
    
    CGFloat cellHeight = 0;
    CGSize size = [model contentSize:tableView.frame.size.width];
    
    UIEdgeInsets contentViewInsets = model.contentViewInsets;
    UIEdgeInsets bubbleViewInsets  = model.bubbleViewInsets;
    cellHeight = size.height + contentViewInsets.top + contentViewInsets.bottom + bubbleViewInsets.top + bubbleViewInsets.bottom;
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LQYMessageModel *model = self.dataArr[indexPath.row];
    if (self.styleDelegate && [self.styleDelegate respondsToSelector:@selector(LQYTableView:cellForRowAtIndexPath:messageModel:)]) {
        UITableViewCell *cell = [self.styleDelegate LQYTableView:tableView cellForRowAtIndexPath:indexPath messageModel:model];
        if (cell) {
            if ([[cell class] isSubclassOfClass:[LQYSessionMessageCell class]]) {
                ((LQYSessionMessageCell *)cell).delegate = self;
            }
            return cell;
        }
    }
    
    if (model.isTimestamp) {
        NSString *identity = NSStringFromClass([LQYSessionTimeCell class]);
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
        if (!cell) {
            [tableView registerClass:[LQYSessionTimeCell class] forCellReuseIdentifier:identity];
            cell = [tableView dequeueReusableCellWithIdentifier:identity];
        }
        
        [(LQYSessionTimeCell *)cell loadModel:model];
        
        return cell;
    } else {
        NSString *identity = NSStringFromClass(model.contentViewClass);
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
        if (!cell) {
            [tableView registerClass:[LQYSessionMessageCell class] forCellReuseIdentifier:identity];
            cell = [tableView dequeueReusableCellWithIdentifier:identity];
        }
        
        ((LQYSessionMessageCell *)cell).delegate = self;
        [(LQYSessionMessageCell *)cell refreshData:model];
        
        return cell;
    }
}

#pragma mark - touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [_inputView endEditing:YES];
}

#pragma mark - LQYInputDelegate

- (void)didChangeInputHeight:(CGFloat)inputHeight {
    [self changeLayout:inputHeight];
}

#pragma mark - LQYMessageCellDelegate

- (void)onTapContentView:(LQYMessageModel *)model {
    
    if (model.messageType == LQYMessageTypeImage) { //图片点击
        
    }
}

#pragma mark - LQYInputActionDelegate

- (void)onSendText:(NSString *)text atUsers:(NSArray *)atUsers {
    
}

- (void)onSendImageData:(NSData *)imageData {
    
}

- (BOOL)onTapMoreItem:(LQYMoreItem *)item {
    SEL sel = item.selctor;
    BOOL response = [self respondsToSelector:sel];
    if (response) {
        SuppressPerformSelectorLeakWarning([self performSelector:sel withObject:item]);
    }
    return response;
}

/**
 * 相册
 */
- (void)onTapMediaItemPicture:(LQYMoreItem *)item {
    
}

/**
 * 拍照
 */
- (void)onTapMediaItemShoot:(LQYMoreItem *)item {
    
}


#pragma mark - Notification

- (void)menuDidHide:(NSNotification *)notification
{
    [UIMenuController sharedMenuController].menuItems = nil;
}


- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    if (!self.tableView.window)
    {
        //如果当前视图不是顶部视图，则不需要监听
        return;
    }
    [self.inputView sizeToFit];
}

#pragma mark - dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


@implementation UITableView (LQY)

- (void)scrollToBottom:(BOOL)animation {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSInteger row = [self numberOfRowsInSection:0] - 1;
        if (row > 0)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            @try {
                [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animation];
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
            
        }
    });
}

@end
