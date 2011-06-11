package unittests.se.isotop.video.startup 
{
	import org.flexunit.Assert;
	import se.isotop.video.startup.StartupSequence;
	import se.isotop.video.startup.Status;
	import unittests.se.isotop.video.startup.dummyModules.NoNeedToStartModule;
	import unittests.se.isotop.video.startup.dummyModules.SyncCompleteModule;
	import unittests.se.isotop.video.startup.dummyModules.SyncErrorModule;
	import unittests.se.isotop.video.startup.dummyModules.SyncSuspendModule;
	import unittests.utils.SignalWatcher;
	/**
	 * Test the class that links the modules together
	 * @author Tommy Salomonsson
	 */
	public class StartupSequenceTest
	{
		
		public function StartupSequenceTest() 
		{
			
		}
		
		[Test]
		public function testSingleSyncedModuleSequence():void
		{
			var seq:StartupSequence = new StartupSequence();
			seq.addModule( new SyncCompleteModule() );
			seq.start();
			
			Assert.assertEquals( "Sequence completed", true, seq.complete );
		}
		
		[Test]
		public function testTwoSyncedModulesSequence():void
		{
			var seq:StartupSequence = new StartupSequence();
			seq.addModule( new SyncCompleteModule() );
			seq.addModule( new SyncCompleteModule() );
			seq.start();
			
			Assert.assertEquals( "Sequence completed", true, seq.complete );
		}
		
		[Test]
		public function testSuspendModuleSequence():void
		{
			var seq:StartupSequence = new StartupSequence();
			seq.addModule( new SyncSuspendModule() );
			seq.start();
			
			Assert.assertEquals( "Sequence is in suspended mode, NOT complete", false, seq.complete );
			Assert.assertEquals( "State is 'suspended'", Status.SUSPENDED, seq.status );
		}
		
		[Test]
		public function testRunSequenceTwice():void
		{
			var seq:StartupSequence = new StartupSequence();
			seq.addModule( new SyncCompleteModule() );
			seq.addModule( new SyncCompleteModule() );
			seq.start();
			
			Assert.assertEquals("Seq 1 completed", true, seq.complete);
			
			seq.reset();
			Assert.assertEquals( "seq 1 reseted", false, seq.complete);
			
			seq.start();
			Assert.assertEquals( "seq 2 completed", true, seq.complete );
		}
		
		
		[Test]
		public function testSuspendResumeSequence():void
		{
			var suspendWatch:SignalWatcher = new SignalWatcher();
			
			var susp:SyncSuspendModule = new SyncSuspendModule();
			
			var seq:StartupSequence = new StartupSequence();
			seq.addModule( new SyncCompleteModule() );
			seq.addModule( susp );
			seq.addModule( new SyncCompleteModule() );
			
			seq.statusSignal.add( suspendWatch.signalCallback );
			
			seq.start();
			
			Assert.assertEquals( "Sequence not completed", false, seq.complete );
			Assert.assertEquals( "State is 'suspended'", Status.SUSPENDED, seq.status );
			Assert.assertEquals( "suspend calls", 1, suspendWatch.count );
			
			// Resolve suspended module
			susp.autoSuspend = false;
			// Carrie on
			seq.start();
			
			Assert.assertEquals( "sequence.complete " + seq.info.visualDebug, true, seq.complete );
			Assert.assertEquals( "State is 'complete' " + seq.info.visualDebug, Status.COMPLETE, seq.status );
		}
		
		[Test]
		public function testSequenceWithFatalError():void
		{
			var err:SyncErrorModule = new SyncErrorModule();
			
			var errorWatch:SignalWatcher = new SignalWatcher();
			err.errorSignal.add(errorWatch.signalCallback);
			
			var seq:StartupSequence = new StartupSequence();
			seq.addModule( new SyncCompleteModule() );
			seq.addModule( err );
			seq.addModule( new SyncCompleteModule() );
			seq.start();
			
			Assert.assertEquals( "Sequence not completed", false, seq.complete );
			Assert.assertEquals( "Error count", 1, errorWatch.count );
			Assert.assertEquals( "Sequence status is error", Status.ERROR, seq.status );
			
			seq.start();
			Assert.assertEquals( "error count 2", 2, errorWatch.count );
			Assert.assertEquals( "Still error", Status.ERROR, seq.status );
			
			err.reportError = false;
			seq.start();
			
			Assert.assertEquals( "Sequence completed", true, seq.complete );
			Assert.assertEquals( "error count 2", 2, errorWatch.count );
		}
		
		[Test]
		public function testCompleteStatusOnModulesThatDontNeedToRun():void
		{
			// If a module report "needsToRun() == false" then the sequence should still report complete
			
			var mod0:SyncCompleteModule = new SyncCompleteModule();
			var mod1:NoNeedToStartModule= new NoNeedToStartModule();
			var mod2:SyncCompleteModule = new SyncCompleteModule();
			
			var seq:StartupSequence = new StartupSequence();
			seq.addModule(mod0);
			seq.addModule(mod1);
			seq.addModule(mod2);
			seq.start();
			
			Assert.assertEquals( "Should report complete", Status.COMPLETE, seq.info.status );
		}
	}

}