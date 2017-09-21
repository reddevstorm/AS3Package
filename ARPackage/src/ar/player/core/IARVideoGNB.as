package ar.player.core
{
	import flash.geom.Rectangle;

	public interface IARVideoGNB extends IMouseObject
	{
		function initialize():void;
		function set lock($isLock:Boolean):void;
		function pause():void;
		function resume():void;
		function buffer($isShow:Boolean):void;
		function resize($rect:Rectangle):void;
		function destroy():void;
		
//		function show():void;
//		function hide():void;
	}
}