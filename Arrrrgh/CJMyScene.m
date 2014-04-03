//
//  CJMyScene.m
//  Arrrrgh
//
//  Created by Shane Vitarana on 4/2/14.
//  Copyright (c) 2014 CrimsonJet. All rights reserved.
//

#import "CJMyScene.h"

static const uint32_t shipCategory =  0x1 << 0;
static const uint32_t rockCategory =  0x1 << 1;

@interface CJMyScene () <SKPhysicsContactDelegate> {
    
    SKNode *_ship;
    SKNode *_world;
    
    BOOL _isGameOver;
}

@end

@implementation CJMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor colorWithRed:0.16 green:0.65 blue:0.84 alpha:1.0];
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        
        _world = [SKNode node];
        [self addChild:_world];
        [self createShip];
    }
    return self;
}

-(void)update:(CFTimeInterval)currentTime {
    
    if (!_isGameOver) {
        NSInteger lowerBound = 0;
        NSInteger upperBound = 200;
        NSInteger rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
        
        if (rndValue == 3) {
            [self createRock];
        }
    }
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
        
        CGFloat angle;
        CGFloat distance = 20.0;
        if (location.x < CGRectGetMidX(self.frame)) {
            // detected left side touch
            angle = M_PI/4.0;
        }
        else {
            angle = -M_PI/4.0;
            distance = -distance;
        }
        SKAction *rotate     = [SKAction rotateByAngle:angle duration:0.5];
        SKAction *undoRotate = [SKAction rotateByAngle:-angle duration:0.5];
        SKAction *sequence   = [SKAction sequence:@[rotate, undoRotate]];
        [_ship runAction:sequence];
        
        // move the world
        SKAction *moveAcross = [SKAction moveByX:distance y:0.0 duration:0.25];
        [_world runAction:moveAcross];
    }
}

#pragma mark - Internal Methods

- (void)createShip {
    SKSpriteNode *ship = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    ship.position = CGPointMake(CGRectGetMidX(self.frame),
                                CGRectGetMidY(self.frame) - 150.0);
    ship.size = CGSizeMake(100.0, 100.0);
    
    ship.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:50.0];
    ship.physicsBody.categoryBitMask = shipCategory;
    ship.physicsBody.contactTestBitMask = rockCategory;
    ship.physicsBody.collisionBitMask = 0;
    ship.physicsBody.dynamic = NO;
    
    [self addChild:ship];
    _ship = ship;
}

- (void)createRock {
    SKSpriteNode *rock = [SKSpriteNode spriteNodeWithImageNamed:@"rock"];
    rock.name = @"rock";
    
    NSInteger lowerBound = 0;
    NSInteger upperBound = 320;
    NSInteger rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
    rock.position = CGPointMake(rndValue, 560.0);
    
    rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rock.size];
    rock.physicsBody.categoryBitMask = rockCategory;
    rock.physicsBody.contactTestBitMask = shipCategory;
    rock.physicsBody.collisionBitMask = 0;
    
    SKAction *moveDown = [SKAction moveByX:0.0 y:(-560.0 - rock.size.height) duration:3.0];
    [rock runAction:moveDown];
    
    [_world addChild:rock];
}

- (void)gameOver {
    [_ship removeFromParent];
    _isGameOver = YES;
    self.paused = YES;
    [self.vc showGameOver];
}

@end
