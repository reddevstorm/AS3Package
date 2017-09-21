package ar.player.core
{
	import flash.geom.Rectangle;

	public interface IARSeekBar extends IMouseObject
	{
		function initialize():void;
		function set lock($isLock:Boolean):void;
		function pause():void;
		function resume():void;
//		function syncTime($currentSecond:Number, $totalSecond:Number):void;
		function syncProgress($percent:Number, $cureentSecond:Number =0, $totalSecond:Number =0):void;
		function syncBuffer($percent:Number):void;
		function resize($rect:Rectangle, $isLimitSize:Boolean=false):void;
		function destroy():void;
		
//		function show():void;
//		function hide():void;
	}
}