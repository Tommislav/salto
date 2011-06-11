package unittests.se.isotop.video.startup 
{
	
	/**
	 * ...
	 * @author Tommy Salomonsson
	 */
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class StartupSequenceSuite 
	{
		public var sequenceTest:StartupSequenceTest;
		public var sequenceStatusTest:SequenceStatusTest;
		public var modelStartupSequenceIntegration:ModelStartupIntegrationTest;
		
		public function StartupSequenceSuite() 
		{
			
		}
		
	}
	
}