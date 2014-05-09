//
//  MenuGameViewController.h
//  FinalApp
//
//  Created by CatMac on 5/4/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "GameMap.h"
#import "InitMenuController.h"



@interface MenuGameViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *_menuGameTable;
@end
