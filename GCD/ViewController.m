//
//  ViewController.m
//  GCD
//
//  Created by Vikas Kumar Jangir on 01/04/19.
//  Copyright © 2019 inmobi. All rights reserved.
//

#import "ViewController.h"
#import "GDCSerialQueue.h"
#import "GCDTableViewCell.h"
#import "GCDOperationQueue.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong , nonatomic) NSMutableArray *tableData;
@property  (strong,nonatomic) GCDOperationQueue *operation;
@end

@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.operation = [[GCDOperationQueue alloc] init];
    [self.operation operationQueueExecute];
    GDCSerialQueue *serial = [[GDCSerialQueue alloc]init];
    [serial ExecuteCode];
    self.tableData = [NSMutableArray arrayWithObjects:@"1", @"1", @"1", @"1", @"1", @"1", @"1", @"1", @"1", @"1", @"1", @"1", @"1", @"1", @"1", nil];
    
    
    dispatch_queue_attr_t qosAttribute = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT, QOS_CLASS_USER_INTERACTIVE, 0);
    dispatch_queue_t myQueue = dispatch_queue_create("com.YourApp.YourQueue", qosAttribute);
    // Do any additional setup after loading the view.
//    dispatch_async(myQueue, ^{
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            @try {
//                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 30, 70)];
//                label.text = @"label text";
//                label.backgroundColor = UIColor.blueColor;
//                [self.view addSubview:label];
//            } @catch (NSException *exception) {
//                NSLog(@"asdf");
//            }
//
//        });
//
//    });
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
 //   __block GCDTableViewCell *cell;
//    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//
//        if (cell == nil) {
//            cell = [[GCDTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
//        }
//        UIImage *image = [UIImage imageNamed:@"duckduck"];
//        [cell.imageViewCell setImage:image];
//    });
    
    
    GCDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil) {
        cell = [[GCDTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    UIImage *image = [UIImage imageNamed:@"duckduck"];
    [cell.imageViewCell setImage:image];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}




@end
