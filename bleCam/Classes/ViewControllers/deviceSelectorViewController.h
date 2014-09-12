//
//  deviceSelectorViewController.h
//  bleCam
//
//  Created by Alejandro Garcia Andrade on 03/08/14.
//  Copyright (c) 2014 alejandro.garcia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <AVFoundation/AVFoundation.h>
#import "AVCamPreviewView.h"

// Hola mundo

static void * CapturingStillImageContext = &CapturingStillImageContext;
static void * RecordingContext = &RecordingContext;
static void * SessionRunningAndDeviceAuthorizedContext = &SessionRunningAndDeviceAuthorizedContext;


@interface deviceSelectorViewController : UIViewController<CBCentralManagerDelegate,CBPeripheralDelegate,AVCaptureFileOutputRecordingDelegate>

// Says if it's connected
@property (nonatomic, strong) NSString *connected;

// To manage messages
@property (strong,nonatomic) CBCentralManager *cbCentralManager;
@property (nonatomic, strong) CBPeripheral *sensorTagPeripheral;

// An array to store devices
@property (strong,nonatomic) NSMutableArray *nDevices;

// An array to store different sensor tags
@property (strong,nonatomic) NSMutableArray *sensorTags;

// An array to store which sensors are enabled
@property NSMutableArray *sensorsEnabled;

// A control to set the bluetooth mark
@property (weak, nonatomic) IBOutlet UIImageView *bluetoothMark;

// A button for manually taka a picture
- (IBAction)snapStillImage:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *captureButton;

// A control to preview the camera
@property (weak, nonatomic) IBOutlet AVCamPreviewView *previewView;

// A button to switch between front and rear cameras
- (IBAction)frontRearCam:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *changeCamera;

@property int patata;

// Session management.
@property (nonatomic) dispatch_queue_t sessionQueue; // Communicate with the session and other session objects on this queue.
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCaptureDeviceInput *videoDeviceInput;
@property (nonatomic) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic) AVCaptureStillImageOutput *stillImageOutput;

// Utilities.
@property (nonatomic) UIBackgroundTaskIdentifier backgroundRecordingID;
@property (nonatomic, getter = isDeviceAuthorized) BOOL deviceAuthorized;
@property (nonatomic, readonly, getter = isSessionRunningAndDeviceAuthorized) BOOL sessionRunningAndDeviceAuthorized;
@property (nonatomic) BOOL lockInterfaceRotation;
@property (nonatomic) id runtimeErrorHandlingObserver;
@end
