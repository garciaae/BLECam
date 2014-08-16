//
//  MainStoryboardViewController.h
//  bleCam
//
//  Created by Alejandro Garcia Andrade on 17/07/14.
//  Copyright (c) 2014 alejandro.garcia. All rights reserved.
//
#include <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIKit.h>
#import "BLEDevice.h"
#include "BLEUtility.h"
#include "Sensors.h"



@interface MainStoryboardViewController : UIViewController

@property (strong,nonatomic) BLEDevice *d;
@property NSMutableArray *sensorsEnabled;


-(void) configureSensorTag;
-(void) deconfigureSensorTag;

@end
