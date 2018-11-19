//
//  ViewController.m
//  YYTextView_Demo_PTL
//
//  Created by soliloquy on 2018/11/19.
//  Copyright © 2018 ptlCoder. All rights reserved.
//

#import "ViewController.h"
#import "YYKit/YYKit.h"
#import "WBStatusComposeTextParser.h"


#define kToolbarHeight (35 + 46)


@interface ViewController ()<YYTextViewDelegate>

@property (nonatomic, strong) YYTextView *textView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      [self _initTextView];
}

- (void)_initTextView {
    if (_textView) return;
    _textView = [YYTextView new];
    _textView.size = CGSizeMake(self.view.width, self.view.height);
    _textView.textContainerInset = UIEdgeInsetsMake(12, 16, 12, 16);
    _textView.contentInset = UIEdgeInsetsMake(0, 0, kToolbarHeight, 0);
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _textView.extraAccessoryViewHeight = kToolbarHeight;
    _textView.showsVerticalScrollIndicator = NO;
    _textView.alwaysBounceVertical = YES;
    _textView.allowsCopyAttributedString = NO;
    _textView.font = [UIFont systemFontOfSize:17];
    _textView.textParser = [WBStatusComposeTextParser new];
    _textView.delegate = self;
    _textView.inputAccessoryView = [UIView new];
    
    NSString *placeholderPlainText = @"分享新鲜事...";
    if (placeholderPlainText) {
        NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:placeholderPlainText];
        atr.color = UIColorHex(b4b4b4);
        atr.font = [UIFont systemFontOfSize:17];
        _textView.placeholderAttributedText = atr;
    }
    
    [self.view addSubview:_textView];
}

- (IBAction)addAtNameClick:(id)sender {
    NSArray *atArray = @[@"@姚晨 ", @"@陈坤 ", @"@赵薇 ", @"@Angelababy " , @"@TimCook ", @"@我的印象笔记 "];
    NSString *atString = [atArray randomObject];
    [_textView replaceRange:_textView.selectedTextRange withText:atString];
}

#pragma mark @protocol YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView {
    NSLog(@"%@", textView.text);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

@end
