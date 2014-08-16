//
//  deviceSelectorViewController.h
//  bleCam
//
//  Created by Alejandro Garcia Andrade on 03/08/14.
//  Copyright (c) 2014 alejandro.garcia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLEDevice.h"
#import "BLEUtility.h"
#import "MainStoryBoardViewController.h"


@interface deviceSelectorViewController : UIViewController<CBCentralManagerDelegate,CBPeripheralDelegate, UITableViewDelegate, UITableViewDataSource>

// Says if it's connected
@property (nonatomic, strong) NSString *connected;

// To manage messages
@property (strong,nonatomic) CBCentralManager *cbCentralManager;
@property (nonatomic, strong) CBPeripheral *sensorTagPeripheral;

// An array to store devices
@property (strong,nonatomic) NSMutableArray *nDevices;

// An array to store different sensor tags
@property (strong,nonatomic) NSMutableArray *sensorTags;

// A method to configure the sensor tag
-(NSMutableDictionary *) makeSensorTagConfiguration;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

//@property (strong,nonatomic) BLEDevice *d;
@property NSMutableArray *sensorsEnabled;

-(void) configureSensorTag;
-(void) deconfigureSensorTag;

@end
