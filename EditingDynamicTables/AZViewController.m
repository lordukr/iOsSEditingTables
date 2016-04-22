//
//  AZViewController.m
//  EditingDynamicTables
//
//  Created by My mac on 21.04.16.
//  Copyright © 2016 Anatolii Zavialov. All rights reserved.
//

#import "AZViewController.h"
#import "AZGroup.h"
#import "AZPeople.h"

@interface AZViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSMutableArray* groupsArray;

@end

@implementation AZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.groupsArray = [[NSMutableArray alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadView {
    [super loadView];
    
    CGRect rect = self.view.bounds;
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    UIBarButtonItem* buttonEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(actionEdit:)];
    UIBarButtonItem* buttonAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAdd:)];
    
    [self.navigationItem setLeftBarButtonItem:buttonAdd animated:YES];
    [self.navigationItem setRightBarButtonItem:buttonEdit animated:YES];
}

#pragma mark - Private Methods

- (void)actionAdd:(UIBarButtonItem*) sender {
    
    [self.tableView beginUpdates];
    
    AZGroup* newGroup = [[AZGroup alloc] init];
    newGroup.groupName = [NSString stringWithFormat:@"GROUP # %d", (int)[self.groupsArray count] + 1];
    newGroup.studentsInGroup = @[[AZPeople randomPeople],[AZPeople randomPeople]];
    
    NSInteger newIndex = 0;
    
    [self.groupsArray insertObject:newGroup atIndex:newIndex];
    
    NSIndexSet* set = [NSIndexSet indexSetWithIndex:newIndex];
    
    [self.tableView insertSections:set withRowAnimation:UITableViewRowAnimationFade];
    
    [self.tableView endUpdates];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    });
}

- (void)actionEdit:(UIBarButtonItem*) sender {
    
    BOOL isUpdatingTable = self.tableView.editing;
    
    [self.tableView setEditing:!isUpdatingTable animated:YES];
    
    UIBarButtonSystemItem item;
    
    if (!isUpdatingTable) {
        item = UIBarButtonSystemItemDone;
    } else {
        item = UIBarButtonSystemItemEdit;
    }
    
    UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item target:self action:@selector(actionEdit:)];
    
    [self.navigationItem setRightBarButtonItem:buttonItem animated:YES];
    
}

- (AZPeople*)getStudent:(NSIndexPath*) index {
    AZGroup* tempGroup = [self.groupsArray objectAtIndex:index.section];
    AZPeople* currentStudent =  [tempGroup.studentsInGroup objectAtIndex:index.row - 1];
    
    return currentStudent;
}

#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak AZPeople* people = [self getStudent:indexPath];
    AZGroup* tempGroup = [self.groupsArray objectAtIndex:indexPath.section];
    
    NSMutableArray* tempArray = [NSMutableArray arrayWithArray:tempGroup.studentsInGroup];
    [tempArray removeObject:people];
    
    tempGroup.studentsInGroup = tempArray;
    
    [self.tableView beginUpdates];
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    
    [self.tableView endUpdates];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath.row > 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    AZGroup* tempGroup = [self.groupsArray objectAtIndex:section];
    
    return [tempGroup.studentsInGroup count] + 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.groupsArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    AZGroup* group = [self.groupsArray objectAtIndex:section];
    
    return group.groupName;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    AZGroup* tempGroup = [self.groupsArray objectAtIndex:section];
    NSString* footerText = [NSString stringWithFormat:@"Count:%d", (int)[tempGroup.studentsInGroup count]];
    
    return footerText;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        static NSString* addPeopleIdentifier = @"addPeopleIdentifier";
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:addPeopleIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:addPeopleIdentifier];
            cell.textLabel.text = @"Tap to add student";
            cell.textLabel.textColor = [UIColor blueColor];
        }
            return cell;
            
        } else {
    
    static NSString* studentIdentifier = @"studentIdentifier";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:studentIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:studentIdentifier];
    }
    
    AZPeople* currentPeople = [self getStudent:indexPath];
    
    cell.textLabel.text = currentPeople.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", (int)currentPeople.grade];
    
    return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row > 0;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    AZPeople* people = [self getStudent:sourceIndexPath];
    AZGroup* tempGroup = [self.groupsArray objectAtIndex:sourceIndexPath.section];
    NSMutableArray* temp = [NSMutableArray arrayWithArray:tempGroup.studentsInGroup];
       
    [temp removeObject:people];
    
    tempGroup.studentsInGroup = temp;
    
    tempGroup = [self.groupsArray objectAtIndex:destinationIndexPath.section];
    
    temp = [NSMutableArray arrayWithArray:tempGroup.studentsInGroup];
    NSIndexSet* set = [NSIndexSet indexSetWithIndex:destinationIndexPath.row - 1];
    [temp insertObjects:@[people] atIndexes:set];
    
    tempGroup.studentsInGroup = temp;

    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate



//view animations
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!tableView.editing) {
        /*
    CGRect oldCell = cell.frame;
    
    cell.frame = CGRectMake(CGRectGetMidX(cell.frame) - (CGRectGetWidth(cell.frame) / 2), CGRectGetMinY(cell.frame) - (CGRectGetHeight(cell.frame) / 2),
                            0, 0);
    
    [UIView animateWithDuration:0.3f
                          delay:0.1f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         cell.frame = CGRectMake(CGRectGetMinX(oldCell), CGRectGetMinY(oldCell),
                                                 CGRectGetWidth(oldCell), CGRectGetHeight(oldCell) / 4);
                         cell.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.1f];
                         cell.textLabel.textColor = [UIColor whiteColor];
                         
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2f animations:^{
                             cell.backgroundColor = [UIColor whiteColor];
                             if (indexPath.row == 0) {
                                 cell.textLabel.textColor = [UIColor blueColor];
                             } else {
                                 cell.textLabel.textColor = [UIColor blackColor];
                             }
                         }];
                     }];
    [UIView animateWithDuration:0.3
                     animations:^{
                         cell.frame = oldCell;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    }
    */
    
    //1. Setup the CATransform3D structure
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    
    //2. Define the initial state (Before the animation)
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    
    //3. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        AZPeople* people = [AZPeople randomPeople];
        AZGroup* tempGroup = [self.groupsArray objectAtIndex:indexPath.section];
        
        NSMutableArray* temp = nil;
        
        if (tempGroup.studentsInGroup) {
            temp = [NSMutableArray arrayWithArray:tempGroup.studentsInGroup];
        } else {
            temp = [NSMutableArray array];
        }
        NSIndexSet* set = [NSIndexSet indexSetWithIndex:indexPath.row];
        [temp insertObjects:@[people] atIndexes:set];
        
        NSInteger newPath = 0;
        
        tempGroup.studentsInGroup = temp;
        
        [self.tableView beginUpdates];
        
        NSIndexPath* newIndexPath = [NSIndexPath indexPathForItem:newPath + 1 inSection:indexPath.section];
        
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self.tableView endUpdates];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        });
    }
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    
    if (proposedDestinationIndexPath.row == 0) {
        return sourceIndexPath;
    } else {
        return proposedDestinationIndexPath;
    }
}

@end
