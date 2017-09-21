package ar.player.observer
{
	import ar.player.event.ARSeekbarEvent;

	public interface IARSeekBarListener
	{
		function updateSeekbarEvent(e:ARSeekbarEvent):void;
	}
}