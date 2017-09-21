package ar.player.observer
{
	import ar.player.event.ARVideoGNBEvent;

	public interface IARVideoGNBListener
	{
		function updateVideoGNBEvent(e:ARVideoGNBEvent):void;
	}
}