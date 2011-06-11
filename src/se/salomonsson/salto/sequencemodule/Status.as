package se.salomonsson.salto.sequencemodule
{
	
	/**
	 * <p>Enumeration class.</p>
	 * Lists the different status-modes the startup sequence can have, and also what status
	 * each individual startupModule can have.
	 * @author Tommy Salomonsson
	 */
	public class Status
	{
		
		public static const RESET			:Status = makeEnum("reset");
		public static const WORKING			:Status = makeEnum("working");
		public static const COMPLETE		:Status = makeEnum("complete");
		public static const SUSPENDED		:Status = makeEnum("suspended");
		public static const ERROR			:Status = makeEnum("error");
		
		
		
		
		
		
		private static var _locked:Boolean = true;
		private static function makeEnum( enum:String ):Status
		{
			_locked = false;
			var value:Status = new Status( enum );
			_locked = true;
			return value;
		}
		
		private var _enumeration:String;
		public function Status( enumeration:String ) 
		{
			if (_locked)
				throw new Error( "This is an enumeration, use of 'new' is not allowed" );
			
			_enumeration = enumeration;	
		}
		
		public function toString():String
		{
			return _enumeration;
		}
		
		public function valueOf():Object
		{
			return this;
		}
	}
	
}