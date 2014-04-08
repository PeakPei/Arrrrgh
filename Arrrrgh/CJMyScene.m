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

static const uint32_t shipCategory =  0x1 << 0;
static const uint32_t rockCategory =  0x1 << 1;

#define WIDTH(view) view.frame.size.width
#define HEIGHT(view) view.frame.size.height
#define X(view) view.frame.origin.x
#define Y(view) view.frame.origin.y

#define kCanalScrollingSpeed   3
#define kHorizontalGapSize     100

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
    }
    return self;
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    _lastSpawnTimeInterval += timeSinceLast;
    if (_lastSpawnTimeInterval > 1) {
        _lastSpawnTimeInterval = 0;
        [self createBridge];
    }
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
    if (contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask) {
        [self gameOver];
    }
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

- (void)createWorld {
    _world = [SKNode node];
    _world.speed = 0.0;
    [self addChild:_world];
}

- (void)createCanal {
    CJScrollingNode *node = [CJScrollingNode scrollingNodeWithImageNamed:@"canal" inContainerHeight:self.frame.size.height atPosX:0.0];
    node.scrollingSpeed = kCanalScrollingSpeed;
    node.anchorPoint = CGPointZero;
    node.name = @"canalLeft";
//    node.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:node.frame];
    [self addChild:node];
    _canalLeft = node;
    
    CJScrollingNode *node2 = [CJScrollingNode scrollingNodeWithImageNamed:@"canal_right" inContainerHeight:self.frame.size.height atPosX:298.0];
    node2.scrollingSpeed = kCanalScrollingSpeed;
    node2.anchorPoint = CGPointZero;
    node2.name = @"canalRight";
    [self addChild:node2];
    _canalRight = node2;
}

- (void)createShip {
    CJShipNode *node = [CJShipNode spriteNodeWithImageNamed:@"ship"];
    node.position = CGPointMake(CGRectGetMidX(self.frame),
                                CGRectGetMidY(self.frame) - 115.0);
//    ship.size = CGSizeMake(100.0, 100.0);
    
    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:node.size];
    node.physicsBody.categoryBitMask = shipCategory;
    node.physicsBody.contactTestBitMask = rockCategory;
    node.physicsBody.collisionBitMask = 0;
    node.physicsBody.dynamic = NO;
    
    [self addChild:node];
    _ship = node;
}

- (void)createBridge {

    SKNode *bridge = [SKNode node];
    bridge.name = @"bridge";
    
    SKSpriteNode *leftNode = [SKSpriteNode spriteNodeWithImageNamed:@"bridge_left"];
    leftNode.anchorPoint = CGPointZero;
    
    NSInteger variance = [self randomNumberBetween:150 to:250];
    leftNode.position = CGPointMake(-variance, 568);
    leftNode.zPosition = -1.0;
    [bridge addChild:leftNode];

    SKSpriteNode *rightNode = [SKSpriteNode spriteNodeWithImageNamed:@"bridge_right"];
    rightNode.anchorPoint = CGPointZero;
    rightNode.position = CGPointMake(leftNode.position.x + WIDTH(leftNode) + kHorizontalGapSize, 568);
    rightNode.zPosition = -1.0;
    [bridge addChild:rightNode];
    
    [self addChild:bridge];
    
    SKAction *moveDown = [SKAction moveByX:0.0 y:-(568.0 + HEIGHT(leftNode)) duration:kCanalScrollingSpeed];
    [bridge runAction:moveDown];
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
