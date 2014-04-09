//
//  CJMyScene.m
//  Arrrrgh
//
//  Created by Shane Vitarana on 4/2/14.
//  Copyright (c) 2014 CrimsonJet. All rights reserved.
//

#import "CJMyScene.h"

#include <stdlib.h>
#import "CJScrollingNode.h"
#import "CJShipNode.h"

static const uint32_t shipCategory     =  0x1 << 0;
static const uint32_t obstacleCategory =  0x1 << 1;
static const uint32_t krakenCategory   =  0x1 << 2;

#define WIDTH(view) view.frame.size.width
#define HEIGHT(view) view.frame.size.height
#define X(view) view.frame.origin.x
#define Y(view) view.frame.origin.y

#define kCanalScrollingSpeed     3
#define kHorizontalGapSize       100
#define kSpawnBridgeTimeInterval 1

@interface CJMyScene () <SKPhysicsContactDelegate> {
    
    CJShipNode *_ship;
    SKNode *_world;
    
    CJScrollingNode *_canalLeft;
    CJScrollingNode *_canalRight;
    
    BOOL _isGameOver;
    
    CFTimeInterval _lastUpdateTimeInterval;
    CFTimeInterval _lastSpawnTimeInterval;
}

@end

@implementation CJMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor colorWithRed:0.16 green:0.65 blue:0.84 alpha:1.0];
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        
        [self createWorld];
        [self createCanal];
        [self createShip];
//        [self createKraken];
    }
    return self;
}

- (void)update:(CFTimeInterval)currentTime {
    
    if (!_isGameOver) {
        if (_world.speed > 0.0) {
            _world.speed = _world.speed - 0.0005;
        }
        
        [_canalLeft update:currentTime];
        [_canalRight update:currentTime];
    }
    
    // Handle time delta.
    // If we drop below 60fps, we still want everything to move the same distance.
    CFTimeInterval timeSinceLast = currentTime - _lastUpdateTimeInterval;
    _lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        _lastUpdateTimeInterval = currentTime;
    }
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
}

- (void)setBlowLevel:(CGFloat)blowLevel {
    _world.speed = blowLevel;
}

#pragma mark - SKPhysicsContactDelegate

- (void)didBeginContact:(SKPhysicsContact *)contact
{
//    if (contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask) {
//        NSLog(@"contact..");
//    } else {
//        NSLog(@"contact kraken? bodyA %d bodyB %d", contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask);
//  
//        SKNode *kraken;
//        if ([contact.bodyA.node.name isEqualToString:@"kraken"]) {
//            kraken = contact.bodyA.node;
//        } else {
//            kraken = contact.bodyB.node;
//        }
//        // move kraken between bridge
//        SKAction *move = [SKAction moveByX:100.0 y:0.0 duration:0.25];
//        [kraken runAction:move];
//    }
    
    [self gameOver];
}

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if (location.x < CGRectGetMidX(_ship.frame)) {
            // detected left side touch
            [_ship moveLeft];
        }
        else {
            [_ship moveRight];
        }
    }
}

#pragma mark - Internal Methods

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    _lastSpawnTimeInterval += timeSinceLast;
    if (_lastSpawnTimeInterval > kSpawnBridgeTimeInterval) {
        _lastSpawnTimeInterval = 0;
        [self createBridge];
    }
}

- (void)createWorld {
    _world = [SKNode node];
    _world.speed = 0.0;
    [self addChild:_world];
}

- (void)createCanal {
    CJScrollingNode *leftCanal = [self createCanalNodeWithImage:@"canal" atPosx:0.0];
    [self addChild:leftCanal];
    _canalLeft = leftCanal;
    
    CJScrollingNode *rightCanal = [self createCanalNodeWithImage:@"canal_right" atPosx:298.0];
    [self addChild:rightCanal];
    _canalRight = rightCanal;
}

- (CJScrollingNode *)createCanalNodeWithImage:(NSString *)name atPosx:(CGFloat)x {
    
    CJScrollingNode *node = [CJScrollingNode scrollingNodeWithImageNamed:name inContainerHeight:HEIGHT(self) atPosX:x];
    node.scrollingSpeed = kCanalScrollingSpeed;
    node.anchorPoint = CGPointZero;
    node.name = name;
    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:node.size center:CGPointMake(WIDTH(node)/2, HEIGHT(node)/2)];
    node.physicsBody.categoryBitMask = obstacleCategory;
    node.physicsBody.contactTestBitMask = shipCategory;
    node.physicsBody.collisionBitMask = 0;
    
    return node;
}

- (void)createShip {
    CJShipNode *node = [CJShipNode spriteNodeWithImageNamed:@"ship"];
    node.position = CGPointMake(CGRectGetMidX(self.frame),
                                CGRectGetMidY(self.frame) - 115.0);
    
    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:node.size];
    node.physicsBody.categoryBitMask = shipCategory;
    node.physicsBody.contactTestBitMask = obstacleCategory;
    node.physicsBody.collisionBitMask = 0;
    node.physicsBody.dynamic = NO;
    
    [self addChild:node];
    _ship = node;
}

- (void)createKraken {
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"kraken"];
    node.name = @"kraken";
    node.position = CGPointMake(CGRectGetMidX(self.frame),
                                CGRectGetMidY(self.frame) - 295.0);
    node.size = CGSizeMake(150.0, 150.0);
    
    node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:WIDTH(node)/2];
    node.physicsBody.categoryBitMask = krakenCategory;
    node.physicsBody.contactTestBitMask = obstacleCategory;
    node.physicsBody.collisionBitMask = 0;
    
    [self addChild:node];
}

- (void)createBridge {

    SKNode *bridge = [SKNode node];
    bridge.name = @"bridge";

    NSInteger variance = [self randomNumberBetween:150 to:250];
    CGPoint point = CGPointMake(-variance, HEIGHT(self));
    SKSpriteNode *leftNode = [self createBridgeWithImageName:@"bridge_left" atPoint:point];
    [bridge addChild:leftNode];

    point = CGPointMake(leftNode.position.x + WIDTH(leftNode) + kHorizontalGapSize, HEIGHT(self));
    SKSpriteNode *rightNode = [self createBridgeWithImageName:@"bridge_right" atPoint:point];
    [bridge addChild:rightNode];
    
    [self addChild:bridge];
    
    SKAction *moveDown = [SKAction moveByX:0.0 y:-(HEIGHT(self) + HEIGHT(leftNode)) duration:kCanalScrollingSpeed];
    [bridge runAction:moveDown];
}

- (SKSpriteNode *)createBridgeWithImageName:(NSString *)name atPoint:(CGPoint)point {

    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:name];
    node.anchorPoint = CGPointZero;
    node.zPosition = -1.0;
    node.position = point;
    
    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:node.size center:CGPointMake(WIDTH(node)/2, HEIGHT(node)/2)];
    node.physicsBody.categoryBitMask = obstacleCategory;
    node.physicsBody.collisionBitMask = 0;
    
    return node;
}

- (void)gameOver {
    [_ship removeFromParent];
    _isGameOver = YES;
    self.paused = YES;
    [self.vc showGameOver];
}

- (int)randomNumberBetween:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}

@end
