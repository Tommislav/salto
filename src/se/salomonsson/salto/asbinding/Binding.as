package se.salomonsson.salto.asbinding 
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Tommislav
	 */
	public class Binding 
	{
		
		
		
		
		public static function createBinding( sourceObject:IBindable, sourceProperty:String, targetObject:Object, targetVariable:String ):Binding
		{
			var b:Binding = new Binding();
			b.setupBinding( sourceObject, sourceProperty, targetObject, targetVariable );
			return b;
		}
		
		public static function createPropertyChangeListener( sourceObject:IBindable, sourceProperty:String, targetObject:Object, listener:Function ):Binding
		{
			var b:Binding = new Binding();
			b.setupPropertyChangeListener( sourceObject, sourceProperty, targetObject, listener );
			return b;
		}
		
		
		public static function update( sourceObject:IBindable, property:String, oldValue:*, newValue:*, forceUpdate:Boolean=false ):*
		{
			if ( oldValue != newValue || forceUpdate )
			{
				var e:BindingEvent = new BindingEvent( property, oldValue, newValue, sourceObject, forceUpdate );
				sourceObject.dispatchEvent( e );
			}
			return newValue;
		}
		
		
		
		
		
		
		//private static var _allBindings:Vector.<Binding> = new Vector.<Binding>();
		
		
		
		private var _source:IBindable;
		private var _sourceProperty:String;
		private var _targetObject:Object;
		private var _targetProperty:String;
		private var _bound:Boolean;
		private var _listener:Function;
		
		public function Binding() 
		{
			
		}
		
		public function get isBound():Boolean { return _bound; }
		
		private function setupBinding( source:IBindable, sourceProperty:String, targetObject:Object, targetVariable:String ):void
		{
			//_allBindings.push(this);
			
			_source = source;
			_source.addEventListener( "destroy", onSourceDestroy );
			_source.addEventListener( sourceProperty, onPropUpdate );
			
			_sourceProperty 	= sourceProperty;
			_targetObject 		= targetObject;
			_targetProperty 	= targetVariable;
			
			if (_targetObject is IEventDispatcher)
				IEventDispatcher(targetObject).addEventListener( "destroy", onTargetDestroy );
			
			try
			{
				var initialValue:* = _source[_sourceProperty];
			}
			catch (e:Error)
			{
				throw new Error("Cannot read value " + sourceProperty + " from target source " + _source);
			}
			executeBinding( initialValue );
			
			_bound = true;
		}
		
		private function setupPropertyChangeListener( source:IBindable, sourceProperty:String, targetObject:Object, listener:Function ):void
		{
			_source 		= source;
			_sourceProperty = sourceProperty;
			_targetObject 	= targetObject;
			_listener 		= listener;
			
			_source.addEventListener( "destroy", onSourceDestroy );
			if (_targetObject is IEventDispatcher)
				IEventDispatcher(_targetObject).addEventListener("destroy", onTargetDestroy );
			
			_source.addEventListener( _sourceProperty, redispatchEvent );
			
			try
			{
				var val:* = _source[_sourceProperty];
			}
			catch (e:Error)
			{
				throw new Error("Cannot read value " + sourceProperty + " from target source " + _source);
			}
			var e:BindingEvent = new BindingEvent( _sourceProperty, val, val, _source, true );
			redispatchEvent( e );
			_bound = true;
		}
		
		
		
		
		
		
		
		private function onSourceDestroy(e:Event):void
		{
			releaseBinding();
		}
		
		private function onTargetDestroy(e:Event):void
		{
			releaseBinding();
		}
		
		public function releaseBinding():void
		{
			_source.removeEventListener("destroy", onSourceDestroy );
			_source.removeEventListener(_sourceProperty, onPropUpdate );
			
			if (_targetObject is IEventDispatcher)
				IEventDispatcher(_targetObject).removeEventListener("destroy", onTargetDestroy);
			
			_source = null;
			_targetObject = null;
			_listener = null;
			_bound = false;
		}
		
		
		
		
		
		
		
		private function redispatchEvent(e:Event):void 
		{
			if (_listener == null)
				return;
			
			var bindingEvent:BindingEvent = e as BindingEvent;
			if (bindingEvent != null)
			{
				if ( bindingEvent.oldValue != bindingEvent.newValue || bindingEvent.forceUpdate )
				{
					_listener( bindingEvent );
				}
			}
		}
		
		
		
		
		private function onPropUpdate( e:Event ):void
		{
			var bindingEvent:BindingEvent = e as BindingEvent;
			if (bindingEvent != null)
			{
				if ( bindingEvent.oldValue != bindingEvent.newValue || bindingEvent.forceUpdate )
				{
					executeBinding( bindingEvent.newValue );
				}
			}
		}
		
		private function executeBinding( value:* ):void
		{
			try
			{
				_targetObject[ _targetProperty ] = value;
			}
			catch ( e:Error )
			{
				var errorMessage:String = "";
				errorMessage += "Error binding property " + _targetProperty + " on target object " + _targetObject + "\n";
				errorMessage += "is property public?\n";
				errorMessage += "Remember to check stackTrace, uncaught errors casued by updating this property will make it look like the binding is the error";
				throw new Error( errorMessage );
			}
		}
		
		
		
		
		
		
		
		
		/*
		private function getContainerFromSource( src:IBindable ):BindingContainer
		{
			for each ( var bc:BindingContainer in _allSources )
			{
				if (bc.source == src)
					return bc;
			}
			
			var newBinding:BindingContainer = new BindingContainer( src );
			return newBinding;
		}*/
	}

}

/*
import flash.utils.Dictionary;

internal class BindingContainer
{
	public var source:IBindable;
	public var properties:Dictionary;
	public function BindingContainer( source:IBindable )
	{
		this.source = source;
		properties = new Dictionary();
	}
	
	public function getPropertyWatcher( property:String ):Array
	{
		if ( properties[property] == null )
			properties[property] = new Array();
		
		return properties[property];
	}
}

internal class TargetBinding
{
	public var targetObject:Object;
	public var targetSetter:String;
	public function TargetBinding( targetObj:Object, targetSetter:String )
	{
		this.targetObject = targetObj;
		this.targetSetter = targetSetter;
	}
}
*/