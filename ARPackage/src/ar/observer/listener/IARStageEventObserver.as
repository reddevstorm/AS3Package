package ar.observer.listener
{
	import ar.observer.event.ARStageEvent;

	public interface IARStageEventObserver
	{
		function updateEvent($event:ARStageEvent):void;
	}
}