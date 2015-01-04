//
//  OLGhostAlertView.h
//
//  Originally created by Radu Dutzan.
//  (c) 2012 Onda.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, OLGhostAlertViewPosition) {
    OLGhostAlertViewPositionBottom,
    OLGhostAlertViewPositionCenter,
    OLGhostAlertViewPositionTop
};

@interface OLGhostAlertView : UIView

- (id)initWithTitle:(NSString *)title;
- (id)initWithTitle:(NSString *)title message:(NSString *)message;
- (id)initWithTitle:(NSString *)title message:(NSString *)message timeout:(NSTimeInterval)timeout dismissible:(BOOL)dismissible;
- (void)show;
- (void)hide;
@property NSTimeInterval timeout;
@property (nonatomic) OLGhostAlertViewPosition position;
@property (nonatomic, copy) void (^completionBlock)(void);
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy ) NSString *message;
@property (nonatomic, readonly, getter=isVisible) BOOL visible;

@end