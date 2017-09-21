package ar.observer.listener
{
	import ar.observer.event.PageEvent;

	public interface IPageEventListener
	{
		function nextPage($event:PageEvent):void;
		function prevPage($event:PageEvent):void;
	}
}