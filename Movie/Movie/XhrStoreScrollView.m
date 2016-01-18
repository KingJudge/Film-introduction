//
//  XhrStoreScrollView.m
//  dinghuiShow
//
//  Created by xuanhr on 13-4-1.
//  Copyright (c) 2013年 xuanhr. All rights reserved.
//

#import "XhrStoreScrollView.h"

@interface XhrStoreScrollView ()
@property (nonatomic, assign) CGRect boundSize;
@end

@implementation XhrStoreScrollView
//@synthesize delegate = _delegate ;
//@synthesize curPage = curPage;
- (id)initWithFrame:(CGRect)frame pictures:(NSArray *)pictureArray time:(float)timefloat {
    return [self initWithFrame:frame pictures:pictureArray time:timefloat isShowPage:YES];
}

//- (id)initWithFrame:(CGRect)frame pictures:(NSArray *)pictureArray time:(float)timefloat isShowPage:(BOOL)canShowPage {
- (id)initWithFrame:(CGRect)frame pictures:(NSArray *)pictureArray time:(float)timefloat isShowPage:(BOOL)canShowPage PageControlIndex:(NSInteger)index {
    _boundSize = [UIScreen mainScreen].bounds;
    frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self = [super initWithFrame:frame];
    if (self) {
        scrollFrame = frame;
        timeInterval = timefloat;
        totalPage = pictureArray.count;
        jsonArry = pictureArray;
        curPage = 1; // 显示的是图片数组里的第一张图片
        curImages = [[NSMutableArray alloc] init];
        imagesArray = [[NSMutableArray alloc] initWithCapacity:5];
        threeImagesArray = [[NSMutableArray alloc] initWithCapacity:4];
        for (int i = 0; i < [pictureArray count]; i++) {
            [imagesArray addObject:[pictureArray objectAtIndex:i]];
        }
        //定时器
        if (timeInterval != 0) {
            [timer invalidate];
            timer = nil;
            timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(GoMove) userInfo:nil repeats:YES];
        }
        goMoveBool = NO;

        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scrollView.backgroundColor = [UIColor whiteColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;

        [scrollView.layer setShadowOffset:CGSizeMake(0, 3)];
        [scrollView.layer setShadowOpacity:.6];
        [scrollView.layer setShadowColor:[UIColor blackColor].CGColor];

        [self addSubview:scrollView];
        self.backgroundColor = [UIColor whiteColor];

        // 在水平方向滚动

        scrollView.contentSize = CGSizeMake(scrollFrame.size.width * 3,
                                            scrollFrame.size.height);

        [self addSubview:scrollView];

        //pageView
        if (index == 0) {
            curPageView = [[UIPageControl alloc] initWithFrame:CGRectMake(200, scrollFrame.size.height - 20, scrollFrame.size.width - 200, 20)];
        } else if (index == 1) {
            curPageView = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, scrollFrame.size.width, 15)];
        } else if (index == 2) {
            curPageView = [[UIPageControl alloc] initWithFrame:CGRectMake(0, scrollFrame.size.height - 15 , scrollFrame.size.width, 15)];
        }

        //page的位置
        curPageView.currentPage = 1;
        curPageView.numberOfPages = totalPage;
        curPageView.pageIndicatorTintColor = [UIColor grayColor];
        curPageView.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"53CE70"];
        //        curPageView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5f];
        [curPageView setUserInteractionEnabled:NO];
        curPageView.backgroundColor = [UIColor clearColor];
        if (canShowPage) {
            [self addSubview:curPageView];
        }

        [self DoImgeArry:imagesArray];
        [self refreshScrollView];
    }

    return self;
}

void UIImageFromURL(NSURL *URL, void (^imageBlock)(UIImage *image), void (^errorBlock)(void)) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
      NSData *data = [[NSData alloc] initWithContentsOfURL:URL];
      UIImage *image = [[UIImage alloc] initWithData:data];
      dispatch_async(dispatch_get_main_queue(), ^(void) {
        if (image != nil) {
            imageBlock(image);
        } else {
            errorBlock();
        }
      });
    });
}

- (void)AdImg:(NSArray *)arr {
    NSMutableArray *arrForImage = [[NSMutableArray alloc] initWithCapacity:20];
    [curImages removeAllObjects];

    for (int i = 0; i < [arr count]; i++) {
        NSString *url = [arr objectAtIndex:i];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(_boundSize.size.width * i, 0, scrollFrame.size.width, scrollFrame.size.height)];
        [img setImage:[UIImage imageNamed:@""]];

        [arrForImage addObject:img];

        UIImageFromURL([NSURL URLWithString:url], ^(UIImage *image) {
          [img setImage:image];
        }, ^(void){
                       });
        //*/
    }
    imagesArray = [[NSMutableArray alloc] initWithArray:arrForImage];

    if (imagesArray.count > 0 && imagesArray.count < 3) {
        NSMutableArray *arrForImage = [[NSMutableArray alloc] initWithCapacity:20];
        for (int i = 0; i < 4; i++) {
            NSString *url = [arr objectAtIndex:i % imagesArray.count];
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(_boundSize.size.width * i, 0, scrollFrame.size.width, scrollFrame.size.height)];
            [img setImage:[UIImage imageNamed:@""]];

            [arrForImage addObject:img];

            UIImageFromURL([NSURL URLWithString:url], ^(UIImage *image) {
              [img setImage:image];
            }, ^(void){
                           });
        }
        threeImagesArray = [[NSMutableArray alloc] initWithArray:arrForImage];
    }
}

