//
//  MyScene.m
//  Throw Coin
//
//  Created by meng on 13-11-15.
//  Copyright (c) 2013年 maixun network. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene
{
    SKSpriteNode *_coin,*_coinA;
    NSArray *_bearWalkingFrames;
}
-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.physicsWorld.gravity=CGVectorMake(0, -9.8);//配置重力系统
        screenRect = [[UIScreen mainScreen] bounds];
        /*增加背景*/
        SKSpriteNode *background_img=[[SKSpriteNode alloc] initWithImageNamed:@"desk 3"];
        [self addChild:background_img];
        /*增加硬币*/
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.accelerometerUpdateInterval = .02;
        //self.motionManager.gyroUpdateInterval = .2;
        
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                                 withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                                     [self outputAccelertionData:accelerometerData.acceleration];
                                                     if(error){
                                                         
                                                         NSLog(@"%@", error);
                                                     }
                                                 }];
        
        [self creatCoinA];
        
        
        
            }
    return self;
}
-(void)EnemiesAndClouds{
    //not always come
    int GoOrNot = [self getRandomNumberBetween:1 to:1];
    
    if(GoOrNot == 1){
        
        SKSpriteNode *enemy;
        
        int randomEnemy = [self getRandomNumberBetween:0 to:1];
        if(randomEnemy == 0)
            enemy = [SKSpriteNode spriteNodeWithImageNamed:@"PLANE 2 N"];
        else
            enemy = [SKSpriteNode spriteNodeWithImageNamed:@"PLANE 1 N"];
        
        
        enemy.scale = 0.6;
        
        enemy.position = CGPointMake(screenRect.size.width/2, screenRect.size.height/2);
        enemy.zPosition = 1;
        
        
        CGMutablePathRef cgpath = CGPathCreateMutable();
        
        //random values
        float xStart = [self getRandomNumberBetween:0 to:screenRect.size.width ];
        float xEnd = [self getRandomNumberBetween:0 to:screenRect.size.width ];
        
        //ControlPoint1
        float cp1X = [self getRandomNumberBetween:0+enemy.size.width to:screenRect.size.width-enemy.size.width ];
        float cp1Y = [self getRandomNumberBetween:0+enemy.size.width to:screenRect.size.width-enemy.size.height ];
        
        //ControlPoint2
        float cp2X = [self getRandomNumberBetween:0+enemy.size.width to:screenRect.size.width-enemy.size.width ];
        float cp2Y = [self getRandomNumberBetween:0 to:cp1Y];
        
        CGPoint s = CGPointMake(xStart, 1136.0);
        CGPoint e = CGPointMake(xEnd, -100.0);
        CGPoint cp1 = CGPointMake(cp1X, cp1Y);
        CGPoint cp2 = CGPointMake(cp2X, cp2Y);
        CGPathMoveToPoint(cgpath,NULL, s.x, s.y);
        CGPathAddCurveToPoint(cgpath, NULL, cp1.x, cp1.y, cp2.x, cp2.y, e.x, e.y);
        
        SKAction *planeDestroy = [SKAction followPath:cgpath asOffset:NO orientToPath:YES duration:5];
        [self addChild:enemy];
        
        SKAction *remove = [SKAction removeFromParent];
        [enemy runAction:[SKAction sequence:@[planeDestroy,remove]]];
        
        CGPathRelease(cgpath);
    
        
    }
    
}

-(void)outputAccelertionData:(CMAcceleration)acceleration
{
    currentMaxAccelz = 1.01;
    
    if(acceleration.z > fabs(currentMaxAccelz))
    {
        if(iscreated==NO)
        {
         [self CreatCoin];
        }
    }
   
    
    
}
-(void)CreatCoin
{
    
    NSMutableArray *walkFrames = [NSMutableArray array];
    SKTextureAtlas *bearAnimatedAtlas=[SKTextureAtlas atlasNamed:@"coins"];
    int numImages=[bearAnimatedAtlas.textureNames count];
    for (int i=1;i<= numImages;i++) {
        NSString *textureName = [NSString stringWithFormat:@"%d",i];
        SKTexture *temp = [bearAnimatedAtlas textureNamed:textureName];
        [walkFrames addObject:temp];
    }
    _bearWalkingFrames = walkFrames;
    SKTexture *temp = _bearWalkingFrames[0];
    _coin = [SKSpriteNode spriteNodeWithTexture:temp];
    _coin.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [_coinA removeFromParent];
    
    
    _coin.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_coin.size];
    
    _coin.physicsBody.usesPreciseCollisionDetection = YES;
    _coin.physicsBody.velocity=CGVectorMake(0, 1000.55);
    [_coin.physicsBody applyImpulse:CGVectorMake(0, 49.8)];
    [self addChild:_coin];
    iscreated=YES;
    [self walkingBear];
    
    
    
}

-(void)walkingBear
{
    //让硬币转起来.
    
    
    [_coin runAction:[SKAction repeatActionForever:
                      [SKAction animateWithTextures:_bearWalkingFrames
                                       timePerFrame:0.01f
                                             resize:NO
                                            restore:YES]] withKey:@"walkingInPlaceBear" ];
    
    
    SKAction *act=[SKAction  sequence: @[
                                            [SKAction waitForDuration:1.25],
                                            [SKAction performSelector:@selector(stopruncoins) onTarget:self]
                                            
                                            ]];
    act.timingMode=SKActionTimingEaseOut;
    [_coin runAction:[SKAction repeatActionForever:act]];
    return;
}
-(int)getRandomNumberBetween:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}

-(void)creatCoinA
{
    int a=[self getRandomNumberBetween:0 to:20];
    if(a<10){
        _coinA=[[SKSpriteNode alloc] initWithImageNamed:@"02"];
    }
    else if(a>10){
    _coinA=[[SKSpriteNode alloc] initWithImageNamed:@"10"];
    }
    else if(a==10){
    _coinA=[[SKSpriteNode alloc] initWithImageNamed:@"06"];
    }
    _coinA.position=CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:_coinA];
    
    if(a==10){
        //schedule enemies
        SKAction *wait = [SKAction waitForDuration:0.5];
        SKAction *callEnemies = [SKAction runBlock:^{
            [self EnemiesAndClouds];
        }];
        
        SKAction *updateEnimies = [SKAction sequence:@[wait,callEnemies]];
        [self runAction:updateEnimies];
    }
    
}
-(void)stopruncoins
{
    iscreated=NO;
    [_coin removeFromParent];
    [self creatCoinA];
    SKAction *playbomb=[SKAction playSoundFileNamed:@"dd.wav" waitForCompletion:NO];
    [self runAction:playbomb];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    NSLog(@"%f",_coin.position.y);
}

@end
