//
//  FirstViewController.h
//  Gym Helper
//
//  Created by Chevit on 12/6/12.
//  Copyright (c) 2012 Chevit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, assign) NSInteger monthNumber;
@end
