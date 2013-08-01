//
//  DAPageContainerScrollView.m
//  DAPagesContainerScrollView
//
//  Created by Daria Kopaliani on 5/29/13.
//  Copyright (c) 2013 Daria Kopaliani. All rights reserved.
//

#import "DAPagesContainer.h"

#import "DAPagesContainerTopBar.h"
#import "DAPageIndicatorView.h"


@interface DAPagesContainer () <DAPagesContainerTopBarDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) DAPagesContainerTopBar *topBar;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (weak,   nonatomic) UIScrollView *observingScrollView;
@property (strong, nonatomic) DAPageIndicatorView *pageIndicatorView;

@property (          assign, nonatomic) BOOL shouldObserveContentOffset;
@property (readonly, assign, nonatomic) CGFloat scrollWidth;
@property (readonly, assign, nonatomic) CGFloat scrollHeight;

- (void)layoutSubviews;
- (void)startObservingContentOffsetForScrollView:(UIScrollView *)scrollView;
- (void)stopObservingContentOffset;

@end


@implementation DAPagesContainer

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)dealloc
{
    [self stopObservingContentOffset];
}

- (void)setUp
{
    _topBarHeight = 38.;
    _topBarBackgroundColor = [UIColor colorWithWhite:0.1 alpha:0];
    _topBarItemLabelsFont = [UIFont systemFontOfSize:12];
    _pageIndicatorViewSize = CGSizeMake(45., 3.);
    self.scrollView.directionalLockEnabled = TRUE;

}

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.shouldObserveContentOffset = YES;
        
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.,
                                                                     self.topBarHeight,
                                                                     CGRectGetWidth(self.view.frame),
                                                                     CGRectGetHeight(self.view.frame) - self.topBarHeight)];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth
        | UIViewAutoresizingFlexibleHeight;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    [self startObservingContentOffsetForScrollView:self.scrollView];    

    self.topBar = [[DAPagesContainerTopBar alloc] initWithFrame:CGRectMake(0.,
                                                                           0.,
                                                                           CGRectGetWidth(self.view.frame),
                                                                           self.topBarHeight)];
    self.topBar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    self.topBar.delegate = self;
    [self.view addSubview:self.topBar];

    self.pageIndicatorView = [[DAPageIndicatorView alloc] initWithFrame:CGRectMake(0.,
                                                                                   0,
                                                                                   self.pageIndicatorViewSize.width,
                                                                                   self.pageIndicatorViewSize.height)];
    [self.view addSubview:self.pageIndicatorView];
    self.topBar.backgroundColor = self.pageIndicatorView.color = self.topBarBackgroundColor;
    self.scrollView.bounces = NO;
    self.scrollView.bouncesZoom = NO;
    self.scrollView.alwaysBounceHorizontal = NO;
}

- (void)viewDidUnload
{
    [self stopObservingContentOffset];
    self.scrollView = nil;
    self.topBar = nil;
    self.pageIndicatorView = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self layoutSubviews];
}

