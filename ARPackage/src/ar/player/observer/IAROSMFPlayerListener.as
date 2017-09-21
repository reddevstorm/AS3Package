package ar.player.observer
{
	import ar.player.event.AROSMFPlayEvent;

	public interface IAROSMFPlayerListener
	{
		function updatePlayerEvent(e:AROSMFPlayEvent):void;
	}
}