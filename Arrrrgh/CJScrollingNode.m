//
//  CJScrollingNode.m
//  Arrrrgh
//
//  Created by Shane Vitarana on 4/4/14.
//  Copyright (c) 2014 CrimsonJet. All rights reserved.
//

#import "CJScrollingNode.h"

@implementation CJScrollingNode

+ (id)scrollingNodeWithImageNamed:(NSString *)name inContainerWidth:(float)width
{
    UIImage * image = [UIImage imageNamed:name];
    
    CJScrollingNode *realNode = [CJScrollingNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(width, image.size.height)];
    realNode.scrollingSpeed = 1;
    
    float total = 0;
    while(total<(width + image.size.width)){
        SKSpriteNode * child = [SKSpriteNode spriteNodeWithImageNamed:name ];
        [child setAnchorPoint:CGPointZero];
        [child setPosition:CGPointMake(total, 0)];
        [realNode addChild:child];
        total+=child.size.width;
    }
    
    return realNode;
}

+ (id)scrollingNodeWithImageNamed:(NSString *)name inContainerHeight:(float)height atPosX:(float)x
{
    UIImage * image = [UIImage imageNamed:name];
    
    CJScrollingNode *realNode = [CJScrollingNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(image.size.width, height)];
    realNode.scrollingSpeed = 1;
    
    float total = 0;
    while(total<(height + image.size.height)){
        SKSpriteNode * child = [SKSpriteNode spriteNodeWithImageNamed:name];
        [child setAnchorPoint:CGPointZero];
        [child setPosition:CGPointMake(x, total)];
        [realNode addChild:child];
        total+=child.size.height;
    }
    
    return realNode;
}


//- (void)update:(NSTimeInterval)currentTime
//{
//    [self.children enumerateObjectsUsingBlock:^(SKSpriteNode * child, NSUInteger idx, BOOL *stop) {
//        child.position = CGPointMake(child.position.x-self.scrollingSpeed, child.position.y);
//        if (child.position.x <= -child.size.width){
//            float delta = child.position.x+child.size.width;
//            child.position = CGPointMake(child.size.width*(self.children.count-1)+delta, child.position.y);
//        }
//    }];
//}

- (void)update:(NSTimeInterval)currentTime
{
    [self.children enumerateObjectsUsingBlock:^(SKSpriteNode * child, NSUInteger idx, BOOL *stop) {
        child.position = CGPointMake(child.position.x, child.position.y-self.scrollingSpeed);
        if (child.position.y <= -child.size.height){
            float delta = child.position.y + child.size.height;
            child.position = CGPointMake(child.position.x, child.size.height * (self.children.count-1)+delta);
        }
    }];
}

@end
