package com.itpointlab.ane.flashlight;

import android.hardware.Camera.Parameters;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;

public class FlashLightModeFunction implements FREFunction {

	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		// Supported
		FREObject result = null;
		Boolean mode = false;
		if( FlashLightContext.parameters.getFlashMode() == Parameters.FLASH_MODE_TORCH ){
			mode = true;
		}else{
			mode = false;
		}
		
		try 
		{
			result = FREObject.newObject( mode );
		}
		catch (FREWrongThreadException fwte)
		{
			fwte.printStackTrace();
		}
		
		Log.v( "[FlashLightModeFunction]", "mode is " + mode );
		
		return result;
	}

}

