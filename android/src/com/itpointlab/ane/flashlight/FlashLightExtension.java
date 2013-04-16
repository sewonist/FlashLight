package com.itpointlab.ane.flashlight;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class FlashLightExtension implements FREExtension {

	@Override
	public FREContext createContext(String arg0) {
		
		Log.e("FlashLightExtension", "call createContext");
		
		return new FlashLightContext();
	}

	@Override
	public void dispose() {
	}

	@Override
	public void initialize() {
	}

}
