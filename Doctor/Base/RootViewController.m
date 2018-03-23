//
//  RootViewController.m
//
//
//  Created by cuiwei on 14-7-9.
//  Copyright (c) 2014年 Creditease. All rights reserved.
//

#import "RootViewController.h"
#import "Dock.h"
#import "HomeViewController.h"
#import "PendingViewController.h"
#import "MessageListViewController.h"
#import "MineViewController.h"

#define kContentFrame CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kDOCK_HEIGHT)
#define kDockFrame CGRectMake(0, self.view.frame.size.height - kDOCK_HEIGHT, self.view.frame.size.width, kDOCK_HEIGHT)

@interface RootViewController ()<UINavigationControllerDelegate>
{
    Dock *_dock;
}
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.创建dock
    [self createDock];
    
    // 2.创建所有的子控制器
    [self createChildViewControllers];
    
    // 3.默认选中第2个控制器
    [self selecteControllerAtIndex:0];
    
    // 4.设置导航栏主题
    [self setNavigationTheme];
}

#pragma mark 设置导航栏主题
- (void)setNavigationTheme {
    // 1.导航栏
    // 1.1.操作navBar相当操作整个应用中的所有导航栏
    UINavigationBar *navBar = [UINavigationBar appearance];
    // 1.2.设置导航栏背景
    [navBar setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(47, 92, 116)] forBarMetrics:UIBarMetricsDefault];
    // 1.3.设置导航栏的文字
    [navBar setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor whiteColor]}];
}

#pragma mark 重写父类的方法：添加一个子控制器
- (void)addChildViewController:(UIViewController *)childController {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childController];
    nav.delegate = self;
    [super addChildViewController:nav];
}

#pragma mark - 导航控制器代理方法
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 根控制器
    UIViewController *root = navigationController.viewControllers[0];
    
//    NSLog(@"root: %f  ,%f  ,%f  ,%f",root.view.frame.origin.y,root.view.frame.size.height,self.view.frame.origin.y,self.view.frame.size.height);
    
    if (viewController != root) {
        
        // 更改导航控制器view的frame
        navigationController.view.frame = self.view.bounds;
        
        // 让Dock从MainViewController上移除
        [_dock removeFromSuperview];
        
        // 调整Dock的Y值
        CGRect dockFrame = _dock.frame;
        if ([root.view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollview = (UIScrollView *)root.view;
            dockFrame.origin.y = scrollview.contentOffset.y + root.view.frame.size.height - kDOCK_HEIGHT;
        } else {
            dockFrame.origin.y = self.view.frame.size.height - kDOCK_HEIGHT - (kDOCK_HEIGHT + 20) + 5 +kNAVBAR_HEIGHT;
        }
        _dock.frame = dockFrame;
        
        // 添加dock到根控制器界面
        [root.view addSubview:_dock];
    }
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIViewController *root = navigationController.viewControllers[0];
    if (viewController == root) {
        
        // 更改导航控制器view的frame
        navigationController.view.frame = kContentFrame;
        
        // 让Dock从root上移除
        [_dock removeFromSuperview];
        
        // 添加dock到MainViewController
        _dock.frame = kDockFrame;
        [self.view addSubview:_dock];
    }
}

#pragma mark - 创建所有的子控制器
- (void)createChildViewControllers {
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    [self addChildViewController:homeVC];
    
    PendingViewController *pendingVC = [[PendingViewController alloc] init];
    [self addChildViewController:pendingVC];
    
    MessageListViewController *messageVC = [[MessageListViewController alloc] init];
    [self addChildViewController:messageVC];
    
    MineViewController *mineVC = [[MineViewController alloc] init];
    [self addChildViewController:mineVC];
}

#pragma mark - 创建dock
- (void)createDock {
    // 1.创建dock
    _dock = [Dock sharedDock];
    _dock.superVC = self;
    [self.view addSubview:_dock];
    
    // 2.监听Dock内部item的点击
    __weak RootViewController *this = self;
    _dock.itemClickBlock = ^(int index){
        [this selecteControllerAtIndex:index];
    };
}

#pragma mark - 选中index位置对应的子控制器
- (void)selecteControllerAtIndex:(int)index {
    // 1.取出新的控制器
    UINavigationController *new = self.childViewControllers[index];
    if (new == _selectedViewController) return;
    
    // 2.移除当前控制器的view
    [_selectedViewController.view removeFromSuperview];
    
    // 3.添加新控制器的view
    new.view.frame = kContentFrame;
    
    [self.view addSubview:new.view];
    
    // 4.让新控制器成为当前当前选中的控制器
    _selectedViewController = new;
}

#pragma mark - 重新登录时谈回到指定首页的特殊处理
- (void)addDockForControllerAtIndex:(int)index {
    [_dock removeFromSuperview];
    _dock.frame = kDockFrame;
    [self.view addSubview:_dock];
}
@end
