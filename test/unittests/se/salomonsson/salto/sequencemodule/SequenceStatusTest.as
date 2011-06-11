package unittests.se.isotop.video.startup 
{
	import de.polygonal.ds.Iterator;
	import de.polygonal.ds.SLinkedList;
	import org.flexunit.Assert;
	import se.isotop.video.startup.StartupInfo;
	import se.isotop.video.startup.StartupSequence;
	import se.isotop.video.startup.Status;
	import unittests.se.isotop.video.startup.dummyModules.DummyModuleSetStatus;
	import unittests.se.isotop.video.startup.dummyModules.NoNeedToStartModule;
	import unittests.se.isotop.video.startup.dummyModules.SyncCompleteModule;
	
	/**
	 * ...
	 * @author Tommy Salomonsson
	 */
	public class SequenceStatusTest
	{
		
		public function SequenceStatusTest() 
		{
		}
		
		[Test]
		public function testPercent():void
		{
			var mod0:DummyModuleSetStatus = new DummyModuleSetStatus();
			var mod1:DummyModuleSetStatus = new DummyModuleSetStatus();
			var mod2:DummyModuleSetStatus = new DummyModuleSetStatus();
			var mod3:DummyModuleSetStatus = new DummyModuleSetStatus();
			
			var list:SLinkedList = new SLinkedList( mod0, mod1, mod2, mod3 );
			var it:Iterator = list.getIterator();
			
			Assert.assertEquals( 0, new StartupInfo(it).percentCompleted );
			
			mod0.setStatus( Status.COMPLETE );
			
			Assert.assertEquals( 0.25, new StartupInfo(it).percentCompleted );
			
			mod1.setStatus( Status.COMPLETE );
			mod2.setStatus( Status.WORKING );
			
			Assert.assertEquals( 0.5, new StartupInfo(it).percentCompleted );
			Assert.assertEquals( 2, new StartupInfo(it).progress );
			
			mod2.setStatus( Status.COMPLETE );
			mod3.setStatus( Status.COMPLETE );
			
			Assert.assertEquals( 1, new StartupInfo(it).percentCompleted );
			Assert.assertEquals( Status.COMPLETE, new StartupInfo(it).status );
		}
		
		[Test]
		public function testInfoSuspend():void
		{
			var mod0:DummyModuleSetStatus = new DummyModuleSetStatus(Status.COMPLETE);
			var mod1:DummyModuleSetStatus = new DummyModuleSetStatus(Status.SUSPENDED);
			var mod2:DummyModuleSetStatus = new DummyModuleSetStatus();
			
			var list:SLinkedList = new SLinkedList( mod0, mod1, mod2 );
			var it:Iterator = list.getIterator();
			
			Assert.assertEquals( "should be suspended", Status.SUSPENDED, new StartupInfo(it).status );
		}
		
		[Test]
		public function testInfoError():void
		{
			var mod0:DummyModuleSetStatus = new DummyModuleSetStatus(Status.SUSPENDED);
			var mod1:DummyModuleSetStatus = new DummyModuleSetStatus(Status.ERROR);
			var mod2:DummyModuleSetStatus = new DummyModuleSetStatus(Status.COMPLETE);
			
			var list:SLinkedList = new SLinkedList( mod0, mod1, mod2 );
			var it:Iterator = list.getIterator();
			
			Assert.assertEquals( "should be error", Status.ERROR, new StartupInfo(it).status );
		}
		
		[Test]
		public function testInfoWorking1():void
		{
			var mod0:DummyModuleSetStatus = new DummyModuleSetStatus(Status.COMPLETE);
			var mod1:DummyModuleSetStatus = new DummyModuleSetStatus(Status.COMPLETE);
			var mod2:DummyModuleSetStatus = new DummyModuleSetStatus(Status.RESET);
			
			var list:SLinkedList = new SLinkedList( mod0, mod1, mod2 );
			var it:Iterator = list.getIterator();
			
			Assert.assertEquals( "should be working", Status.WORKING, new StartupInfo(it).status );
		}
		
		[Test]
		public function testInfoWorking2():void
		{
			var mod0:DummyModuleSetStatus = new DummyModuleSetStatus(Status.WORKING);
			var mod1:DummyModuleSetStatus = new DummyModuleSetStatus();
			var mod2:DummyModuleSetStatus = new DummyModuleSetStatus();
			
			var list:SLinkedList = new SLinkedList( mod0, mod1, mod2 );
			var it:Iterator = list.getIterator();
			
			Assert.assertEquals( "should be working", Status.WORKING, new StartupInfo(it).status );
		}
		
		[Test]
		public function testInfoWorking3():void
		{
			var mod0:DummyModuleSetStatus = new DummyModuleSetStatus(Status.COMPLETE);
			var mod1:DummyModuleSetStatus = new DummyModuleSetStatus(Status.COMPLETE);
			var mod2:DummyModuleSetStatus = new DummyModuleSetStatus(Status.WORKING);
			
			var list:SLinkedList = new SLinkedList( mod0, mod1, mod2 );
			var it:Iterator = list.getIterator();
			
			Assert.assertEquals( "should be working", Status.WORKING, new StartupInfo(it).status );
		}
	}

}