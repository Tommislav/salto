package se.salomonsson.salto.utils 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * Executes a method after a certain amount of time
	 * @author Tommy Salomonsson
	 */
	public class Delay {
		
		private var _timer:Timer;
		private var _delay:int;
		private var _callback:Function;
		private var _args:Array;
		private var _weakRef:Boolean;
		
		
		public function Delay() {
			
		}
		
		public function get isRunning():Boolean
		{
			if ( _timer != null )
			{
				if ( _timer.running )
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Set delay and callback. Will execute automatically.
		 * @param	delay
		 * @param	callback
		 * @param	useWeakReference	will clear references to callback once executed
		 */
		public function delayCallback( delay:int, callback:Function, args:Array=null, useWeakReference:Boolean=true ):void
		{
			setDelay( delay, callback, args, useWeakReference );
			execute();
		}
		
		/**
		 * only set the values, call execute manually to start.
		 * @param	delay
		 * @param	callback
		 */
		public function setDelay( delay:int, callback:Function, args:Array=null, useWeakReference:Boolean=true ):void
		{
			_delay = delay;
			_callback = callback;
			_args = args;
			_weakRef = useWeakReference;
		}
		
		/**
		 * Starts a delayed callback
		 */
		public function execute():void
		{
			if ( _callback == null )
			{
				throw new Error( "Error calling delayed execute without a callback function" );
			}
			buildTimer();
			_timer.delay = _delay;
			_timer.start();
		}
		
		/**
		 * Aborts a running delay call. Won't clear the data.
		 */
		public function abort():void
		{
			if ( isRunning )
			{
				_timer.stop();
			}
		}
		
		/**
		 * Destroys timer instances and 
		 */
		public function destroy():void
		{
			removeTimer();
			_callback = null;
			_args = null;
		}
		
		
		
		//////
		
		
		
		private function buildTimer():void
		{
			if ( _timer == null )
			{
				_timer = new Timer( 0 );
				_timer.addEventListener( TimerEvent.TIMER_COMPLETE, onTimer );
				_timer.addEventListener( TimerEvent.TIMER, onTimer );
			}
			else
			{
				_timer.stop();
				_timer.reset();
			}
		}
		
		private function onTimer( e:TimerEvent ):void
		{
			trace( "Delay.onTimer: " + _callback + ", " + _args );
			_callback.apply( this, _args );
			removeTimer();
			
			if ( _weakRef )
			{
				_callback = null;
				_args = null;
			}
		}
		
		private function removeTimer():void
		{
			if ( _timer != null )
			{
				_timer.stop();
				_timer.removeEventListener( TimerEvent.TIMER_COMPLETE, onTimer );
				_timer = null;
			}
		}
	}
	
}