package ar.observer.listener
{
	import ar.observer.event.ResizeEvent;

	public interface IScreenResizeListener
	{
		function updateForResize($event:ResizeEvent):void;
	}
}