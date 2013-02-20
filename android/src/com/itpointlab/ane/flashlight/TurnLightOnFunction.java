package com.itpointlab.ane.flashlight;

import android.hardware.Camera;
import android.hardware.Camera.Parameters;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;

public class TurnLightOnFunction implements FREFunction {

	private Camera mCamera;
	private Parameters mParameters;
	
	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		
		boolean on = false;
		
		try {
			on = arg1[0].getAsBool();
		} catch (IllegalStateException e) {
			e.printStackTrace();
		} catch (FRETypeMismatchException e) {
			e.printStackTrace();
		} catch (FREInvalidObjectException e) {
			e.printStackTrace();
		} catch (FREWrongThreadException e) {
			e.printStackTrace();
		}
		
		Log.v("[TurnLightOn]", "torch is "+on );
		
		if(mCamera==null){
			mCamera = Camera.open();     
			mParameters = mCamera.getParameters();
		}
		
		if(on){
			mParameters.setFlashMode(Parameters.FLASH_MODE_TORCH);
			mCamera.setParameters(mParameters);
		} else {
			mParameters.setFlashMode(Parameters.FLASH_MODE_OFF);
			mCamera.setParameters(mParameters);
		}
		
		return null;
	}

}

