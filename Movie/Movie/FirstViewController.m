//
//  FirstViewController.m
//  Movie
//
//  Created by 袁文轶 on 16/1/18.
//  Copyright © 2016年 wx. All rights reserved.
//

#import "FirstViewController.h"
#import "XhrStoreScrollView.h"
@interface FirstViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) NSMutableArray *objectsForShow;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;


@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = _headerView.frame;
    rect.size.height = self.view.frame.size.width / 2;
    _headerView.frame = rect;
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, rect.size.height - 40, rect.size.width, 40)];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    _pageControl.numberOfPages = 6;
    _pageControl.currentPage = 0;
    [_headerView addSubview:_pageControl];
    if (self.navigationController.tabBarItem.tag == 0) {
        self.navigationItem.title = @"First";
    } else {
        self.navigationItem.title = @"Second";
    }
    
    CGFloat imageW = self.view.frame.size.width;
    CGFloat imageH = rect.size.height;
    CGFloat imageY = 0;
    NSInteger totalCount = 6;
    for (int i = 0; i < totalCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        CGFloat imageX = i * imageW;
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        imageView.clipsToBounds = YES;
        //设置图片
        NSString *name = [NSString stringWithFormat:@"shouye%d", i + 1];
        imageView.image = [UIImage imageNamed:name];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self.scrollView addSubview:imageView];

                
        
    }
    CGFloat contentW = totalCount *imageW;
    self.scrollView.contentSize = CGSizeMake(contentW, rect.size.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    

    [self addTimer];
}

- (void)nextImage{
    int page = (int)self.pageControl.currentPage;
    if (page == 5) {
        page = 0;
    }else{
        page++;
    }
    CGFloat x = page * _headerView.frame.size.width;
    self.scrollView.contentOffset = CGPointMake(x, 0);

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollviewW = _headerView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollviewW / 2) /  scrollviewW;
    self.pageControl.currentPage = page;
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
}

- (void)addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
}

- (void)removeTimer{
    [self.timer invalidate];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
