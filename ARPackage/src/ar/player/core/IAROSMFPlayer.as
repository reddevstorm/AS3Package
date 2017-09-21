package ar.player.core
{
	import flash.geom.Rectangle;

	public interface IAROSMFPlayer
	{
		function setData($url:String, $autoPlay:Boolean = false, $autoRewind:Boolean = false):void;
		function setRect($rect:Rectangle):void;
		
		function readyForReplay():void
			
		function seek($time:Number):void;
		function pauseVideo():void;
		function playVideo():void;
		function stopVideo():void;
		function controlSound($sound:Number):void;
		function controlProgress($per:Number):void;
		function resize($rect:Rectangle):void;
		function set bg($color:Number):void;
		function set bgShow($value:Boolean):void;
		function destroy():void;
		function set enableStageVideo($value:Boolean):void;
	}
}