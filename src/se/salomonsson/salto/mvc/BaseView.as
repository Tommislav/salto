package se.salomonsson.salto.mvc
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import se.salomonsson.salto.dim.IDimension;
	import se.salomonsson.salto.dim.IRedimable;
	import se.salomonsson.salto.ioc.IocContainer;
	
	/**
	 * Base class for views.
	 * 
	 * Dispatch events to be catched through the dispatch-method
	 * Fetch references to classes/instances (like models) through the resolveInstance-method
	 * the onReady-method will be called once the ioc is properly set.
	 * 
	 * Nest one view within another using view.nestView(otherView) - will inherit dispatcher and ioc-container
	 * 
	 * override the onResize-method to re-layout your view.
	 * 
	 * @author Tommislav
	 */
	public class BaseView extends Sprite implements IActor, IRedimable
	{
		protected var _dim:IDimension;
		
		private var _dispatcher:IEventDispatcher;
		
		private var _nestedViews:Vector.<BaseView> = new Vector.<BaseView>();
		private var _ioc:IocContainer;
		
		public function BaseView() 
		{
			
		}
		
		// IocContainer has been initialized, it is now safe to initialize view
		protected function startup():void {}
		
		// Resolve instances from the Inversion-Of-Control container, a good place to get references to the models
		public final function resolve( classReference:Class ):*	{	return _ioc.resolve( classReference );	}
		
		// Dispatch view-events that should be catched by the controllers
		public final function dispatchViewEvent( e:Event ):void
		{
			var d:IEventDispatcher = (_dispatcher == null) ? this : _dispatcher;
			d.dispatchEvent( e );
		}
		
		/* INTERFACE iso.media.video.views.IReDimable */
		
		public function setDim(dim:IDimension):void 
		{
			if ( _dim != null )
				_dim.onResized.remove( onResize );
			
			_dim = newDim;
			
			if ( _dim != null )
			{
				_dim.onResized.add( onResize );
				onResize( _dim ); // Resize right away
			}
			
			for each( var nested:BaseView in _nestedViews )
				nested.setDimensionObject( newDim );
		}
		
		protected function onResize( d:IDimension ):void
		{
			// ...
		}
		
		
		public function destroy():void
		{
			setDimensionObject( null ); // remove references to dimension object
			_dispatcher = null;
			_ioc = null;
			dispatchEvent( new Event( "destroy" ) );
		}
		
		
		
		protected function onNestedViewAdded( view:BaseView ):void {}
		protected function onNestedViewRemoved( view:BaseView ):void {}
		
		
		
		public final function nestView( view:BaseView, dim:IDimension=null, dispatcher:IEventDispatcher=null ):void
		{
			var d:IDimension = (dim = null) ? _dim : dim;
			
			if (dispatcher == null)
				dispatcher = ( _dispatcher == null ) ? this : _dispatcher;
			
			view._dispatcher = dispatcher;
			view.setDimensionObject( d );
			view.addEventListener( "destroy", onNestedViewDestroyEvent );
			
			if ( _ioc != null )
				view.registerIOC( _ioc );
			
			_nestedViews.push( view );
			addChild( view );
			onNestedViewAdded( view );
		}
		
		
		
		private function onNestedViewDestroyEvent(e:Event):void 
		{
			var view:BaseView = e.target as BaseView;
			removeNestedView( view );
		}
		
		public function removeNestedView( view:BaseView ):void
		{
			view.removeEventListener( "destroy", onNestedViewDestroyEvent );
			
			if ( view.parent == this )
				removeChild( view );
			
			var index:int = _nestedViews.indexOf(view)
			if ( index > -1 )
				_nestedViews.splice( index, 1 );
			
			view.destroy();
			
			onNestedViewRemoved( view );
		}
		
		
		public final function setupIoc( ioc:IocContainer ):void
		{
			if ( _ioc != null )
				return; // Should we be able to swap ioc??? probably not!
			
			_ioc = ioc;
			
			for each (var view:BaseView in _nestedViews)
				view.registerIOC( _ioc );
		}
		
		public final function setViewDispatcher( dispatcher:IEventDispatcher ):void
		{
			_dispatcher = dispatcher;
		}
	}

}