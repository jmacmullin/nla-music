//
//  MUSIndexViewController.m
//  nla-music
//
//  Created by Jake MacMullin on 11/10/12.
//  Copyright (c) 2012 Jake MacMullin. All rights reserved.
//

#import "MUSIndexViewController.h"
#import "MUSScoreCell.h"

@interface MUSIndexViewController ()

@end

@implementation MUSIndexViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self!=nil) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setDataController:[MUSDataController sharedController]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionView Data Source Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataController numberOfScores];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MUSScoreCell *cell = (MUSScoreCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ScoreCell" forIndexPath:indexPath];
    Score *score = [self.dataController scoreAtIndex:indexPath];
    [cell setScore:score];
    return cell;
}


@end
