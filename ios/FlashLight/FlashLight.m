//
//  FlashLight.m
//  FlashLight
//
//  Created by sewonist on 13. 2. 13..
//  Copyright (c) 2013년 sewonist. All rights reserved.
//

#import "FlashRuntimeExtensions.h"
#import "FlashLight.h"

@implementation FlashLight

@end

FREObject turnLightOn(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ){
    uint32_t on;
    FREGetObjectAsBool(argv[0], &on);
    
    // check if flashlight available
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                //torchIsOn = YES; //define as a variable/property if you need to know status
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                //torchIsOn = NO;
            }
            [device unlockForConfiguration];
        }
    }
    
    return nil;
}

FREObject flashLightIsSupported(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ){
    FREObject retVal;
    if(FRENewObjectFromBool(YES, &retVal) == FRE_OK){
        return retVal;
    }else{
        return nil;
    }
}

// ContextInitializer()
//
// The context initializer is called when the runtime creates the extension context instance.

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
    
    NSLog(@"Exiting FlashLightContextInitializer()");
}



// ContextFinalizer()
//
// The context finalizer is called when the extension's ActionScript code
// calls the ExtensionContext instance's dispose() method.
// If the AIR runtime garbage collector disposes of the ExtensionContext instance, the runtime also calls
// ContextFinalizer().

void FlashLightContextFinalizer(FREContext ctx) {
	
    NSLog(@"Entering FlashLightContextFinalizer()");
    
    // Nothing to clean up.
	
    NSLog(@"Exiting FlashLightContextFinalizer()");
    
	return;
}



// ExtInitializer()
//
// The extension initializer is called the first time the ActionScript side of the extension
// calls ExtensionContext.createExtensionContext() for any context.

void FlashLightExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet,
                               FREContextFinalizer* ctxFinalizerToSet) {
	
    NSLog(@"Entering FlashLightExtInitializer()");
    
	*extDataToSet = NULL;
	*ctxInitializerToSet = &FlashLightContextInitializer;
	*ctxFinalizerToSet = &FlashLightContextFinalizer;
    
    NSLog(@"Exiting FlashLightExtInitializer()");
}



// ExtFinalizer()
//
// The extension finalizer is called when the runtime unloads the extension. However, it is not always called.

void FlashLightExtFinalizer(void* extData) {
	
    NSLog(@"Entering FlashLightExtFinalizer()");
	
	// Nothing to clean up.
	
    NSLog(@"Exiting FlashLightExtFinalizer()");
    
	return;
}
