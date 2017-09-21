package ar.observer.listener
{
	import ar.observer.event.PopupEvent;

	public interface IPopupEventListener
	{
		function listenPopupEvent($event:PopupEvent):void;
	}
}