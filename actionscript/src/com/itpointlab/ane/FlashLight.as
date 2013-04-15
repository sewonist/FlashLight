package com.itpointlab.ane
{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.events.Event;

	public class FlashLight extends EventDispatcher
	{
		private static const EXTENSION_ID : String = "com.itpointlab.ane.FlashLight";
		
		protected static var instance:FlashLight;
		protected const SINGLETON_MSG:String = "FlashLight Singleton already constructed!";
		
		private var _context:ExtensionContext;
		private var _turnOn:Boolean;
		
		public function FlashLight()
		{
			if (instance != null) throw Error(SINGLETON_MSG);
			instance = this;
			
			try{
				_context = ExtensionContext.createExtensionContext( EXTENSION_ID, null );
				_context.addEventListener( StatusEvent.STATUS, onStatus );
			}catch(e:Error){
			}
		}
		
		public static function getInstance():FlashLight
		{
			if( instance == null ) instance = new FlashLight();
			return instance as FlashLight;
		}
		
		public function on():void
		{
			if( _context == null ) return;
			_turnOn = true;
			_context.call( "flashLightOn" );
		}
		
		public function off():void
		{
			if( _context == null ) return;
			_turnOn = false;
			_context.call( "flashLightOff" );
		}
		
		public function get isSupported():Boolean
		{
			if( _context == null ) return false;
			var support:Boolean = _context.call( "isSupported" );
			return support;
		}
		
		public function get mode():Boolean
		{
			if( _context == null ) return false;
			var mode:Boolean = _context.call( "flashLightMode" );
			return mode;
		}
		
		protected function onStatus( event:StatusEvent ):void
		{
			dispatchEvent( new Event( event.level ) );
		}
	}
}