//
//  CJScrollingNode.h
//  Arrrrgh
//
//  Created by Shane Vitarana on 4/4/14.
//  Copyright (c) 2014 CrimsonJet. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface CJScrollingNode : SKSpriteNode

@property (nonatomic) CGFloat scrollingSpeed;

+ (id)scrollingNodeWithImageNamed:(NSString *)name inContainerWidth:(float)width;
+ (id)scrollingNodeWithImageNamed:(NSString *)name inContainerHeight:(float)height atPosX:(float)x;

- (void)update:(NSTimeInterval)currentTime;

@end
