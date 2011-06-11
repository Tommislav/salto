package se.salomonsson.salto.utils
{
	import flash.external.ExternalInterface;
	/**
	 * Better - more stable - way to check if javascript is enabled or not on the webpage
	 * @author Tommy Salomonsson
	 */
	public class JSCheck
	{
		private static var _initialized:Boolean;
		private static var _jsAvailable:Boolean;
		
		public static function get javascripAvailable():Boolean
		{
			if (!_initialized)
				_jsAvailable = checkJS();
			
			return _jsAvailable;
		}
		
		private static function checkJS():Boolean
		{
			if (!ExternalInterface.available)
				return false;
			
			try
			{
				// allowScriptAccess=never on html-page will return ExternalInterface.available == true
				// but still throw errors if js-calls are invoked
				var url:String = ExternalInterface.call("document.location.toString");
			}
			catch ( e:Error )
			{
				return false;
			}
			
			return true;
		}
		
		public function JSCheck() 
		{
			
			
		}
		
	}

}