//  FlashLight.m
//  FlashLight
//
//  Created by sewonist on 13. 2. 13..
//  Copyright (c) 2013년 sewonist. All rights reserved.
//

#import "FlashRuntimeExtensions.h"
#import "FlashLight.h"
#import <UIKit/UIKit.h>

@implementation FlashLight

@end

#pragma mark - Native Function

AVCaptureDevice *device;

char * ON = "on";
char * OFF = "off";
char * CODE = "code";
char * EVENT_CHANGE = "change";

void turnLight(BOOL on, FREContext ctx) {
    if ([device hasTorch] && [device hasFlash]){
        [device lockForConfiguration:nil];
        if (on) {
            [device setTorchMode:AVCaptureTorchModeOn];
            [device setFlashMode:AVCaptureFlashModeOn];
            FREDispatchStatusEventAsync( ctx, (uint8_t*)ON, (uint8_t*)EVENT_CHANGE );
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
            [device setFlashMode:AVCaptureFlashModeOff];
            FREDispatchStatusEventAsync( ctx, (uint8_t*)OFF, (uint8_t*)EVENT_CHANGE );
        }
        [device unlockForConfiguration];
    }
}

#pragma mark - ANE Function
FREObject turnLightOn(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ){
    uint32_t on;
    FREGetObjectAsBool(argv[0], &on);
    turnLight(on, ctx);
    
    return nil;
}

FREObject flashLightIsSupported(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ){
    FREObject result = nil;
    
    if(FRENewObjectFromBool(YES, &result) == FRE_OK){
        return result;
    }else{
        return nil;
    }
}

#pragma mark - Context Initializer
void FlashLightContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx,
                                  uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) {
    
    NSLog(@"Entering FlashLightContextInitializer()");
    
    int count = 2;
	*numFunctionsToTest = count;
	FRENamedFunction* func = (FRENamedFunction*)malloc(sizeof(FRENamedFunction) * count);
    
	func[0].name = (const uint8_t*)"isSupported";
	func[0].functionData = NULL;
	func[0].function = &flashLightIsSupported;
    
    func[1].name = (const uint8_t*)"turnLightOn";
	func[1].functionData = NULL;
	func[1].function = &turnLightOn;
    
	*functionsToSet = func;
    
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    NSLog(@"Exiting FlashLightContextInitializer()");
}
void FlashLightContextFinalizer(FREContext ctx) {
    
    NSLog(@"Entering FlashLightContextFinalizer()");
    
    // Nothing to clean up.
    
    NSLog(@"Exiting FlashLightContextFinalizer()");
    
	return;
}
void FlashLightExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet,
                              FREContextFinalizer* ctxFinalizerToSet) {
    
    NSLog(@"Entering FlashLightExtInitializer()");
    
	*extDataToSet = NULL;
	*ctxInitializerToSet = &FlashLightContextInitializer;
	*ctxFinalizerToSet = &FlashLightContextFinalizer;
    
    NSLog(@"Exiting FlashLightExtInitializer()");
}
void FlashLightExtFinalizer(void* extData) {
    
    NSLog(@"Entering FlashLightExtFinalizer()");
    
	// Nothing to clean up.
    
    NSLog(@"Exiting FlashLightExtFinalizer()");
    
	return;
}