package unittests.se.isotop.video.startup.dummyModules 
{
	import iso.media.video.error.ErrorCategory;
	import iso.media.video.error.ErrorCode;
	import se.isotop.error.BummerEvent;
	import se.isotop.error.Severity;
	import se.isotop.video.startup.BaseStartupModule;
	
	/**
	 * ...
	 * @author Tommy Salomonsson
	 */
	public class SyncErrorModule extends BaseStartupModule
	{
		public var reportError:Boolean = true;
		public var errorIsFatal:Boolean = true;
		
		public function SyncErrorModule() 
		{
			super("SyncErrorModule");
		}
		
		override public function start():void 
		{
			super.start();
			
			if (reportError)
			{
				var severity:String = (errorIsFatal) ? Severity.FATAL : Severity.WARN;
				onError( new BummerEvent( BummerEvent.ERROR, ErrorCode.DUMMY, "Dummy error", ErrorCategory.DUMMY, severity ) );
			}
			else
			{
				onCompleted();
			}
		}
	}

}