package se.salomonsson.salto.mvc
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import se.salomonsson.salto.ioc.IocContainer;
	/**
	 * BaseController class. Subclass and override onViewAdded and onViewRemoved.
	 * @author Tommislav
	 */
	public class BaseController implements IActor
	{
		private var _views:Vector.<IEventDispatcher> = new Vector.<IEventDispatcher>();
		private var _ioc:IocContainer;
		
		public function BaseController() 
		{
			
		}
		
		// IocContainer is initialized, it is now safe to initialize ourselves
		protected function startup():void {}
		
		// Add your custom listeners here
		protected function onViewAdded( view:IEventDispatcher ):void { }
		
		// Remove your custom listeners here
		protected function onViewRemoved( view:IEventDispatcher ):void { }
		
		// Resolve instances from the Inversion-Of-Control container, a good place to get references to the models
		public final function resolveInstance( classReference:Class ):*	{	return _ioc.resolve( classReference );	} 
		
		
		// ###################################################################
		
		public final function setupIoc( ioc:IocContainer ):void
		{
			_ioc = ioc;
		}
		
		
		public final function addView( view:IEventDispatcher ):void
		{
			_views.push( view );
			view.addEventListener( "destroy", onViewDestroyed );
			
			onViewAdded( view );
		}
		
		public final function removeView( view:IEventDispatcher ):void
		{
			var index:int = _views.indexOf( view );
			if (index > -1)
			{
				_views.splice( index, 1 );
				view.removeEventListener( "destroy", onViewDestroyed );
				
				onViewRemoved( view );
			}
		}
		
		private function onViewDestroyed( e:Event ):void
		{
			var view:IEventDispatcher = e.target as IEventDispatcher;
			if (view)
				removeView( view );
		}
		
		public final function destroy():void
		{
			var copy:Vector.<IEventDispatcher> = _views.slice();
			for each ( var view:IEventDispatcher in copy )
			{
				removeView( view );
			}
			_ioc = null;
		}
		
	}

}