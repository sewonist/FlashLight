package com.itpointlab.ane
{
	import flash.events.EventDispatcher;
	import flash.external.ExtensionContext;

	public class FlashLight extends EventDispatcher
	{
		private static const EXTENSION_ID : String = "com.itpointlab.ane.FlashLight";
		private var _isSupported:Boolean;
		private var _context:ExtensionContext;
		private var _turnOn:Boolean;
		
		public function FlashLight()
		{
			try{
				_context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
			}catch(e:Error){
			}
		}
		
		public function get isSupported():Boolean
		{
			var support:Boolean = _context.call( "isSupported" );
			return support;
		}
		
		public function get turnOn():Boolean
		{
			return _turnOn;
		}
		
		public function set turnOn(value:Boolean):void
		{
			if( isSupported == false) return;
			_context.call("turnLightOn", value);
		}
	}
}