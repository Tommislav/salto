package se.salomonsson.salto.mvc 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.getQualifiedClassName;
	import se.salomonsson.salto.ioc.IocContainer;
	/**
	 * Base for assembling the parts for the mvc application, connecting
	 * them together.
	 * @author Tommislav
	 */
	public class MvcContext 
	{
		private var _ioc:IocContainer;
		
		private var _models:Vector.<IModel>;
		private var _views:Vector.<BaseView>;
		private var _controllers:Vector.<BaseController>;
		private var _actors:Vector.<IVideoActor>;
		
		// Make sure the destroy()-method isn't called more than once
		private var _destroyed:Boolean = false;
		
		public function MvcContext() 
		{
			
		}
		
		public function getModule( stage:Stage):void
		{
			_ioc = new IocContainer();
			_models = new Vector.<IModel>();
			_views = new Vector.<BaseView>();
			_controllers = new Vector.<BaseController>();
			_actors = new Vector.<IVideoActor>();
			
			_ioc.registerInstance( Stage, stage ); // we will always need acess to the stage - e.g for listening to button clicks
			_videoModule = build( playerType );
			
			for each(var actor:IVideoActor in _actors)
				actor.startup();
			
			
			_videoModule.addEventListener( "destroy", onDestroyFromVideoModule ); // destroy-event from videoModule will destroy the entire framework!
			return _videoModule;
		}
		
		
		/**
		 * Hook to be overridden in specific builder implementations
		 * @param	playerType
		 * @return
		 */
		protected function build( playerType:PlayerType = null ):VideoModule
		{
			throw new Error("Unimplemented method getVideoModule");
			return null;
		}
		
		
		
		
		
		
		protected function addModel( model:IModel, mapToClass:Class=null ):IModel
		{
			if (mapToClass != null)
				_ioc.registerInstance( mapToClass, model );
			
			_models.push( model );
			return model;
		}
		
		protected function addView( view:BaseView, mapToClass:Class=null ):BaseView
		{
			addActor( view, mapToClass );
			_views.push( view );
			return view;
		}
		
		protected function addController( controller:BaseController, mapToClass:Class=null, ...views ):BaseController
		{
			addActor( controller, mapToClass );
			_controllers.push( controller );
			
			for each( var view:IEventDispatcher in views )
				controller.addView( view );
			
			return controller;
		}
		
		protected function addActor( actor:IVideoActor, mapToClass:Class = null ):IVideoActor
		{
			if (mapToClass != null)
				_ioc.registerInstance( mapToClass, actor );
			
			actor.setupIoc( _ioc );
			_actors.push( actor );
			return actor;
		}
		
		private function registerInstanceToIoc( instance:*, mapToClass:Class = null ):void
		{
			if (mapToClass != null)
			{
				_ioc.registerInstance( mapToClass, instance );
			}
			else
			{
				var desc:String = getQualifiedClassName(instance);
				_ioc.registerInstanceFromString( desc, instance );
			}
		}
		
		
		
		
		
		public function destroy():void
		{
			if (!_destroyed)
			{
				_destroyed = true;
				_videoModule.removeEventListener( "destroy", onDestroyFromVideoModule );
				
				for each ( var actor:IVideoActor in _actors )
					actor.destroy();
				
				for each( var m:IModel in _models )
					m.destroy();
				
				_actors = null;
				_views = null;
				_controllers = null;
				_models = null;
				
				_ioc.destroy();
				_ioc = null;
			}
		}
	}
}