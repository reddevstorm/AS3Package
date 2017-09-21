package ar.observer.listener
{
	import ar.observer.event.ARSimpleObserverEvent;
	
	public interface IARSimpleObserver
	{
		function updateEvent($event:ARSimpleObserverEvent):void;
	}
}