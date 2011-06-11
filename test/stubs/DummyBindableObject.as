package stubs
{
	import flash.events.EventDispatcher;
	import mockolate.ingredients.answers.ReturnsAnswer;
	import se.salomonsson.salto.asbinding.Binding;
	import se.salomonsson.salto.asbinding.BindingEvent;
	import se.salomonsson.salto.asbinding.IBindable;
	
	/**
	 * ...
	 * @author Tommislav
	 */
	public class DummyBindableObject extends EventDispatcher implements IBindable 
	{
		
		public function DummyBindableObject() 
		{
			
		}
		
		// manually dispatch bindingEvent with old and new value
		private var _string:String;
		public function get string():String { return _string; }
		public function set string( value:String ):void 
		{
			var oldValue:String = _string;
			_string = value;
			dispatchEvent( new BindingEvent( "string", oldValue, _string, this, false ) );
		}
		
		
		// let binding take care of dispatching the event for you
		private var _secondString:String;
		public function get secondString():String { return _secondString; }
		public function set secondString(value:String):void { _secondString = Binding.update( this, "secondString", _secondString, value ); }
	}

}