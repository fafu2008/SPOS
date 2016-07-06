//
//  APNumberPadDefaultStyle.m
//  APNumberPad
//
//  Created by Andrew Podkovyrin on 16/05/14.
//  Copyright (c) 2014 Podkovyrin. All rights reserved.
//

#import "APNumberPadDefaultStyle.h"

static inline UIColor * APNP_RGBa(int r, int g, int b, CGFloat alpha) {
    return [UIColor colorWithRed:r / 255.f
                           green:g / 255.f
                            blue:b / 255.f
                           alpha:alpha];
}

@implementation APNumberPadDefaultStyle

#pragma mark - Pad

+ (CGRect)numberPadFrame {
    return CGRectMake(0.f, 0.f, 320.f, 216.f);
}

+ (CGFloat)separator {
    return [UIScreen mainScreen].scale == 2.f ? 0.5f : 1.f;
}

+ (UIColor *)numberPadBackgroundColor {
    return APNP_RGBa(183, 186, 191, 1.f);
}

#pragma mark - Number button

+ (UIFont *)numberButtonFont {
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:28.f];
}

+ (UIColor *)numberButtonTextColor {
    return [UIColor blackColor];
}

+ (UIColor *)numberButtonBackgroundColor {
    return APNP_RGBa(252, 252, 252, 1.f);
}

+ (UIColor *)numberButtonHighlightedColor {
    return APNP_RGBa(188, 192, 198, 1.f);
}

#pragma mark - Function button

+ (UIFont *)functionButtonFont {
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:28.f];
}

+ (UIColor *)functionButtonTextColor {
    return [UIColor blackColor];
}

+ (UIColor *)functionButtonBackgroundColor {
    return [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1];
}

+ (UIColor *)functionButtonHighlightedColor {
    return [UIColor lightGrayColor];
}

+ (UIImage *)clearFunctionButtonImage {
    return [UIImage imageNamed:@"cleanButton"];
}


@end
