//
//  MenuGameViewController.m
//  FinalApp
//
//  Created by CatMac on 5/4/14.
//
//

#import "MenuGameViewController.h"

@interface MenuGameViewController (){
    NSString *_appFile;
    GameMap *_map;
}

@end

@implementation MenuGameViewController

@synthesize _menuGameTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //Delegate
    _menuGameTable.delegate = self;
    _menuGameTable.dataSource = self;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self._menuGameTable=nil;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"MenuGameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIButton * button = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [button setEnabled:YES]; // disables
    [button setFrame:CGRectMake(20, 300, 100, 30)];
    
    
    // Configure the cell
    switch (indexPath.row){
        case 0:
            [button setTitle:@"Quit" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(exitGame:) forControlEvents:UIControlEventTouchUpInside];// sets text
            cell.textLabel.text = @"Quit";
            break;
        case 1:
            [button setTitle:@"See" forState:UIControlStateNormal]; // sets text
            cell.textLabel.text = @"Score";
            break;
            
    }
    cell.accessoryView = button;
    return cell;
    
}

-(IBAction)exitGame: (id) sender{
    [self performSegueWithIdentifier:@"exitGame" sender:self];
}

//Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //If pressing QUIT: Save and go to menu
    if ([[segue identifier] isEqualToString:@"exitGame"]){
        // Get reference to the destination view controller
        InitMenuController *vc = [segue destinationViewController];
        NSLog(@"Mensaje de Exit");
        
        //Save the context
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        _appFile = [documentsDirectory stringByAppendingPathComponent:@"set.txt"];
        
        //Save in file
        //NSMutableArray *myObject=[NSMutableArray array];
        NSCoder *mapEncoder;
        NSCoder *idEncoder;
        int entity;
        entity = [_map encodeWithCoder:mapEncoder];
        [idEncoder encodeObject:mapEncoder forKey:[NSString stringWithFormat:@"%d", entity]];
        
        //Pass parameters to initMenu
        vc._gameToSave = idEncoder;
        vc._entityToSave = entity;
        
        //And to parse
        [self saveMapToParse];
       
        
        
    }
    
    
}

//Save to parse
-(void) saveMapToParse{
    //Save Parse object
    PFObject *gameParameters = [PFObject objectWithClassName:@"Game"];
    gameParameters[@"entity"] = [NSString stringWithFormat:@"%d", _map._entity];
    gameParameters[@"score"] = [NSString stringWithFormat:@"%d", _map._score];
    gameParameters[@"currentLevel"] = [NSString stringWithFormat:@"%@", _map._currentLevel];
    gameParameters[@"levels"] = [NSString stringWithFormat:@"%@", _map._levels];
    gameParameters[@"importantLocations"] = [NSString stringWithFormat:@"%@", _map._importantLocations];
    gameParameters[@"playableLocations"] = [NSString stringWithFormat:@"%@", _map._playableLocations];
    gameParameters[@"finishedLocations"] = [NSString stringWithFormat:@"%@", _map._finishedLocations];
    gameParameters.objectId = [NSString stringWithFormat: @"%d",_map._entity];
    //Save the parse object
    [gameParameters saveInBackground];

     //Link it to the current user
     PFUser *user = [PFUser currentUser];
     PFRelation *relation = [user relationforKey:@"maps"];
     [relation addObject:gameParameters];
     [user saveInBackground];

}




@end
