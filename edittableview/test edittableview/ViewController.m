//
//  ViewController.m
//  test edittableview
//
//  Created by NetEase on 16/4/28.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import "ViewController.h"

#define tableViewTag  200
#define leftTableViewTag  201

@interface ViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) NSMutableArray *theLeftData;
@property (strong,nonatomic) UITableView *lefttableView;
@property (strong,nonatomic) UIView *cellLeftSnapshotView;
@property (strong,nonatomic) NSIndexPath *draggingLeftCellIndexPath;
@property (strong,nonatomic)  UIPanGestureRecognizer *leftpanner;

@property (strong,nonatomic) NSMutableArray *theData;
@property (strong,nonatomic)  UIPanGestureRecognizer *panner;
@property (strong,nonatomic) UIView *cellSnapshotView;
@property (strong,nonatomic) NSIndexPath *draggingCellIndexPath;
@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) UILongPressGestureRecognizer *pressGesture;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2, 0, self.view.bounds.size.width/2, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.tag = tableViewTag;
    [self.view addSubview:self.tableView];
    
    self.lefttableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width/2, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.lefttableView.delegate = self;
    self.lefttableView.dataSource = self;
    [self.lefttableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"LeftCell"];
    self.lefttableView.tag = leftTableViewTag;
    [self.view addSubview:self.lefttableView];
    
    self.panner = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveCellImage:)];
    [self.view addGestureRecognizer:self.panner];
    self.panner.enabled = YES;
    self.panner.delegate = self;
    self.panner.cancelsTouchesInView = YES;
    
    self.leftpanner = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveCellImage:)];
    [self.lefttableView addGestureRecognizer:self.leftpanner];
    self.leftpanner.enabled = YES;
    self.leftpanner.delegate = self;
    self.leftpanner.cancelsTouchesInView = NO;
    self.leftpanner.delaysTouchesEnded = YES;
    
//    self.pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
//    [self.view addGestureRecognizer:self.pressGesture];
//    self.pressGesture.enabled = YES;
//    self.pressGesture.delegate = self;
//    self.pressGesture.cancelsTouchesInView = YES;
    
    self.draggingCellIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
    self.draggingLeftCellIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
    self.theData = [@[@"One",@"Two",@"Three",@"Four",@"Five",@"Six",@"Seven",@"Eight",@"Nine",@"Black",@"Brown",@"Red",@"Orange",@"Yellow",@"Green",@"Blue",@"Violet",@"Gray",@"White"] mutableCopy];
    self.theLeftData = [@[@"GroupOne",@"GroupTwo",@"GroupThree",@"GroupFour",@"GroupFive",@"GroupSix"] mutableCopy];
}

-(IBAction)toggleDragging:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:@"Drag"]) {
        self.panner.enabled = YES;
        sender.title = @"Scroll";
    }else{
        self.panner.enabled = NO;
        sender.title = @"Drag";
        self.tableView.scrollEnabled = YES;
    }
}



-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    return NO;
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    return YES;
//}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    self.lefttableView.scrollEnabled = YES;
//    self.leftpanner.enabled = NO;
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    self.lefttableView.scrollEnabled = NO;
//    self.leftpanner.enabled = YES;
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}

