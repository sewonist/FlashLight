package com.itpointlab.ane
{
	import flash.events.EventDispatcher;
	import flash.external.ExtensionContext;

	public class FlashLight extends EventDispatcher
	{
		private static const EXTENSION_ID : String = "com.itpointlab.ane.FlashLight";
		private var _isSupported:Boolean;
		private var _context:ExtensionContext;
		
		public function FlashLight()
		{
			try{
				_context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
			}catch(e:Error){
				_isSupported = false;
			}
		}
	}
}