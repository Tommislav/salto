package unittests.se.salomonsson.salto.asbinding 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import org.flexunit.Assert;
	import se.salomonsson.salto.asbinding.Binding;
	import se.salomonsson.salto.asbinding.BindingEvent;
	import stubs.DummyBindableObject;
	/**
	 * ...
	 * @author Tommislav
	 */
	public class BindingDispatchTest extends EventDispatcher
	{
		
		[Before]
		public function setup():void
		{
			_source = new DummyBindableObject();
		}
		
		[After]
		public function teardown():void
		{
			// Will clear all bindings on this object
			dispatchEvent( new Event("destroy") );
			_e = null;
		}
		
		
		
		private var _source:DummyBindableObject;
		private var _e:BindingEvent;
		private var _dispatchCount:int;
		
		private function onBindingDispatched( e:BindingEvent ):void
		{
			_e = e;
			_dispatchCount++;
		}
		
		[Test]
		public function testBindingDispatch():void
		{
			Assert.assertEquals( 0, _dispatchCount );
			
			Binding.createPropertyChangeListener( _source, "string", this, onBindingDispatched );
			Assert.assertEquals( 1, _dispatchCount );
			
			_source.string = "someValue";
			Assert.assertEquals( 2, _dispatchCount );
			
			dispatchEvent( new Event( "destroy" ) ); // Destroy - release binding
			
			_source.string = "anotherValue";
			Assert.assertEquals( 2, _dispatchCount );
		}
	}
}