#pragma mark - Public

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated
{
    UIButton *previosSelectdItem = self.topBar.itemViews[self.selectedIndex];
    UIButton *nextSelectdItem = self.topBar.itemViews[selectedIndex];
    UIViewController *leftViewController = self.viewControllers[MIN(self.selectedIndex, selectedIndex)];
    UIViewController *rightViewController = self.viewControllers[MAX(self.selectedIndex, selectedIndex)];
    if (abs(self.selectedIndex - selectedIndex) <= 1) {
        [self.scrollView setContentOffset:CGPointMake(selectedIndex * self.scrollWidth, 0.) animated:animated];
        if (selectedIndex == _selectedIndex) {
            self.pageIndicatorView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:selectedIndex].x,
                                                        self.pageIndicatorView.center.y);
            //leftViewController.view.alpha = 1.0;
            //rightViewController.view.alpha = 1.0;

        }

        [UIView animateWithDuration:(animated) ? 0.3 : 0. delay:0. options:UIViewAnimationOptionBeginFromCurrentState animations:^
         {
             [previosSelectdItem setTitleColor:[UIColor colorWithWhite:0.6 alpha:1.] forState:UIControlStateNormal];
             [nextSelectdItem setTitleColor:[UIColor colorWithWhite:1. alpha:1.] forState:UIControlStateNormal];
         } completion:nil];
    } else {
        // This means we should "jump" over at least one view controller
        self.shouldObserveContentOffset = NO;
        BOOL scrollingRight = (selectedIndex > self.selectedIndex);
        leftViewController.view.frame = CGRectMake(0., 0., self.scrollWidth, self.scrollHeight);
        rightViewController.view.frame = CGRectMake(self.scrollWidth, 0., self.scrollWidth, self.scrollHeight);
        self.scrollView.contentSize = CGSizeMake(2 * self.scrollWidth, self.scrollHeight);
        
        CGPoint targetOffset;
        if (scrollingRight) {
            self.scrollView.contentOffset = CGPointZero;
            targetOffset = CGPointMake(self.scrollWidth, 0.);
            /*[UIView animateWithDuration:0.5 animations:^{
                leftViewController.view.alpha = 1.0;
                rightViewController.view.alpha = 1.0;
            }];*/
        } else {
            self.scrollView.contentOffset = CGPointMake(self.scrollWidth, 0.);
            targetOffset = CGPointZero;
            /*[UIView animateWithDuration:0.5 animations:^{
                rightViewController.view.alpha = 1.0;
                leftViewController.view.alpha = 1.0;
            }];*/
            
        }
        [self.scrollView setContentOffset:targetOffset animated:YES];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{

            leftViewController.view.alpha = 0;
            rightViewController.view.alpha = 0;
            
            self.pageIndicatorView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:selectedIndex].x,
                                                        self.pageIndicatorView.center.y);
            self.topBar.scrollView.contentOffset = [self.topBar contentOffsetForSelectedItemAtIndex:selectedIndex];
            [previosSelectdItem setTitleColor:[UIColor colorWithWhite:0.6 alpha:1.] forState:UIControlStateNormal];
            [nextSelectdItem setTitleColor:[UIColor colorWithWhite:1. alpha:1.] forState:UIControlStateNormal];


        } completion:^(BOOL finished) {
            for (NSUInteger i = 0; i < self.viewControllers.count; i++) {
                UIViewController *viewController = self.viewControllers[i];
                viewController.view.frame = CGRectMake(i * self.scrollWidth, 0., self.scrollWidth, self.scrollHeight);
                [self.scrollView addSubview:viewController.view];
            }
            self.scrollView.contentSize = CGSizeMake(self.scrollWidth * self.viewControllers.count, self.scrollHeight);
            [self.scrollView setContentOffset:CGPointMake(selectedIndex * self.scrollWidth, 0.) animated:NO];
            self.scrollView.userInteractionEnabled = YES;
            self.shouldObserveContentOffset = YES;
            leftViewController.view.alpha = 1;
            rightViewController.view.alpha = 1;
        }];
    }
    _selectedIndex = selectedIndex;


}

- (void)updateLayoutForNewOrientation:(UIInterfaceOrientation)orientation
{
    [self layoutSubviews];
}

#pragma mark * Overwritten setters

- (void)setPageIndicatorViewSize:(CGSize)size
{
    if (!CGSizeEqualToSize(self.pageIndicatorView.frame.size, size)) {
        _pageIndicatorViewSize = size;
        [self layoutSubviews];
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (void)setTopBarBackgroundColor:(UIColor *)topBarBackgroundColor
{
    _topBarBackgroundColor = topBarBackgroundColor;
    self.topBar.backgroundColor = topBarBackgroundColor;
    self.pageIndicatorView.color = topBarBackgroundColor;
}

- (void)setTopBarHeight:(NSUInteger)topBarHeight
{
    if (_topBarHeight != topBarHeight) {
        _topBarHeight = topBarHeight;
        [self layoutSubviews];
    }
}

- (void)setTopBarItemLabelsFont:(UIFont *)font
{
    self.topBar.font = font;
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    if (_viewControllers != viewControllers) {
        _viewControllers = viewControllers;
        self.topBar.itemTitles = [viewControllers valueForKey:@"title"];
        for (UIViewController *viewController in viewControllers) {
            [viewController willMoveToParentViewController:self];
            viewController.view.frame = CGRectMake(0., 0., CGRectGetWidth(self.scrollView.frame), self.scrollHeight);
            [self.scrollView addSubview:viewController.view];
            [viewController didMoveToParentViewController:self];
        }
        [self layoutSubviews];
        self.selectedIndex = 0;
        self.pageIndicatorView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:self.selectedIndex].x,
                                                    self.pageIndicatorView.center.y);
    }
}

#pragma mark - Private

- (void)layoutSubviews
{
    self.topBar.frame = CGRectMake(0., 0., CGRectGetWidth(self.view.bounds), self.topBarHeight);
    self.pageIndicatorView.frame = CGRectMake(0.,
                                              self.topBarHeight,
                                              self.pageIndicatorViewSize.width,
                                              self.pageIndicatorViewSize.height);
    CGFloat x = 0.;
    for (UIViewController *viewController in self.viewControllers) {
        viewController.view.frame = CGRectMake(x, 0, CGRectGetWidth(self.scrollView.frame), self.scrollHeight);
        x += CGRectGetWidth(self.scrollView.frame);
    }
    self.scrollView.contentSize = CGSizeMake(x, self.scrollHeight);
    [self.scrollView setContentOffset:CGPointMake(self.selectedIndex * self.scrollWidth, 0.) animated:YES];
    self.pageIndicatorView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:self.selectedIndex].x,
                                                self.pageIndicatorView.center.y);
    self.topBar.scrollView.contentOffset = [self.topBar contentOffsetForSelectedItemAtIndex:self.selectedIndex];
    self.scrollView.userInteractionEnabled = YES;
}

- (CGFloat)scrollHeight
{
    return CGRectGetHeight(self.view.frame) - self.topBarHeight;
}

