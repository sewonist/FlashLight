package com.itpointlab.ane.flashlight;

import java.util.HashMap;
import java.util.Map;

import android.hardware.Camera;
import android.hardware.Camera.Parameters;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

/**
 * @author sewonist
 *
 */
public class FlashLightContext extends FREContext {

	public static Camera camera;
	public static Parameters parameters;
	
	public FlashLightContext()
	{
		FlashLightContext.camera = Camera.open();
		FlashLightContext.parameters = FlashLightContext.camera.getParameters();
	}
	
	@Override
	public void dispose() {
		// TODO Auto-generated method stub

	}

	@Override
	public Map<String, FREFunction> getFunctions() {
		
		Map<String, FREFunction> map = new HashMap<String, FREFunction>();
        
		map.put("isSupported", new IsSupportedFunction());
		map.put("flashLightOn", new FlashLightOnFunction());
		map.put("flashLightOff", new FlashLightOffFunction());
		map.put("flashLightMode", new FlashLightModeFunction());
		
        return map;
	}
	
}