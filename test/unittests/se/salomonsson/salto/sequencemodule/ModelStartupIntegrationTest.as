package unittests.se.isotop.video.startup 
{
	import mockobjects.MockVideoModel;
	import org.flexunit.Assert;
	import se.isotop.video.startup.StartupSequence;
	import unittests.se.isotop.video.startup.dummyModules.SyncCompleteModule;
	import unittests.se.isotop.video.startup.dummyModules.SyncErrorModule;
	import unittests.se.isotop.video.startup.dummyModules.SyncSuspendModule;
	import unittests.utils.SignalWatcher;
	/**
	 * ...
	 * @author Tommy Salomonsson
	 */
	public class ModelStartupIntegrationTest
	{
		private var _model:MockVideoModel;
		private var _seq:StartupSequence;
		private var _syncComplete0:SyncCompleteModule;
		private var _syncComplete1:SyncCompleteModule;
		private var _syncComplete2:SyncCompleteModule;
		private var _syncSuspend:SyncSuspendModule;
		private var _syncError:SyncErrorModule;
		
		
		public function ModelStartupIntegrationTest() 
		{
			
		}
		
		[Before]
		public function startup():void
		{
			_model = new MockVideoModel();
			_seq = new StartupSequence();
			
			_model.startupSequence = _seq;
			
			_syncComplete0 = new SyncCompleteModule();
			_syncComplete1 = new SyncCompleteModule();
			_syncComplete2 = new SyncCompleteModule();
			_syncSuspend = new SyncSuspendModule();
			_syncError = new SyncErrorModule();
		}
		
		[After]
		public function teardown():void
		{
			_model.startupSequence = null;
			_seq.destroy();
			_syncComplete0.destroy();
			_syncComplete1.destroy();
			_syncComplete2.destroy();
			_syncSuspend.destroy();
			_syncError.destroy();
			
			_model.destroy();
		}
		
		
		
		[Test]
		public function testModelStartOneClip():void
		{
			_seq.addModule(_syncComplete0);
			_seq.addModule(_syncComplete1);
			_seq.addModule(_syncComplete2);
			
			_model.load( "videoId_001" );
			
			Assert.assertEquals( _seq.complete, true );
		}
		
		// Test loading multiple clips
		[Test]
		public function testModelStartTwoClips():void
		{
			_seq.addModule(_syncComplete0);
			_seq.addModule(_syncComplete1);
			_seq.addModule(_syncComplete2);
			_model.load( "videoId_001" );
			
			var watcher:SignalWatcher = new SignalWatcher();
			_syncComplete0.resetSignal.add(watcher.signalCallback);
			//_syncComplete1.completeSignal.add(watcher.signalCallback);
			//_syncComplete2.completeSignal.add(watcher.signalCallback);
			
			
			_model.load( "videoId_002" );
			Assert.assertEquals( 1, watcher.count );
			
		}
		// Test error reporting
	}

}