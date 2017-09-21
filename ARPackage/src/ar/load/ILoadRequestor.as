package ar.load
{
	import com.greensock.events.LoaderEvent;

	public interface ILoadRequestor
	{
		function onLoadInit($e:LoaderEvent):void;
		function onLoadProgress($e:LoaderEvent):void;
		function onLoadComplete($e:LoaderEvent):void;
		function get url():String;
		function get name():String;
		function get autoPlay():Boolean;
	}
}