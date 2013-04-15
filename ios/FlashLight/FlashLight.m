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
FREObject flashLightOn(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ){
    if ([device hasTorch] && [device hasFlash]){
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOn];
        [device setFlashMode:AVCaptureFlashModeOn];
        FREDispatchStatusEventAsync( ctx, (uint8_t*)ON, (uint8_t*)EVENT_CHANGE );
        [device unlockForConfiguration];
    }
    
    return nil;
}

FREObject flashLightOff(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ){
    if ([device hasTorch] && [device hasFlash]){
        [device lockForConfiguration:nil];
        [device setTorchMode:AVCaptureTorchModeOff];
        [device setFlashMode:AVCaptureTorchModeOff];
        FREDispatchStatusEventAsync( ctx, (uint8_t*)ON, (uint8_t*)EVENT_CHANGE );
        [device unlockForConfiguration];
    }
    
    return nil;
}

FREObject flashLightMode(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ){
    FREObject result = nil;
    
    if ([device hasTorch] && [device hasFlash]){
        if( device.torchMode && device.flashMode ){
            FRENewObjectFromBool(YES, &result);
        }else{
            FRENewObjectFromBool(NO, &result);
        }
    }
    
    return result;
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
    
    int count = 4;
	*numFunctionsToTest = count;
	FRENamedFunction* func = (FRENamedFunction*)malloc(sizeof(FRENamedFunction) * count);
    
	func[0].name = (const uint8_t*)"isSupported";
	func[0].functionData = NULL;
	func[0].function = &flashLightIsSupported;
    
    func[1].name = (const uint8_t*)"flashLightOn";
	func[1].functionData = NULL;
	func[1].function = &flashLightOn;
    
    func[2].name = (const uint8_t*)"flashLightOff";
	func[2].functionData = NULL;
	func[2].function = &flashLightOff;
    
    func[3].name = (const uint8_t*)"flashLightMode";
	func[3].functionData = NULL;
	func[3].function = &flashLightMode;
    
	*functionsToSet = func;
    
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
}
void FlashLightContextFinalizer(FREContext ctx) {
    return;
}
void FlashLightExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet,
                              FREContextFinalizer* ctxFinalizerToSet) {
	*extDataToSet = NULL;
	*ctxInitializerToSet = &FlashLightContextInitializer;
	*ctxFinalizerToSet = &FlashLightContextFinalizer;
}
void FlashLightExtFinalizer(void* extData) {
    return;
}