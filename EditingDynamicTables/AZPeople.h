//
//  AZPeople.h
//  EditingDynamicTables
//
//  Created by My mac on 21.04.16.
//  Copyright © 2016 Anatolii Zavialov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AZPeople : NSObject

@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) CGFloat grade;

+ (AZPeople*) randomPeople;

@end
