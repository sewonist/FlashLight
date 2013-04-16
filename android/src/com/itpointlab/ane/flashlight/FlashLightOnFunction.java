package com.itpointlab.ane.flashlight;

import android.hardware.Camera.Parameters;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class FlashLightOnFunction implements FREFunction {

	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) 
	{
		FlashLightContext.parameters.setFlashMode(Parameters.FLASH_MODE_TORCH);
		FlashLightContext.camera.setParameters( FlashLightContext.parameters );
		
		arg0.dispatchStatusEventAsync( "on", "change" );
		
		return null;
	}

}

