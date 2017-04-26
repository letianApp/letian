//
//  GQSegment.h
//  GQSegment
//
//  Created by 郭茜 on 12/19/15.
//  Copyright © 2015 letian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SegmentDelegate <NSObject>
@optional
- (void)scrollToPage:(int)page;
@end

@interface GQSegment : UIView {
    id <SegmentDelegate> delegate;
}

@property (nonatomic, weak) id <SegmentDelegate> delegate;

@property(nonatomic, assign) CGFloat maxWidth;
@property(nonatomic,strong)NSMutableArray *titleList;
@property(nonatomic,strong)NSMutableArray *buttonList;
@property(nonatomic,weak)CALayer *LGLayer;
@property(nonatomic,assign)CGFloat bannerNowX;

+ (instancetype)initWithTitleList:(NSMutableArray *)titleList;

-(id)initWithTitleList:(NSMutableArray*)titleList;

-(void)moveToOffsetX:(CGFloat)X;

-(void)buttonClick:(id)sender;

@end