- (CGFloat)scrollWidth
{
    return CGRectGetWidth(self.scrollView.frame);
}

- (void)startObservingContentOffsetForScrollView:(UIScrollView *)scrollView
{
    //[scrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];

    //self.observingScrollView = scrollView;
}
- (void)didAddSubview:(UIView *)subview {;
    [subview removeObserver:self forKeyPath:@"contentOffset"];
}
- (void)stopObservingContentOffset
{
    if (self.observingScrollView) {
        [self.observingScrollView removeObserver:self forKeyPath:@"contentOffset"];
        self.observingScrollView = nil;
    }
}

#pragma mark - DAPagesContainerTopBar delegate

- (void)itemAtIndex:(NSUInteger)index didSelectInPagesContainerTopBar:(DAPagesContainerTopBar *)bar
{
    [self setSelectedIndex:index animated:YES];
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.selectedIndex = scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.frame);
    self.scrollView.userInteractionEnabled = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        self.scrollView.userInteractionEnabled = YES;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.scrollView.userInteractionEnabled = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 0 || scrollView.contentOffset.y < 0) {
        CGPoint offset = scrollView.contentOffset;
        offset.y = 0;
        scrollView.contentOffset = offset;
        //NSLog(@"no scrolling lol");
        return;
    }
    CGFloat oldX = self.selectedIndex * CGRectGetWidth(self.scrollView.frame);
    if (scrollView.contentOffset.x == 0 || scrollView.contentOffset.x == -0 || scrollView.contentOffset.x == -1 || scrollView.contentOffset.x == 1) {
        return;
    }
    if (oldX != self.scrollView.contentOffset.x && self.shouldObserveContentOffset) {
        BOOL scrollingTowards = (self.scrollView.contentOffset.x > oldX);
        NSInteger targetIndex = (scrollingTowards) ? self.selectedIndex + 1 : self.selectedIndex - 1;

        if (targetIndex >= 0 && targetIndex < self.viewControllers.count) {
            UIViewController *leftView = self.viewControllers[MIN(self.selectedIndex, targetIndex)];
            UIViewController *rightView = self.viewControllers[MAX(self.selectedIndex, targetIndex)];
            CGFloat ratio = (self.scrollView.contentOffset.x - oldX) / CGRectGetWidth(self.scrollView.frame);
            CGFloat previousItemContentOffsetX = [self.topBar contentOffsetForSelectedItemAtIndex:self.selectedIndex].x;
            CGFloat nextItemContentOffsetX = [self.topBar contentOffsetForSelectedItemAtIndex:targetIndex].x;
            CGFloat previousItemPageIndicatorX = [self.topBar centerForSelectedItemAtIndex:self.selectedIndex].x;
            CGFloat nextItemPageIndicatorX = [self.topBar centerForSelectedItemAtIndex:targetIndex].x;
            UIButton *previosSelectedItem = self.topBar.itemViews[self.selectedIndex];

            UIButton *nextSelectedItem = self.topBar.itemViews[targetIndex];
            [previosSelectedItem setTitleColor:[UIColor colorWithWhite:0.6 + 0.4 * (1 - fabsf(ratio))
                                                                 alpha:1.] forState:UIControlStateNormal];
            [nextSelectedItem setTitleColor:[UIColor colorWithWhite:0.6 + 0.4 * fabsf(ratio)
                                                              alpha:1.] forState:UIControlStateNormal];

            if (scrollingTowards) {
                self.topBar.scrollView.contentOffset = CGPointMake(previousItemContentOffsetX +
                        (nextItemContentOffsetX - previousItemContentOffsetX) * ratio , 0.);
                self.pageIndicatorView.center = CGPointMake(previousItemPageIndicatorX +
                        (nextItemPageIndicatorX - previousItemPageIndicatorX) * ratio,
                        self.pageIndicatorView.center.y);

               /* if (self.fadeIndex == targetIndex) {
                   UIView animateWithDuration:0.5 animations:^{
                        leftView.view.alpha = 1.0;
                        rightView.view.alpha = 1.0;
                    }];
                }
                else {
                    [UIView animateWithDuration:0.5 animations:^{
                        leftView.view.alpha = 0.5;
                        rightView.view.alpha = 1.0;
                    }];

                }*/


            } else {
                self.topBar.scrollView.contentOffset = CGPointMake(previousItemContentOffsetX -
                        (nextItemContentOffsetX - previousItemContentOffsetX) * ratio , 0.);
                self.pageIndicatorView.center = CGPointMake(previousItemPageIndicatorX -
                        (nextItemPageIndicatorX - previousItemPageIndicatorX) * ratio,
                        self.pageIndicatorView.center.y);
                /*[UIView animateWithDuration:0.5 animations:^{
                    leftView.view.alpha = 1.0;
                    rightView.view.alpha = 0.5;
                }];*/




            }
        }
    }
    //self.scrollView.userInteractionEnabled = NO;
}
#pragma mark - KVO


@end