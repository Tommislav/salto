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
	public class BindingTest extends EventDispatcher
	{
		private var _source:DummyBindableObject;
		
		public var testString:String;
		
		public function BindingTest() 
		{
			
		}
		
		[Before]
		public function setup():void
		{
			testString = "";
			_source = new DummyBindableObject();
		}
		
		[After]
		public function teardown():void
		{
			// Will clear all bindings on this object
			dispatchEvent( new Event("destroy") );
		}
		
		[Test]
		public function testInitialBinding():void
		{
			Assert.assertEquals( "", this.testString );
			
			_source.string = "initialValue"; // set vaule before binding is set
			var b:Binding = Binding.createBinding( _source, "string", this, "testString" );	// Bind source string to our testString variable
			
			Assert.assertEquals( "initialValue", this.testString );
		}
		
		[Test]
		public function testBinding():void
		{
			Assert.assertEquals( "", testString );
			
			var b:Binding = Binding.createBinding( _source, "string", this, "testString" );
			_source.string = "updatedValue"; // change value after binding is set
			
			Assert.assertEquals( "updatedValue", this.testString );
		}
		
		
		[Test]
		public function testUpdateBindingFromBindingClass():void
		{
			Assert.assertEquals( "", testString );
			
			// _source.secondString will update its bindings differently than _source.string
			var b:Binding = Binding.createBinding( _source, "secondString", this, "testString" );
			_source.secondString = "updatedValueThroughBinding";
			
			Assert.assertEquals( "updatedValueThroughBinding", testString );
		}
		
		[Test]
		public function testReleaseBinding():void
		{
			Assert.assertEquals( "", testString );
			
			var b:Binding = Binding.createBinding( _source, "string", this, "testString" );
			
			_source.string = "value 1";
			Assert.assertEquals( "value 1", testString );
			
			b.releaseBinding(); // release binding!
			
			_source.string = "value 2";
			Assert.assertEquals( "value 1", this.testString ); // should NOT have been updated after releaseBinding!!!
		}
		
		[Test]
		public function testDestroyBindingByTargetDispatch():void
		{
			Assert.assertEquals( "", testString );
			var b:Binding = Binding.createBinding( _source, "string", this, "testString" );
			_source.string = "value 1";
			
			Assert.assertEquals("value 1", testString);
			
			dispatchEvent( new Event("destroy") );	// if target dispatches "destroy" then we release the binding!
			
			_source.string = "value 2";
			Assert.assertEquals( "value 1", testString );
		}
		
		[Test]
		public function testDestroyBindingBySourceDispatch():void
		{
			Assert.assertEquals( "", testString );
			var b:Binding = Binding.createBinding( _source, "string", this, "testString" );
			
			_source.string = "value 1";
			Assert.assertEquals("value 1", testString);
			
			_source.dispatchEvent( new Event( "destroy" ) ); // if source dispatches "destroy" then all bindings on that source will be released
			
			_source.string = "value 2";
			Assert.assertEquals( "value 1", testString );
		}
	}
}