//
//  CJViewController.m
//  Arrrrgh
//
//  Created by Shane Vitarana on 4/2/14.
//  Copyright (c) 2014 CrimsonJet. All rights reserved.
//

#import "CJViewController.h"
#import "CJMyScene.h"

@interface CJViewController () {
    
    UIButton *_restartButton;
}

@end

@implementation CJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
#if TARGET_IPHONE_SIMULATOR
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.showsDrawCount = YES;
    skView.showsPhysics = YES;
#endif
    
    // Create and configure the scene.
    CJMyScene *scene = [CJMyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.vc = self;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)showGameOver {
    [self restartButton];
}

- (void)handleRestart:(id)sender {
    
    [self viewDidLoad];
    [_restartButton removeFromSuperview];
}

- (void)restartButton {
    _restartButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _restartButton.frame = CGRectMake(0.0,
                                      CGRectGetMidY(self.view.frame),
                                      320, 100);
    [_restartButton setTitle:@"Restart" forState:UIControlStateNormal];
    [_restartButton setTintColor:[UIColor whiteColor]];
    _restartButton.titleLabel.font = [UIFont systemFontOfSize:25.0];
    
    [_restartButton addTarget:self action:@selector(handleRestart:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_restartButton];
}

@end
