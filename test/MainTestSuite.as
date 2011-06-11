package  
{
	import unittests.se.salomonsson.salto.asbinding.AsBindingTestSuite;
	
	
	/**
	 * This is the main testsuit where you can configure which sub-testsuits you want to run.
	 * @author Tommy Salomonsson
	 */
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]	
	public class MainTestSuite
	{
		
		public var d:DummyTest;
		public var bindingSuite:AsBindingTestSuite;
		
		/* Examples!
		
		[Test]
		public function doTest():void
		{
			//org.flexunit.Assert;
			Assert.assertTrue(true);
		}
		
		[Test(async,timeout="900")]
		public function testEvent():void
		{
			// org.flexunit.async.Async
			Async.handleEvent( testCase(this), targetDispatcher, "eventName", eventHandler, timeout, passThroughObject, timeoutHandler );
		}
		
		private function eventHandler( e:Event, passthrough:Object ):void 
		{
			
		}
		
		
		
		
		*/
		
		
	}

}