//
//  XhrStoreScrollView.h
//  dinghuiShow
//
//  Created by xuanhr on 13-4-1.
//  Copyright (c) 2013年 xuanhr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

//typedef enum {
//    XhrDirectionPortait,          // 垂直滚动
//    XhrDirectionLandscape         // 水平滚动
//}XhrDirection;

@protocol XhrStoreScrollViewDelegate;

@interface XhrStoreScrollView : UIView <UIScrollViewDelegate, UIScrollViewAccessibilityDelegate, UIPageViewControllerDelegate,UIGestureRecognizerDelegate> {

    UIScrollView *scrollView;
    UIImageView *curImageView;
    UIPageControl *curPageView;

    NSInteger totalPage;
    NSInteger curPage;
    CGRect scrollFrame;

    BOOL goMoveBool;
    float timeInterval;
    NSTimer *timer;

    NSMutableArray *imagesArray; // 存放所有需要滚动的图片 UIImage的url或者UIImage
    NSMutableArray *curImages;   // 存放当前滚动的三张图片
    NSMutableArray *threeImagesArray;
    NSArray *jsonArry;
    //id <XhrStoreScrollViewDelegate> delegate;
}

//@property NSInteger curPage;
//@property BOOL isCycle;
@property (nonatomic, weak) id delegate;

- (int)validPageValue:(NSInteger)value;
- (id)initWithFrame:(CGRect)frame pictures:(NSArray *)pictureArray time:(float)timefloat;
- (id)initWithFrame:(CGRect)frame pictures:(NSArray *)pictureArray time:(float)timefloat isShowPage:(BOOL)canShowPage;
- (id)initWithFrame:(CGRect)frame pictures:(NSArray *)pictureArray time:(float)timefloat isShowPage:(BOOL)canShowPage PageControlIndex:(NSInteger)index;
- (NSArray *)getDisplayImagesWithCurpage:(int)page;
- (void)refreshScrollView;
- (void)GoMove;
- (void)AdImg:(NSArray *)arr;

@end

@protocol XhrScrollViewDelegate <NSObject>
@optional
- (void)XhrScrollViewDelegate:(XhrStoreScrollView *)cycleScrollView didSelectImageView:(int)index;
- (void)XhrScrollViewDelegate:(XhrStoreScrollView *)cycleScrollView didScrollImageView:(int)index;

@end