//-(IBAction)moveleftCellImage:(UIPanGestureRecognizer *)panner {
//    
//        CGPoint loc = [panner locationInView:self.lefttableView];
//        if(loc.x < 0)
//        {
//            return;
//        }
//        if (! self.cellLeftSnapshotView) {
//            
//            self.draggingLeftCellIndexPath = [self.lefttableView indexPathForRowAtPoint:loc];
//            UITableViewCell *cell = [self.lefttableView cellForRowAtIndexPath:self.draggingLeftCellIndexPath];
//            self.cellLeftSnapshotView = [cell snapshotViewAfterScreenUpdates:YES];
//            self.cellLeftSnapshotView.alpha = 0.8;
//            self.cellLeftSnapshotView.layer.borderColor = [UIColor redColor].CGColor;
//            self.cellLeftSnapshotView.layer.borderWidth = 1;
//            self.cellLeftSnapshotView.frame =  cell.frame;
//            [self.lefttableView addSubview:self.cellLeftSnapshotView];
//            self.lefttableView.scrollEnabled = NO;
//            [self.lefttableView reloadRowsAtIndexPaths:@[self.draggingLeftCellIndexPath] withRowAnimation:UITableViewRowAnimationNone]; // replace the cell with a blank one until the drag is over
//        }
//        
//        CGPoint lefttranslation = [panner translationInView:self.view];
//        CGPoint leftcvCenter = self.cellLeftSnapshotView.center;
//        leftcvCenter.x += lefttranslation.x;
//        leftcvCenter.y += lefttranslation.y;
//        self.cellLeftSnapshotView.center = leftcvCenter;
//        [panner setTranslation:CGPointZero inView:self.view];
//        
//        
//        
//        if (panner.state == UIGestureRecognizerStateEnded) {
//            UITableViewCell *droppedOnCell;
//            CGRect largestRect = CGRectZero;
//            for (UITableViewCell *cell in self.lefttableView.visibleCells) {
//                CGRect intersection = CGRectIntersection(cell.frame, self.cellLeftSnapshotView.frame);
//                if (intersection.size.width * intersection.size.height >= largestRect.size.width * largestRect.size.height) {
//                    largestRect = intersection;
//                    droppedOnCell =  cell;
//                }
//            }
//            NSIndexPath *droppedOnCellIndexPath = [self.lefttableView indexPathForCell:droppedOnCell];
//            [UIView animateWithDuration:.2 animations:^{
//                self.cellLeftSnapshotView.center = droppedOnCell.center;
//            } completion:^(BOOL finished) {
//                [self.cellLeftSnapshotView removeFromSuperview];
//                self.cellLeftSnapshotView = nil;
//                NSIndexPath *savedDraggingCellIndexPath = self.draggingLeftCellIndexPath;
//                if (![self.draggingLeftCellIndexPath isEqual:droppedOnCellIndexPath]) {
//                    self.draggingLeftCellIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
//                    [self.theLeftData exchangeObjectAtIndex:savedDraggingCellIndexPath.row withObjectAtIndex:droppedOnCellIndexPath.row];
//                    [self.lefttableView reloadRowsAtIndexPaths:@[savedDraggingCellIndexPath, droppedOnCellIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//                }else{
//                    self.draggingLeftCellIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
//                    [self.lefttableView reloadRowsAtIndexPaths:@[savedDraggingCellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
//                }
//            }];
//        }
//}


