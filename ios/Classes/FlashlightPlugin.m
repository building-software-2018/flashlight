#import "FlashlightPlugin.h"
#import <AVFoundation/AVFoundation.h>

@implementation FlashlightPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
        methodChannelWithName:@"com.bh.flutterplugins/flashlight"
                binaryMessenger:[registrar messenger]];
    FlashlightPlugin* instance = [[FlashlightPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"turnOn" isEqualToString:call.method]) {
        [self turn:YES];
        result(nil);
    }
    else if ([@"turnOff" isEqualToString:call.method]) {
        [self turn:NO];
        result(nil);
        }
    else if ([@"hasTorch" isEqualToString:call.method]) {
        result([NSNumber numberWithBool:[self hasTorch]]);
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}


- (bool) hasTorch
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    return ([device hasTorch] && [device hasFlash]);
}

- (void) turn: (bool) on {
    // check if flashlight available
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){

            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            [device unlockForConfiguration];
        }
    } 
}


@end
