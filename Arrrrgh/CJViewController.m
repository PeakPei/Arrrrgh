//
//  CJViewController.m
//  Arrrrgh
//
//  Created by Shane Vitarana on 4/2/14.
//  Copyright (c) 2014 CrimsonJet. All rights reserved.
//

#import "CJViewController.h"
#import "CJMyScene.h"
#import "ARAudioRecognizer.h"

@interface CJViewController () <ARAudioRecognizerDelegate> {
    
    UIButton *_restartButton;
    ARAudioRecognizer *_audioRecognizer;
    CJMyScene *_scene;
}

@end

@implementation CJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _audioRecognizer = [[ARAudioRecognizer alloc] init];
    _audioRecognizer.delegate = self;

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
#if TARGET_IPHONE_SIMULATOR
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.showsDrawCount = YES;
    skView.showsPhysics = YES;
#endif
    
    // Create and configure the scene.
    _scene = [CJMyScene sceneWithSize:skView.bounds.size];
    _scene.scaleMode = SKSceneScaleModeAspectFill;
    _scene.vc = self;
    
    // Present the scene.
    [skView presentScene:_scene];
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

#pragma mark - ARAudioRecognizerDelegate

- (void)audioRecognized:(ARAudioRecognizer *)recognizer {
    NSLog(@"lowpass %f", recognizer.lowPassResults);
    _scene.blowLevel = recognizer.lowPassResults;
}

#pragma mark - Internal Methods

- (void)handleRestart:(id)sender {
    
    [_restartButton removeFromSuperview];
//    _audioRecognizer = nil;
    
    [self viewDidLoad];
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
