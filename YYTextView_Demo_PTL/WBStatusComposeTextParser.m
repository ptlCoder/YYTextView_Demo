//
//  WBStatusComposeTextParser.m
//  YYKitExample
//
//  Created by ibireme on 15/9/5.
//  Copyright (C) 2015 ibireme. All rights reserved.
//

#import "WBStatusComposeTextParser.h"
#import "WBStatusHelper.h"

@implementation WBStatusComposeTextParser

- (instancetype)init {
    self = [super init];
    _font = [UIFont systemFontOfSize:17];
    _textColor = [UIColor colorWithWhite:0.2 alpha:1];
    _highlightTextColor = UIColorHex(527ead);
    return self;
}

- (BOOL)parseText:(NSMutableAttributedString *)text selectedRange:(NSRangePointer)selectedRange {
    text.color = _textColor;
    text.font = _font;
    
    {
        NSArray<NSTextCheckingResult *> *atResults = [[WBStatusHelper regexAt] matchesInString:text.string options:kNilOptions range:text.rangeOfAll];
        for (NSTextCheckingResult *at in atResults) {
            if (at.range.location == NSNotFound && at.range.length <= 1) continue;
            
            __block BOOL containsBindingRange = NO;
            [text enumerateAttribute:YYTextBindingAttributeName inRange:at.range options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop) {
                if (value) {
                    containsBindingRange = YES;
                    *stop = YES;
                }
            }];
            if (containsBindingRange) continue;
            
            
            [text setColor:_highlightTextColor range:at.range];
        }
    }

    return YES;
}

// correct the selected range during text replacement
- (NSRange)_replaceTextInRange:(NSRange)range withLength:(NSUInteger)length selectedRange:(NSRange)selectedRange {
    // no change
    if (range.length == length) return selectedRange;
    // right
    if (range.location >= selectedRange.location + selectedRange.length) return selectedRange;
    // left
    if (selectedRange.location >= range.location + range.length) {
        selectedRange.location = selectedRange.location + length - range.length;
        return selectedRange;
    }
    // same
    if (NSEqualRanges(range, selectedRange)) {
        selectedRange.length = length;
        return selectedRange;
    }
    // one edge same
    if ((range.location == selectedRange.location && range.length < selectedRange.length) ||
        (range.location + range.length == selectedRange.location + selectedRange.length && range.length < selectedRange.length)) {
        selectedRange.length = selectedRange.length + length - range.length;
        return selectedRange;
    }
    selectedRange.location = range.location + length;
    selectedRange.length = 0;
    return selectedRange;
}


- (NSAttributedString *)_attachmentWithFontSize:(CGFloat)fontSize image:(UIImage *)image shrink:(BOOL)shrink {
    
    //    CGFloat ascent = YYEmojiGetAscentWithFontSize(fontSize);
    //    CGFloat descent = YYEmojiGetDescentWithFontSize(fontSize);
    //    CGRect bounding = YYEmojiGetGlyphBoundingRectWithFontSize(fontSize);
    
    // Heiti SC 字体。。
    CGFloat ascent = fontSize * 0.86;
    CGFloat descent = fontSize * 0.14;
    CGRect bounding = CGRectMake(0, -0.14 * fontSize, fontSize, fontSize);
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(ascent - (bounding.size.height + bounding.origin.y), 0, descent + bounding.origin.y, 0);
    
    YYTextRunDelegate *delegate = [YYTextRunDelegate new];
    delegate.ascent = ascent;
    delegate.descent = descent;
    delegate.width = bounding.size.width;
    
    YYTextAttachment *attachment = [YYTextAttachment new];
    attachment.contentMode = UIViewContentModeScaleAspectFit;
    attachment.contentInsets = contentInsets;
    attachment.content = image;
    
    if (shrink) {
        // 缩小~
        CGFloat scale = 1 / 10.0;
        contentInsets.top += fontSize * scale;
        contentInsets.bottom += fontSize * scale;
        contentInsets.left += fontSize * scale;
        contentInsets.right += fontSize * scale;
        contentInsets = UIEdgeInsetPixelFloor(contentInsets);
        attachment.contentInsets = contentInsets;
    }
    
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:YYTextAttachmentToken];
    [atr setTextAttachment:attachment range:NSMakeRange(0, atr.length)];
    CTRunDelegateRef ctDelegate = delegate.CTRunDelegate;
    [atr setRunDelegate:ctDelegate range:NSMakeRange(0, atr.length)];
    if (ctDelegate) CFRelease(ctDelegate);
    
    return atr;
}

@end
