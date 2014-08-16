//
//  deviceSelectorViewController.m
//  bleCam
//
//  Created by Alejandro Garcia Andrade on 03/08/14.
//  Copyright (c) 2014 alejandro.garcia. All rights reserved.
//

#import "deviceSelectorViewController.h"

@interface deviceSelectorViewController ()

@end

@implementation deviceSelectorViewController
@synthesize cbCentralManager;
@synthesize sensorTagPeripheral;
@synthesize nDevices;
@synthesize sensorTags;
//@synthesize d;
@synthesize sensorsEnabled;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    if (self) {
        // Scan for all available CoreBluetooth LE devices
        cbCentralManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
        [cbCentralManager scanForPeripheralsWithServices:nil options:nil];
        
        self.nDevices = [[NSMutableArray alloc]init];
        self.sensorTags = [[NSMutableArray alloc]init];
        
        self.sensorsEnabled = [[NSMutableArray alloc] init];
        
        self.title = @"BLECam";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return (NSInteger)sensorTags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[NSString stringWithFormat:@"%ld_Cell",(long)indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.sensorTags.count > 1 ){
            return [NSString stringWithFormat:@"%lu SensorTags Found",(unsigned long)self.sensorTags.count];
        }
        else {
            return [NSString stringWithFormat:@"%lu SensorTag Found",(unsigned long)self.sensorTags.count];
        }
    }
    
    return @"";
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

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //CBPeripheral *p = [self.sensorTags objectAtIndex:(NSUInteger)indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SensorTag configuration

-(NSMutableDictionary *) makeSensorTagConfiguration {
    NSMutableDictionary *sensorsDictionary = [[NSMutableDictionary alloc] init];
    // First we set ambient temperature
    [sensorsDictionary setValue:@"1" forKey:@"Ambient temperature active"];
    // Then we set IR temperature
    [sensorsDictionary setValue:@"1" forKey:@"IR temperature active"];
    // Append the UUID to make it easy for app
    [sensorsDictionary setValue:@"f000aa00-0451-4000-b000-000000000000"  forKey:@"IR temperature service UUID"];
    [sensorsDictionary setValue:@"f000aa01-0451-4000-b000-000000000000"  forKey:@"IR temperature data UUID"];
    [sensorsDictionary setValue:@"f000aa02-0451-4000-b000-000000000000"  forKey:@"IR temperature config UUID"];
    
    NSLog(@"%@",sensorsDictionary);
    
    return sensorsDictionary;
}

#pragma mark - CBCentralManager delegate

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    self.connected = [NSString stringWithFormat:@"Connected: %@", peripheral.state == CBPeripheralStateConnected ? @"YES" : @"NO"];
    NSLog(@"%@", self.connected);
}


-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSString *localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    
    if ([localName length] > 0) {
        NSLog(@"Found a BLE Device : %@ %@",peripheral, localName);
        [self.cbCentralManager stopScan];
        
        self.sensorTagPeripheral = peripheral;
        peripheral.delegate = self;
        [central connectPeripheral:peripheral options:nil];
    
        [self.nDevices addObject:peripheral];
    }
}


-(void)centralManagerDidUpdateState:(CBCentralManager *)central {
    // Determine the state of the peripheral
    if ([central state] == CBCentralManagerStatePoweredOff) {
        NSLog(@"CoreBluetooth BLE hardware is powered off");
    }
    else if ([central state] == CBCentralManagerStatePoweredOn) {
        NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
        [central scanForPeripheralsWithServices:nil options:nil];
    }
    else if ([central state] == CBCentralManagerStateUnauthorized) {
        NSLog(@"CoreBluetooth BLE state is unauthorized");
    }
    else if ([central state] == CBCentralManagerStateUnknown) {
        NSLog(@"CoreBluetooth BLE state is unknown");
    }
    else if ([central state] == CBCentralManagerStateUnsupported) {
        NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
    }
}


#pragma  mark - CBPeripheral delegate

-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    for (CBService *service in peripheral.services) {
        NSLog(@"Discovered service: %@", service.UUID);
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

// Invoked when you discover the characteristics of a specified service.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"FFE0"]])  {  // 1
        for (CBCharacteristic *aChar in service.characteristics)
        {
            // Request key press notification
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:@"FFE1"]]) { // 2
                [self.sensorTagPeripheral setNotifyValue:YES forCharacteristic:aChar];
                NSLog(@"Found key press characteristic");
            }
        }
    }
}


-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    // Updated value for key press received
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE1"]]) {
        // Get the key value
        NSLog(@"Read value %@, %@", characteristic, error);
    }
}


-(void) peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didUpdateNotificationStateForCharacteristic %@ error = %@",characteristic,error);
}


-(void) peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didWriteValueForCharacteristic %@ error = %@",characteristic,error);
}
@end
