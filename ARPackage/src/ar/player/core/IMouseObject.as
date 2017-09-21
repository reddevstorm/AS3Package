package ar.player.core
{
	import flash.geom.Point;

	public interface IMouseObject
	{
		function hitTestObj($point:Point):Boolean;
		function show():void;
		function hide():void;
	}
}