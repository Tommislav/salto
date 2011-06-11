package se.salomonsson.salto.sequencemodule
{
	import de.polygonal.ds.Iterator;
	import de.polygonal.ds.SLinkedList;
	import de.polygonal.ds.SListIterator;
	import de.polygonal.ds.SListNode;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import se.isotop.error.BummerEvent;
	import se.salomonsson.salto.sequencemodule.Status;
	/**
	 * ...
	 * @author Tommy Salomonsson
	 */
	public class StartupSequence implements IStartupSequence
	{
		// Signals
		private var _completedSignal:Signal = new Signal();
		private var _statusSignal:Signal = new Signal();
		private var _errorSignal:Signal = new Signal();
		
		private var _sequence:SLinkedList;
		private var _iterator:Iterator;
		
		private var _currentModule:IStartupModule;
		private var _lastError:BummerEvent;
		
		
		public function StartupSequence() 
		{
			_sequence = new SLinkedList();
			_iterator = _sequence.getIterator();
		}
		
		
		
		public function addModule( m:IStartupModule ):void
		{
			_sequence.append( m );
		}
		
		
		
		/* INTERFACE se.isotop.video.startup.IStartupSequence */
		
		public function start(obj:* = null):void
		{
			_iterator = _sequence.getIterator();
			nextModule();
		}
		
		public function abort():void
		{
			var it:Iterator = _sequence.getIterator();
			while (it.hasNext())
			{
				IStartupModule(it.next()).abort();
			}
		}
		
		public function reset():void
		{
			_lastError = null;
			
			var it:Iterator = _sequence.getIterator();
			while (it.hasNext())
			{
				IStartupModule(it.next()).reset();
			}
		}
		
		public function get status():Status
		{
			return info.status;
		}
		
		public function get info():StartupInfo
		{
			return new StartupInfo( _sequence.getIterator() );
		}
		
		public function get complete():Boolean
		{
			var it:Iterator = _sequence.getIterator();
			while (it.hasNext())
			{
				if ( IStartupModule(it.next()).status != Status.COMPLETE )
					return false;
			}
			return true;
		}
		
		public function get error():BummerEvent
		{
			return _lastError;
		}
		
		public function get statusSignal():ISignal
		{
			return _statusSignal;
		}
		
		public function get completeSignal():ISignal
		{
			return _completedSignal;
		}
		
		public function get errorSignal():ISignal
		{
			return _errorSignal;
		}
		
		public function destroy():void
		{
			var it:Iterator = _sequence.getIterator();
			while (it.hasNext())
				IStartupModule(it.next()).destroy();
			
			_sequence.clear();
		}
		
		
		
		
		
		private function nextModule():void
		{
			if (_currentModule != null)
			{
				_currentModule.completeSignal.remove( moduleComplete );
				_currentModule.statusSignal.remove( onModuleStatusChange );
				_currentModule.errorSignal.remove( onModuleError );
				_currentModule = null;
			}
			
			
			var m:IStartupModule = _iterator.next() as IStartupModule;
			if ( m == null )
			{
				// we are done
				onSequenceCompleted();
				return;
			}
			
			
			if ( m.wantsToStart )
			{
				_currentModule = m;
				_currentModule.completeSignal.addOnce( moduleComplete );
				
				_currentModule.statusSignal.add( onModuleStatusChange );
				_currentModule.errorSignal.add( onModuleError );
				
				_currentModule.start();
			}
			else
			{
				nextModule();
			}
		}
		
		private function onModuleError():void
		{
			_lastError = _currentModule.error;
			_errorSignal.dispatch();
			_statusSignal.dispatch();
		}
		
		private function onModuleStatusChange():void
		{
			if (_currentModule.status == Status.SUSPENDED)
				_statusSignal.dispatch();
			
		}
		
		private function moduleComplete():void
		{
			if ( _currentModule.status == Status.COMPLETE )
				nextModule();
		}
		
		private function onSequenceCompleted():void
		{
			_statusSignal.dispatch();
			_completedSignal.dispatch();
		}
	}

}