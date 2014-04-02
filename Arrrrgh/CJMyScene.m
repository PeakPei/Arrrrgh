//
//  CJMyScene.m
//  Arrrrgh
//
//  Created by Shane Vitarana on 4/2/14.
//  Copyright (c) 2014 CrimsonJet. All rights reserved.
//

#import "CJMyScene.h"

@implementation CJMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor colorWithRed:0.16 green:0.65 blue:0.84 alpha:1.0];
        [self createShip];
        [self createRock];
    }
    return self;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

#pragma mark - UIResponder

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
    }
}

#pragma mark - Internal Methods

- (void)createShip {
    SKSpriteNode *ship = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    ship.position = CGPointMake(CGRectGetMidX(self.frame),
                                CGRectGetMidY(self.frame) - 150.0);
    ship.size = CGSizeMake(100.0, 100.0);
    [self addChild:ship];
}

- (void)createRock {
    SKSpriteNode *rock = [SKSpriteNode spriteNodeWithImageNamed:@"rock"];
    
    NSInteger lowerBound = 0;
    NSInteger upperBound = 320;
    NSInteger rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
    
    rock.position = CGPointMake(rndValue, 560.0);
    
    SKAction *moveDown = [SKAction moveByX:0.0 y:-560.0 duration:3.0];
    [rock runAction:moveDown];
    
    [self addChild:rock];
}

@end
