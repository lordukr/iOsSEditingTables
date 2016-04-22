//
//  AZPeople.m
//  EditingDynamicTables
//
//  Created by My mac on 21.04.16.
//  Copyright © 2016 Anatolii Zavialov. All rights reserved.
//

#import "AZPeople.h"

@implementation AZPeople

static NSString* firstNamesArray [] = {@"Alex", @"Kate", @"Steven", @"Patrick", @"Dave", @"Mike", @"John", nil};
static NSString* lastNamesArray [] = {@"Johnson", @"Paterson", @"Davidson", @"Poulson", @"Garrison", @"Luter", @"Klein", nil};
static int namesCount = 7;

+ (AZPeople*)randomPeople {
    
    NSString* generatedName = [NSString stringWithFormat:@"%@ %@", firstNamesArray[arc4random() % namesCount], lastNamesArray[arc4random() % namesCount]];
    CGFloat grade = arc4random() % 6 + 5;
    
    AZPeople* people = [[AZPeople alloc] init];
    people.name = generatedName;
    people.grade = grade;
    
    return people;
    
}

@end
