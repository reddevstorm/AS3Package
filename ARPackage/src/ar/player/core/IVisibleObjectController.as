package ar.player.core
{
	import flash.geom.Rectangle;

	public interface IVisibleObjectController
	{
		function startTimer():void;
		function resize($rect:Rectangle):void;
		function show():void;
		function pushMouseObj($obj:IMouseObject):void;
		function destroy():void;
	}
}