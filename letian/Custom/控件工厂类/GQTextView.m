//
//  GQTextView.m
//  letian
//
//  Created by 郭茜 on 2017/5/12.
//  Copyright © 2017年 J. All rights reserved.
//

#import "GQTextView.h"

@implementation GQTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    [self ezCustom];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self ezCustom];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer{
    if (self = [super initWithFrame:frame textContainer:textContainer]) {
        [self ezCustom];
    }
    return self;
}
- (instancetype)init{
    if (self = [super init]) {
        [self ezCustom];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self ezCustom];
    }
    return self;
}
- (void)ezCustom{
    self.layer.cornerRadius = 8;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
}
-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    [self setNeedsDisplay];
}

-(void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}

-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self setNeedsDisplay];
}

-(void)setText:(NSString *)text
{
    [super setText:text];
    [self setNeedsDisplay];
}

-(void)textDidChange
{
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    if ([self hasText]) return;
    NSMutableDictionary * attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = self.placeholderColor ? self.placeholderColor : [UIColor lightGrayColor];
    attrs[NSFontAttributeName] = self.font ? self.font : [UIFont systemFontOfSize:12];
    
    CGFloat x = 5;
    CGFloat y = 5;
    CGFloat w = self.frame.size.width - 2 * x;
    CGFloat h = self.frame.size.height - 2 * y;
    CGRect placeholderRect = CGRectMake(x, y, w, h);
    [self.placeholder drawInRect:placeholderRect withAttributes:attrs];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
