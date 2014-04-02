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
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

- (void)createShip {
    SKSpriteNode *ship = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    
    ship.position = CGPointMake(CGRectGetMidX(self.frame),
                                CGRectGetMidY(self.frame) - 100.0);
    
    ship.size = CGSizeMake(50.0, 50.0);
    
    [self addChild:ship];
}

@end
