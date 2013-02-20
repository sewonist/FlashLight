package com.itpointlab.ane
{
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;

	public class FlashLight
	{
		private static const EXTENSION_ID : String = "com.itpointlab.ane.FlashLight";
		private var _isSupported:Boolean;
		private var _context:ExtensionContext;
		
		private var _brigthness:Number = 1;
		private var _turnOn:Boolean = false;
		private var _iOS:Boolean = false;
		
		public function FlashLight()
		{
			if( Capabilities.manufacturer.indexOf("iOS") > -1) _iOS = true;
				
			try{
				_context = ExtensionContext.createExtensionContext(EXTENSION_ID, null);
				
				try{
					_isSupported = _context.call("isSupported");
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

		public function get turnOn():Boolean
		{
			return _turnOn;
		}

		public function set turnOn(value:Boolean):void
		{
			_turnOn = value;
			_context.call("turnLightOn", _turnOn);
		}

		public function get brigthness():Number
		{
			return _brigthness;
		}
		
		public function set brigthness(value:Number):void
		{
			if(_iOS){
				_context.call("setBrightness", value);
			} else {
				trace('Android is not supported brightness.');
			}
		}
		
	}
}