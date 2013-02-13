package com.itpointlab.ane
{
	import flash.external.ExtensionContext;

	public class FlashLight
	{
		private static const EXTENSION_ID : String = "com.itpointlab.ane.FlashLight";
		private var _isSupported:Boolean;
		private var context:ExtensionContext;
		
		public function FlashLight()
		{
			try{
				context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
				
				try{
					_isSupported = context.call("isSupported");
				}catch(e:Error){
					_isSupported = false;
				}
				
			}catch(e:Error){
				_isSupported = false;
				trace(e.message, e.errorID);
			}
		}
		
		public function get isSupported():Boolean{
			return _isSupported;
		}
		
		public function turnLightOn(on:Boolean):void
		{
			if(isSupported){
				context.call("turnLightOn", on);
			}
		}
	}
}