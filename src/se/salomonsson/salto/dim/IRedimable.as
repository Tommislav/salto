package se.salomonsson.salto.dim 
{
	
	/**
	 * Visual object that can swap dimension-objects runtime
	 * @author Tommy Salomonsson
	 */
	public interface IRedimable 
	{
		function setDim( dim:IDimension ):void;
	}
	
}