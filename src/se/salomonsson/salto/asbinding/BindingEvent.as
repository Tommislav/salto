package se.salomonsson.salto.asbinding
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Tommislav
	 */
	public class BindingEvent extends Event 
	{
		//public static const UPDATE:String = "update";
		
		private var _oldValue:*;
		private var _newValue:*;
		private var _sourceObject:IBindable;
		private var _forceUpdate:Boolean;
		
		public function get oldValue():*				{	return _oldValue;		}
		public function get newValue():* 				{	return _newValue;		}
		public function get sourceObject():IBindable 	{	return _sourceObject;	}
		public function get forceUpdate():Boolean 		{	return _forceUpdate;	}
		
		
		public function BindingEvent(propertyName:String, oldValue:*, newValue:*, sourceObject:IBindable, forceUpdate:Boolean=false) 
		{ 
			_oldValue 		= oldValue;
			_newValue 		= newValue;
			_sourceObject 	= sourceObject;
			_forceUpdate 	= forceUpdate;
			
			super(propertyName, false, false);
		} 
		
		public override function clone():Event 
		{ 
			return new BindingEvent(this.type, _oldValue, _newValue, _sourceObject, _forceUpdate);
		} 
	}
}