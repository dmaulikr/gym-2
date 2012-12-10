//
//  FirstViewController.m
//  Gym Helper
//
//  Created by Chevit on 12/6/12.
//  Copyright (c) 2012 Chevit. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarCell.h"

@interface CalendarViewController ()
{
	NSInteger _monthNumber;

	NSInteger _firstDayNumber;
	NSInteger _lastDayNumber;
	NSInteger _daysInMonth;
	NSInteger _lastDayOfPreviousMonth;
	__weak IBOutlet UICollectionView *_calendarView;
}
- (IBAction)previousMonthButtonClick:(id)sender;
- (IBAction)nextMonthButtonClick:(id)sender;
@end

@implementation CalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSDateComponents* components = [[NSCalendar currentCalendar] components:(NSMonthCalendarUnit) fromDate:[NSDate date]];
	_monthNumber = [components month];
	
	[self validateMonth];
	
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setMonthNumber:(NSInteger)monthNumber
{
	if (monthNumber != _monthNumber)
	{
		_monthNumber = monthNumber;
		[self validateMonth];
		[_calendarView reloadData];
	}
}

- (void)validateMonth
{
	NSCalendar* calendar = [NSCalendar currentCalendar];
	NSDateComponents* components = [calendar components:(NSYearCalendarUnit) fromDate:[NSDate date]];
	[components setDay:1];
	[components setCalendar:[NSCalendar currentCalendar]];
	[components setMonth:_monthNumber];
	NSDate* date = [calendar dateFromComponents:components];
	
	components = [calendar components:NSWeekdayCalendarUnit fromDate:date];
	
	_firstDayNumber = [components weekday];
	
	NSDateComponents* monthComponents = [[NSDateComponents alloc] init];
	monthComponents.day = -1;
	monthComponents.month = 1;
	NSDate* lastDay = [calendar dateByAddingComponents:monthComponents toDate:date options:0];
	NSDateComponents* lastDayComponents = [calendar components:NSWeekdayCalendarUnit | NSDayCalendarUnit
													  fromDate:lastDay];
	
	_lastDayNumber = lastDayComponents.weekday;
	_daysInMonth = lastDayComponents.day;
	
	NSDateComponents* aComponents = [calendar components:(NSYearCalendarUnit) fromDate:[NSDate date]];
	aComponents.day = _daysInMonth;
	aComponents.month = _monthNumber;
	NSDate* nextDate = [calendar dateFromComponents:aComponents];
	NSDateComponents* nextMonthComponents = [[NSDateComponents alloc] init];
	monthComponents.month = -1;
	nextDate = [calendar dateByAddingComponents:nextMonthComponents toDate:nextDate options:0];
	nextMonthComponents = [calendar components:(NSDayCalendarUnit) fromDate:nextDate];
	_lastDayOfPreviousMonth = [nextMonthComponents day];
	
}

- (NSInteger)getNumberOfItemsInSection
{
	NSInteger result = 0;
	NSCalendar* calendar = [NSCalendar currentCalendar];
	
	NSRange maxDaysOfWeek = [calendar maximumRangeOfUnit:NSWeekdayCalendarUnit];
	
	result = _daysInMonth + (maxDaysOfWeek.length - (maxDaysOfWeek.length + 1 -_firstDayNumber)) + (maxDaysOfWeek.length - _lastDayNumber);
	
	return result;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [self getNumberOfItemsInSection];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	CalendarCell* cell = (CalendarCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"CalendarCell" forIndexPath:indexPath];
	if (!cell)
	{
		cell = [[CalendarCell alloc] init];
	}

	if (indexPath.item +1 < _firstDayNumber)
	{
		cell.backgroundColor = [UIColor grayColor];
		
		cell.dayNumberCell.text = [NSString stringWithFormat:@"%d", _lastDayOfPreviousMonth - (_firstDayNumber - (indexPath.item + 1) - 1)];
	}
	else if (indexPath.item + 1 > (_firstDayNumber + _daysInMonth - 1))
	{
		cell.backgroundColor = [UIColor grayColor];
		
		cell.dayNumberCell.text = [NSString stringWithFormat:@"%d", (indexPath.item + 1) - _daysInMonth - _firstDayNumber + 1];
	}
	else
	{
		cell.backgroundColor = [UIColor whiteColor];
		cell.dayNumberCell.text = [NSString stringWithFormat:@"%d", (indexPath.item + 1) - _firstDayNumber + 1];
	}
	
	
	
	
	
	return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (void)viewDidUnload {
	_calendarView = nil;
	[super viewDidUnload];
}
- (IBAction)previousMonthButtonClick:(id)sender
{
	self.monthNumber = _monthNumber - 1;
}

- (IBAction)nextMonthButtonClick:(id)sender
{
	self.monthNumber = _monthNumber + 1;
}
@end