#pragma 异步下载图片或直接添加图片到view
- (void)DoImgeArry:(NSArray *)ImgeArrys {
    if ([ImgeArrys count] <= 1) {
        return;
    }
    
    if ([[ImgeArrys objectAtIndex:0] isKindOfClass:[NSString class]]) {
        [self AdImg:ImgeArrys];
        return;
    } else if ([[ImgeArrys objectAtIndex:0] isKindOfClass:[UIImage class]]) {
        NSMutableArray *arrForImage = [[NSMutableArray alloc] initWithCapacity:20];
        for (int i = 0; i < [ImgeArrys count]; i++) {
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(_boundSize.size.width * i, 0, _boundSize.size.width, scrollView.frame.size.height)];
            img.image = [ImgeArrys objectAtIndex:i];
            img.userInteractionEnabled = YES;

            [arrForImage addObject:img];
        }
        imagesArray = [[NSMutableArray alloc] initWithArray:arrForImage];
    } else if ([[imagesArray objectAtIndex:0] isKindOfClass:[UIView class]]) {
        NSMutableArray *arrForImage = [[NSMutableArray alloc] initWithCapacity:20];
        for (int i = 0; i < [ImgeArrys count]; i++) {
            UIView *view = [ImgeArrys objectAtIndex:i];
            [view setFrame:CGRectMake(_boundSize.size.width * i, 0, _boundSize.size.width, scrollView.frame.size.height)];
            view.userInteractionEnabled = YES;
            [arrForImage addObject:view];
        }
        imagesArray = [[NSMutableArray alloc] initWithArray:arrForImage];
    }
    if (imagesArray.count > 0 && imagesArray.count < 3) {
        NSMutableArray *arrForImage = [[NSMutableArray alloc] initWithCapacity:20];
        for (int i = 0; i < 4; i++) {
            UIView *tempView = [imagesArray objectAtIndex:i % imagesArray.count];
            [tempView setFrame:CGRectMake(_boundSize.size.width * i, 0, scrollFrame.size.width, scrollFrame.size.height)];

            [arrForImage addObject:tempView];
            threeImagesArray = [[NSMutableArray alloc] initWithArray:arrForImage];
        }
    }
}

