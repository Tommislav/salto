package se.salomonsson.salto.sequencemodule 
{
	import org.osflash.signals.Signal;
	import org.osflash.signals.ISignal;
	import se.salomonsson.salto.sequencemodule.Status;
	/**
	 * This is a good class to use as a base for your own startup modules!
	 * @author Tommy Salomonsson
	 */
	public class BaseStartupModule implements IStartupModule
	{
		protected const _log:Logger = LoggerFactory.getLogger(this);
		
		private var _completeSignal:Signal = new Signal();
		
		private var _statusSignal:Signal = new Signal();
		private var _status:Status;
		
		private var _errorSignal:Signal = new Signal();
		private var _error:BummerEvent;
		
		private var _name:String;
		
		public function BaseStartupModule( name:String ) 
		{
			_name = name;
		}
		
		
		/* INTERFACE se.isotop.video.startup.IStartupModule */
		
		public function get wantsToStart():Boolean	{	return (_status != Status.COMPLETE);	}
		
		public function start():void
		{
			_log.info("startup [" + _name + "] started");
			setStatus( Status.WORKING );
		}
		
		public function get completeSignal():ISignal	{	return _completeSignal;		}
		public function get statusSignal():ISignal		{	return _statusSignal;		}
		public function get status():Status				{	return _status;				}
		public function get errorSignal():ISignal		{	return _errorSignal;		}
		public function get error():BummerEvent			{	return _error;				}
		
		protected function setStatus( newStatus:Status ):void
		{
			if ( newStatus != _status )
			{
				_status = newStatus;
				_statusSignal.dispatch();
			}
		}
		
		protected function onError( e:BummerEvent ):void
		{
			_error = e;
			setStatus( Status.ERROR );
			_errorSignal.dispatch();
		}
		
		
		public function abort():void
		{
			reset();
		}
		
		public function reset():void
		{
			var wasRunning:Boolean = (_status == Status.WORKING);
			setStatus( Status.RESET );
			
			if (wasRunning)
				dispatchCompleted();
		}
		
		protected function onCompleted():void
		{
			_log.info("startup [" + _name + "] completed");
			setStatus( Status.COMPLETE );
			dispatchCompleted();
		}
		
		protected function onSuspended():void
		{
			_log.info("startup [" + _name + "] suspended");
			setStatus( Status.SUSPENDED );
			dispatchCompleted();
		}
		
		protected function dispatchCompleted():void
		{
			_completeSignal.dispatch();
		}
		
		
		
		
		
		
		public function debug():String
		{
			return "[StartupModule [" + _name + "]]";
		}
		
		public function destroy():void
		{
			_completeSignal.removeAll();
			_statusSignal.removeAll();
			_errorSignal.removeAll();
		}
	}

}