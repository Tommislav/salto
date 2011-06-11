package se.salomonsson.salto.mvc
{
	import se.salomonsson.salto.asbinding.IBindable;
	
	/**
	 * Marker interface for models. Models should be bindable and destroyable.
	 * @author Tommislav
	 */
	public interface IModel extends IBindable
	{
		function destroy():void;
	}
	
}