-(IBAction)moveCellImage:(UIPanGestureRecognizer *)panner {
    
//    self.pressGesture.enabled = NO;
    
        CGPoint loc = [panner locationInView:self.tableView];
        if(loc.x < 0 && panner == self.leftpanner)
        {
            self.panner.enabled = NO;
            CGPoint loc = [panner locationInView:self.lefttableView];
            if(loc.x < 0)
            {
                return;
            }
            if (! self.cellLeftSnapshotView) {
                
                self.draggingLeftCellIndexPath = [self.lefttableView indexPathForRowAtPoint:loc];
                UITableViewCell *cell = [self.lefttableView cellForRowAtIndexPath:self.draggingLeftCellIndexPath];
                self.cellLeftSnapshotView = [cell snapshotViewAfterScreenUpdates:YES];
                self.cellLeftSnapshotView.alpha = 0.8;
                self.cellLeftSnapshotView.layer.borderColor = [UIColor redColor].CGColor;
                self.cellLeftSnapshotView.layer.borderWidth = 1;
                self.cellLeftSnapshotView.frame =  cell.frame;
                [self.lefttableView addSubview:self.cellLeftSnapshotView];
                self.lefttableView.scrollEnabled = NO;
                if(self.draggingLeftCellIndexPath)
                    [self.lefttableView reloadRowsAtIndexPaths:@[self.draggingLeftCellIndexPath] withRowAnimation:UITableViewRowAnimationNone]; // replace the cell with a blank one until the drag is over
            }
            
            CGPoint lefttranslation = [panner translationInView:self.view];
            CGPoint leftcvCenter = self.cellLeftSnapshotView.center;
            leftcvCenter.x += lefttranslation.x;
            leftcvCenter.y += lefttranslation.y;
            self.cellLeftSnapshotView.center = leftcvCenter;
            [panner setTranslation:CGPointZero inView:self.view];
            
            
            
            if (panner.state == UIGestureRecognizerStateEnded) {
                UITableViewCell *droppedOnCell;
                CGRect largestRect = CGRectZero;
                for (UITableViewCell *cell in self.lefttableView.visibleCells) {
                    CGRect intersection = CGRectIntersection(cell.frame, self.cellLeftSnapshotView.frame);
                    if (intersection.size.width * intersection.size.height >= largestRect.size.width * largestRect.size.height) {
                        largestRect = intersection;
                        droppedOnCell =  cell;
                    }
                }
                NSIndexPath *droppedOnCellIndexPath = [self.lefttableView indexPathForCell:droppedOnCell];
                [UIView animateWithDuration:.2 animations:^{
                    self.cellLeftSnapshotView.center = droppedOnCell.center;
                } completion:^(BOOL finished) {
                    [self.cellLeftSnapshotView removeFromSuperview];
                    self.cellLeftSnapshotView = nil;
                    NSIndexPath *savedDraggingCellIndexPath = self.draggingLeftCellIndexPath;
                    if (![self.draggingLeftCellIndexPath isEqual:droppedOnCellIndexPath]) {
                        self.draggingLeftCellIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
                        if(savedDraggingCellIndexPath.row < [self.theLeftData count] && droppedOnCellIndexPath.row < [self.theLeftData count])
                        {
                            [self.theLeftData exchangeObjectAtIndex:savedDraggingCellIndexPath.row withObjectAtIndex:droppedOnCellIndexPath.row];
                            [self.lefttableView reloadRowsAtIndexPaths:@[savedDraggingCellIndexPath, droppedOnCellIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                        }
                    }else{
                        self.draggingLeftCellIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
                        [self.lefttableView reloadRowsAtIndexPaths:@[savedDraggingCellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }
                }];
//                self.panner.enabled = NO;
//                self.leftpanner.enabled = NO;
//                self.pressGesture.enabled = YES;
//                self.tableView.scrollEnabled = YES;
//                self.lefttableView.scrollEnabled = YES;
            }
            return;
        }
        else if(loc.x > 0 && panner == self.panner)
        {
            self.leftpanner.enabled = NO;
            if (! self.cellSnapshotView) {
                self.draggingCellIndexPath = [self.tableView indexPathForRowAtPoint:loc];
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.draggingCellIndexPath];
                self.cellSnapshotView = [cell snapshotViewAfterScreenUpdates:YES];
                self.cellSnapshotView.alpha = 0.8;
                self.cellSnapshotView.layer.borderColor = [UIColor redColor].CGColor;
                self.cellSnapshotView.layer.borderWidth = 1;
                self.cellSnapshotView.frame =  CGRectMake(self.lefttableView.frame.size.width/2, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);//cell.frame;
                [self.view addSubview:self.cellSnapshotView];
                self.tableView.scrollEnabled = NO;
                [self.tableView reloadRowsAtIndexPaths:@[self.draggingCellIndexPath] withRowAnimation:UITableViewRowAnimationNone]; // replace the cell with a blank one until the drag is over
            }
            
            CGPoint translation = [panner translationInView:self.view];
            CGPoint cvCenter = self.cellSnapshotView.center;
            cvCenter.x += translation.x;
            cvCenter.y += translation.y;
            self.cellSnapshotView.center = cvCenter;
            [panner setTranslation:CGPointZero inView:self.view];
            
            
            
            if (panner.state == UIGestureRecognizerStateEnded) {
                UITableViewCell *droppedOnCell;
                CGRect largestRect = CGRectZero;
                for (UITableViewCell *cell in self.tableView.visibleCells) {
                    CGRect intersection = CGRectIntersection(cell.frame, self.cellSnapshotView.frame);
                    if (intersection.size.width * intersection.size.height >= largestRect.size.width * largestRect.size.height) {
                        largestRect = intersection;
                        droppedOnCell =  cell;
                    }
                }
                NSIndexPath *droppedOnCellIndexPath = [self.tableView indexPathForCell:droppedOnCell];
                [UIView animateWithDuration:.2 animations:^{
                    self.cellSnapshotView.center = droppedOnCell.center;
                } completion:^(BOOL finished) {
                    [self.cellSnapshotView removeFromSuperview];
                    self.cellSnapshotView = nil;
                    NSIndexPath *savedDraggingCellIndexPath = self.draggingCellIndexPath;
                    if (![self.draggingCellIndexPath isEqual:droppedOnCellIndexPath]) {
                        self.draggingCellIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
                        [self.theData exchangeObjectAtIndex:savedDraggingCellIndexPath.row withObjectAtIndex:droppedOnCellIndexPath.row];
                        [self.tableView reloadRowsAtIndexPaths:@[savedDraggingCellIndexPath, droppedOnCellIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                    }else{
                        self.draggingCellIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
                        [self.tableView reloadRowsAtIndexPaths:@[savedDraggingCellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }
                }];
                self.leftpanner.enabled = NO;
                self.panner.enabled = NO;
//                self.pressGesture.enabled = YES;
                self.tableView.scrollEnabled = YES;
                self.lefttableView.scrollEnabled = YES;
            }
        }
}

//- (void)longPress:(UILongPressGestureRecognizer *)aGesture
//{
//    self.tableView.scrollEnabled = NO;
//    self.lefttableView.scrollEnabled = NO;
//    self.panner.enabled = YES;
//    self.leftpanner.enabled = YES;
//    aGesture.enabled = NO;
//}

- (void)cellpressed:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        CGPoint p = [gesture locationInView:self.lefttableView];
        
        NSIndexPath *indexPath = [self.lefttableView indexPathForRowAtPoint:p];
        if (indexPath == nil) {
            NSLog(@"long press on table view but not on a row");
        } else {
            UITableViewCell *cell = [self.lefttableView cellForRowAtIndexPath:indexPath];
            if (cell.isHighlighted) {
                NSLog(@"long press on table view at section %d row %d", indexPath.section, indexPath.row);
                
                self.lefttableView.scrollEnabled = NO;
                self.leftpanner.enabled = YES;
                gesture.enabled = NO;
                
            }
        }
    }
    
//    CGPoint p = [gesture locationInView:self.lefttableView];
//    
//    NSIndexPath *indexPath = [self.lefttableView indexPathForRowAtPoint:p];
//    if (indexPath == nil) {
//        NSLog(@"long press on table view but not on a row");
//    } else if (gesture.state == UIGestureRecognizerStateBegan) {
//        NSLog(@"long press on table view at row %ld", indexPath.row);
//        
//        self.lefttableView.scrollEnabled = NO;
//        self.leftpanner.enabled = YES;
//        gesture.enabled = NO;
//    } else {
//        NSLog(@"gestureRecognizer.state = %ld", gesture.state);
//        
//        self.lefttableView.scrollEnabled = NO;
//        self.leftpanner.enabled = YES;
//    }
    
//    [NSObject cancelPreviousPerformRequestsWithTarget:gesture];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView.tag == tableViewTag)
    {
        return self.theData.count;
    }
    else if(tableView.tag == leftTableViewTag)
    {
        return self.theLeftData.count;
    }
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.tag == tableViewTag)
    {
        if ([self.draggingCellIndexPath isEqual:indexPath]) {
            UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            return cell;
        }
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.textLabel.text = self.theData[indexPath.row];
        return cell;
    }
    else if(tableView.tag == leftTableViewTag)
    {
//        UILongPressGestureRecognizer *ges =[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellpressed:)];
//        ges.delegate = self;
//        ges.cancelsTouchesInView = NO;
        if ([self.draggingLeftCellIndexPath isEqual:indexPath]) {
            UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"LeftCell" forIndexPath:indexPath];
//            [cell addGestureRecognizer:ges];
            return cell;
        }
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftCell" forIndexPath:indexPath];
        cell.textLabel.text = self.theLeftData[indexPath.row];
//        [cell addGestureRecognizer:ges];
        return cell;
    }
    return [[UITableViewCell alloc] initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
//    if(tableView.tag == tableViewTag)
//    {
//        self.tableView.scrollEnabled = NO;
//        self.panner.enabled = YES;
//    }
//    else if(tableView.tag == leftTableViewTag)
//    {
//        self.tableView.scrollEnabled = NO;
//        self.leftpanner.enabled = YES;
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
