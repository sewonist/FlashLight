//
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

AVCaptureDevice *device;
double brightness = 1.0;
bool iOS6 = FALSE;

char * CODE = "code";
char * EVENT_CHANGE = "change";

void turnLight(BOOL on, FREContext ctx) {
    if ([device hasTorch] && [device hasFlash]){
        [device lockForConfiguration:nil];
        if (on) {
            if(iOS6)
                [device setTorchModeOnWithLevel:brightness error:nil];
            else
                [device setTorchMode:AVCaptureTorchModeOn];
            
            [device setFlashMode:AVCaptureFlashModeOn];
            //torchIsOn = YES; //define as a variable/property if you need to know status
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
            [device setFlashMode:AVCaptureFlashModeOff];
            //torchIsOn = NO;
        }
        [device unlockForConfiguration];
        
        FREDispatchStatusEventAsync( ctx, (uint8_t*)CODE, (uint8_t*)EVENT_CHANGE );
    }
}

FREObject turnLightOn(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ){
    uint32_t on;
    FREGetObjectAsBool(argv[0], &on);
    turnLight(on, ctx);
    return nil;
}

FREObject setBrightness(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ){
    FREGetObjectAsDouble(argv[0], &brightness);
    turnLight(YES, ctx);
    
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






//
// FREObject study
//
FREObject getBoolean(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ){
    FREObject retVal;
    if(FRENewObjectFromBool(YES, &retVal) == FRE_OK){
        return retVal;
    }else{
        return nil;
    }
}

FREObject getInt(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ){
    FREObject retVal;
    if(FRENewObjectFromInt32(1234567, &retVal) == FRE_OK){
        return retVal;
    }else{
        return nil;
    }
}

FREObject getString(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ){
    FREObject retVal;
    char * foo = "bar";
    if(FRENewObjectFromUTF8(strlen(foo), (const uint8_t*)foo, &retVal) == FRE_OK){
        return retVal;
    }else{
        return nil;
    }
}

FREObject getArray(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ){
    FREObject retVal;
    FRENewObject((const uint8_t*)"Array", 0, NULL, &retVal, nil);
    
    FREObject b = getBoolean(ctx, funcData, argc, argv);
    FREObject i = getInt(ctx, funcData, argc, argv);
    FREObject s = getString(ctx, funcData, argc, argv);
    
    FRESetArrayElementAt(retVal, 0, b);
    FRESetArrayElementAt(retVal, 1, i);
    FRESetArrayElementAt(retVal, 2, s);
    
    return retVal;
}

FREObject getCustomObject(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] ){
    FREObject CustomObject[2];
    
    char * name = "jhon.doe";
    FRENewObjectFromUTF8(strlen(name), (const uint8_t*)name, &CustomObject[0]);
    FRENewObjectFromInt32(1234567, &CustomObject[1]);
    
    FREObject retVal;
    FRENewObject((const uint8_t*)"com.itpointlab.ane.CustomObject", 2, CustomObject, &retVal, nil);
    
    return retVal;
}






// ContextInitializer()
//
// The context initializer is called when the runtime creates the extension context instance.

void FlashLightContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx,
                                   uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) {
	
    NSLog(@"Entering FlashLightContextInitializer()");
    
    int count = 8;
	*numFunctionsToTest = count;
	FRENamedFunction* func = (FRENamedFunction*)malloc(sizeof(FRENamedFunction) * count);
    
	func[0].name = (const uint8_t*)"isSupported";
	func[0].functionData = NULL;
	func[0].function = &flashLightIsSupported;
	
    func[1].name = (const uint8_t*)"turnLightOn";
	func[1].functionData = NULL;
	func[1].function = &turnLightOn;

    func[2].name = (const uint8_t*)"setBrightness";
	func[2].functionData = NULL;
	func[2].function = &setBrightness;
    
    func[3].name = (const uint8_t*)"getBoolean";
	func[3].functionData = NULL;
	func[3].function = &getBoolean;
    
    func[4].name = (const uint8_t*)"getInt";
	func[4].functionData = NULL;
	func[4].function = &getInt;
    
    func[5].name = (const uint8_t*)"getString";
	func[5].functionData = NULL;
	func[5].function = &getString;
    
    func[6].name = (const uint8_t*)"getArray";
	func[6].functionData = NULL;
	func[6].function = &getArray;
    
    func[7].name = (const uint8_t*)"getCustomObject";
	func[7].functionData = NULL;
	func[7].function = &getCustomObject;
    
    
	*functionsToSet = func;
    
    // check if flashlight available
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }

    NSString *reqSysVer = @"6.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
        iOS6 = TRUE;
    
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
