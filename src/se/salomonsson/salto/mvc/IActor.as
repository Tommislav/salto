package se.salomonsson.salto.mvc
{
	import se.salomonsson.salto.ioc.IocContainer;
	
	/**
	 * Base actor for ioc framework, both views and controllers implement this.
	 * Startup() will be called after the ioc has been fully initialized
	 * @author Tommislav
	 */
	public interface IActor 
	{
		function setupIoc(ioc:IocContainer):void;
		function startup():void;
		function destroy():void;
	}
	
}