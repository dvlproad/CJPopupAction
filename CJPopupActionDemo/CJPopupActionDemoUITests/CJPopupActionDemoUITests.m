//
//  CJPopupActionDemoUITests.m
//  CJPopupActionDemoUITests
//
//  Created by 李超前 on 2016/12/14.
//  Copyright © 2016年 dvlproad. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface CJPopupActionDemoUITests : XCTestCase

@end

@implementation CJPopupActionDemoUITests

- (void)setUp {
    [super setUp];
    self.continueAfterFailure = NO;
}

- (void)tearDown {
    [super tearDown];
}

// 冒烟测试：验证兄弟模式下 popupInView 弹出后，点击遮罩空白区域可以正常隐藏
- (void)testPopupInView_ShowAndTapBlankHide {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    // 1. 进入 CareAboutHide tab
    XCUIElement *careTab = app.tabBars.buttons[@"CareAboutHide"];
    if (![careTab waitForExistenceWithTimeout:10]) {
        XCTFail(@"找不到 CareAboutHide tab");
        return;
    }
    [careTab tap];

    // 2. 进入 PopupInView demo
    XCUIElement *popupCell = app.tables.staticTexts[@"PopupInView (弹出到指定View)"];
    if (![popupCell waitForExistenceWithTimeout:10]) {
        XCTFail(@"找不到 PopupInView 入口");
        return;
    }
    [popupCell tap];

    // 3. 点击 PopupInView1 按钮触发弹出
    XCUIElement *showButton = app.buttons[@"PopupInView1"];
    if (![showButton waitForExistenceWithTimeout:10]) {
        XCTFail(@"找不到 PopupInView1 按钮");
        return;
    }
    CGRect buttonFrame = showButton.frame;
    [showButton tap];

    // 等待弹出动画完成
    [NSThread sleepForTimeInterval:1.0];

    // 4. 验证 popupView(绿色) 出现在按钮下方
    CGRect appFrame = app.frame;
    CGPoint popupSample = CGPointMake(CGRectGetMidX(buttonFrame),
                                      CGRectGetMaxY(buttonFrame) + 50);
    UIColor *popupColor = [self pixelColorAtNormalizedPoint:CGPointMake(popupSample.x / appFrame.size.width,
                                                                       popupSample.y / appFrame.size.height)];
    BOOL popupShown = [self isGreenColor:popupColor];
    XCTAssertTrue(popupShown, @"弹出视图未出现，采样色 = %@", popupColor);

    // 5. 点击遮罩空白区域(弹出框下方)，应触发隐藏
    CGPoint blankTap = CGPointMake(CGRectGetMidX(buttonFrame),
                                   CGRectGetMaxY(buttonFrame) + 160);
    XCUICoordinate *blankCoordinate = [app coordinateWithNormalizedOffset:CGVectorMake(blankTap.x / appFrame.size.width,
                                                                                       blankTap.y / appFrame.size.height)];
    [blankCoordinate tap];

    [NSThread sleepForTimeInterval:1.0];

    // 6. 验证 popupView(绿色) 已消失
    UIColor *afterColor = [self pixelColorAtNormalizedPoint:CGPointMake(popupSample.x / appFrame.size.width,
                                                                        popupSample.y / appFrame.size.height)];
    BOOL popupHidden = ![self isGreenColor:afterColor];
    XCTAssertTrue(popupHidden, @"点击遮罩后弹出视图未隐藏，采样色 = %@", afterColor);
}

#pragma mark - Helpers

- (BOOL)isGreenColor:(UIColor *)color {
    if (color == nil) return NO;
    CGFloat r = 0, g = 0, b = 0, a = 0;
    [color getRed:&r green:&g blue:&b alpha:&a];
    return (g > 0.7 && r < 0.3 && b < 0.3);
}

- (UIColor *)pixelColorAtNormalizedPoint:(CGPoint)normalizedPoint {
    XCUIScreenshot *screenshot = XCUIScreen.mainScreen.screenshot;
    UIImage *image = screenshot.image;
    CGImageRef cgImage = image.CGImage;
    if (cgImage == NULL) {
        return nil;
    }

    NSUInteger width = CGImageGetWidth(cgImage);
    NSUInteger height = CGImageGetHeight(cgImage);
    if (width == 0 || height == 0) {
        return nil;
    }

    NSUInteger x = (NSUInteger)(normalizedPoint.x * (CGFloat)width);
    NSUInteger y = (NSUInteger)(normalizedPoint.y * (CGFloat)height);
    x = MIN(x, width - 1);
    y = MIN(y, height - 1);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    unsigned char *rawData = (unsigned char *)calloc(height * bytesPerRow, sizeof(unsigned char));

    CGContextRef context = CGBitmapContextCreate(rawData, width, height, 8, bytesPerRow,
                                                 colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);

    NSUInteger byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
    CGFloat red = rawData[byteIndex] / 255.0;
    CGFloat green = rawData[byteIndex + 1] / 255.0;
    CGFloat blue = rawData[byteIndex + 2] / 255.0;

    CGContextRelease(context);
    free(rawData);
    CGColorSpaceRelease(colorSpace);

    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

@end
