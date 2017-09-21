package ar.data
{
	import flash.display.BitmapData;

	public interface IStack
	{
		function pushImageData($stackID:String, $sid:String, $imageData:BitmapData):void;
		function getImageData($stackID:String, $sid:String):BitmapData;
		function clearStack($stackID:String):void;
	}
}