package ar.view
{
	import flash.geom.Point;
	import flash.display.Graphics;
	import flash.display.BitmapData;

	public interface IDistortImage
	{
		function drawPlane(graphics:Graphics, bitmap:BitmapData, points:Vector.<Point>) : void;
	}
}