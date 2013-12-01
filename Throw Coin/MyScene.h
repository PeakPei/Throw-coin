//
//  MyScene.h
//  Throw Coin
//

//  Copyright (c) 2013年 maixun network. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>
@interface MyScene : SKScene<UIAccelerometerDelegate,SKPhysicsContactDelegate>
{
    double currentMaxAccelz;
    BOOL iscreated;
    CGRect screenRect;
}
@property (strong, nonatomic) CMMotionManager *motionManager;
@end