- (void)refreshScrollView {
    if ([imagesArray count] == 0) {
        return;
    }
    if (imagesArray.count == 1) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:scrollFrame];
        imageView.userInteractionEnabled = YES;
        if ([[imagesArray objectAtIndex:0] isKindOfClass:[NSString class]]) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:imagesArray[0]]];
        }else{
            imageView = [imagesArray objectAtIndex:0];
        }
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:singleTap];
        singleTap.delegate = self;
        // 水平滚动
        imageView.frame = CGRectOffset(scrollFrame, scrollFrame.size.width * 0, 0);
        [scrollView addSubview:imageView];
        curPageView.currentPage = 1;
        [scrollView setContentSize:CGSizeMake(0, 0)];
        return;

    }
    NSArray *subViews = [scrollView subviews];
    if ([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }

    [self getDisplayImagesWithCurpage:curPage];


    int showImageNumber;
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:scrollFrame];
        imageView.userInteractionEnabled = YES;
        imageView = [curImages objectAtIndex:i];
        switch (i) {
        case 0:
            showImageNumber = [self validPageValue:curPage - 1] - 1;
            break;
        case 1:
            showImageNumber = [self validPageValue:curPage] - 1;
            break;
        case 2:
            showImageNumber = [self validPageValue:curPage + 1] - 1;
            break;
        default:
            break;
        }

        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:singleTap];
        singleTap.delegate = self;
        // 水平滚动
        imageView.frame = CGRectOffset(scrollFrame, scrollFrame.size.width * i, 0);

        //        UILabel *listBtnLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, scrollFrame.size.height-90, scrollFrame.size.width, 30)];
        //        listBtnLabel.text = [NSString stringWithFormat:@"名称:%@",[[jsonArry objectAtIndex:showImageNumber]objectForKey:@"name" ]] ;
        //        listBtnLabel.backgroundColor = [UIColor clearColor];
        //        listBtnLabel.textColor = [UIColor whiteColor];
        //        listBtnLabel.textAlignment = NSTextAlignmentLeft;
        //        [listBtnLabel setFont:[UIFont fontWithName:@"Arial" size:20]];
        //        [listBtnLabel sizeToFit];
        //        [imageView addSubview:listBtnLabel];
        //        UILabel *listBtnLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(5, scrollFrame.size.height-70, scrollFrame.size.width, 30)];
        //        listBtnLabel2.text = [NSString stringWithFormat:@"距离:%@m",[[jsonArry objectAtIndex:showImageNumber]objectForKey:@"distance" ]] ;
        //        listBtnLabel2.backgroundColor = [UIColor clearColor];
        //        listBtnLabel2.textColor = [UIColor whiteColor];
        //        listBtnLabel2.textAlignment = NSTextAlignmentLeft;
        //        [listBtnLabel2 setFont:[UIFont fontWithName:@"Arial" size:17]];
        //        [listBtnLabel2 sizeToFit];
        //        [imageView addSubview:listBtnLabel2];
        //        UILabel *listBtnLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(5, scrollFrame.size.height-50, scrollFrame.size.width, 30)];
        //        listBtnLabel3.text = [NSString stringWithFormat:@"地址:%@",[[jsonArry objectAtIndex:showImageNumber]objectForKey:@"address" ]] ;
        //        listBtnLabel3.backgroundColor = [UIColor clearColor];
        //        listBtnLabel3.textColor = [UIColor whiteColor];
        //        listBtnLabel3.textAlignment = NSTextAlignmentLeft;
        //        [listBtnLabel3 setFont:[UIFont fontWithName:@"Arial" size:17]];
        //        [listBtnLabel3 sizeToFit];
        //        [imageView addSubview:listBtnLabel3];
        [scrollView addSubview:imageView];

        //        NSLog(@"showImg--x%f",scrollView.frame.origin.x);
        //        NSLog(@"showImg--y%f",scrollView.frame.origin.y);
    }

    if (goMoveBool) {
        goMoveBool = NO;

        //[UIView beginAnimations:@"flip"context:nil];//动画开始
        //[UIView setAnimationDuration:0.75];
        //        [UIView setAnimationDelegate:self];
        //        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:scrollView cache:YES];
        //        [UIView commitAnimations];
        //
        //        [UIView animateWithDuration:0.7 //速度0.7秒
        //                         animations:^{//修改坐标
        //                             scrollView.contentOffset = CGPointMake(scrollFrame.size.width, 0);
        //                        }];

        //scrollView.contentOffset = CGPointMake(scrollFrame.size.width, 0);

        CATransition *animation = [CATransition animation];
        [animation setDuration:.3f];
        [animation setTimingFunction:[CAMediaTimingFunction
                                         functionWithName:kCAMediaTimingFunctionEaseIn]];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromRight];
        [scrollView.layer addAnimation:animation forKey:@"Push"];
        [scrollView setContentOffset:CGPointMake(scrollFrame.size.width, 0) animated:YES];

    } else {
        [scrollView setContentOffset:CGPointMake(scrollFrame.size.width, 0)];
    }

    //[UIView commitAnimations];

    curPageView.currentPage = curPage - 1;
}

- (NSArray *)getDisplayImagesWithCurpage:(int)page {
    if ([imagesArray count] == 0) {
        return nil;
    }
    int pre = [self validPageValue:curPage - 1];
    int last = [self validPageValue:curPage + 1];

    if ([curImages count] != 0)
        [curImages removeAllObjects];

    [curImages addObject:[imagesArray objectAtIndex:pre - 1]];
    [curImages addObject:[imagesArray objectAtIndex:curPage - 1]];
    [curImages addObject:[imagesArray objectAtIndex:last - 1]];

    if (imagesArray.count < 3) {
        curImages[0] = threeImagesArray[0 + page % 2];
        curImages[1] = threeImagesArray[1 + page % 2];
        curImages[2] = threeImagesArray[2 + page % 2];
    }

    return curImages;
}

- (int)validPageValue:(NSInteger)value {

    if (value == 0)
        value = totalPage; // value＝1为第一张，value = 0为前面一张
    if (value == totalPage + 1)
        value = 1;

    return (int)value;
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {

    int x = aScrollView.contentOffset.x;
    //int y = aScrollView.contentOffset.y;
    //NSLog(@"did  x=%d  y=%d", x, y);

    // 水平滚动
    // 往下翻一张
    if (x >= (2 * scrollFrame.size.width)) {
        curPage = [self validPageValue:curPage + 1];
        [self refreshScrollView];
    }
    if (x <= 0) {
        curPage = [self validPageValue:curPage - 1];
        [self refreshScrollView];
    }

    if ([_delegate respondsToSelector:@selector(XhrScrollViewDelegate:didScrollImageView:)]) {
        [_delegate XhrScrollViewDelegate:self didScrollImageView:curPage - 1];
    }
    curPageView.currentPage = curPage - 1;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {

    [scrollView setContentOffset:CGPointMake(scrollFrame.size.width, 0) animated:YES];
}

- (void)handleTap:(UITapGestureRecognizer *)tap {

    if ([_delegate respondsToSelector:@selector(XhrScrollViewDelegate:didSelectImageView:)]) {
        [_delegate XhrScrollViewDelegate:self didSelectImageView:curPage - 1];
    }
}

- (void)GoMove {
    goMoveBool = YES;
    curPage = [self validPageValue:curPage + 1];

    [self refreshScrollView];
    if ([_delegate respondsToSelector:@selector(XhrScrollViewDelegate:didScrollImageView:)]) {
        [_delegate XhrScrollViewDelegate:self didScrollImageView:curPage - 1];
    }
}

@end
