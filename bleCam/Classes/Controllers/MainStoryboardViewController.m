//
//  MainStoryboardViewController.m
//  bleCam
//
//  Created by Alejandro Garcia Andrade on 17/07/14.
//  Copyright (c) 2014 alejandro.garcia. All rights reserved.
//

#import "MainStoryboardViewController.h"

@interface MainStoryboardViewController ()



@end

@implementation MainStoryboardViewController

@synthesize d;
@synthesize sensorsEnabled;

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
}

-(void)viewWillDisappear:(BOOL)animated {
    [self deconfigureSensorTag];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) configureSensorTag
{
    // Configure sensortag, turning on Sensors and setting update period for sensors etc ...

}

-(void) deconfigureSensorTag {
    
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
}

-(bool)sensorEnabled:(NSString *)Sensor
{
    NSString *val = [self.d.setupData valueForKey:Sensor];
    if (val)
    {
        if ([val isEqualToString:@"1"])
        {
            return TRUE;
        }
    }
    return FALSE;
}
    
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
