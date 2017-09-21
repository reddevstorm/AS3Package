package ar.utils.string
{
	import flash.events.*;
	import flash.net.*;
	import flash.net.URLVariables;
	
	public class ARTinyURL extends EventDispatcher
	{
		public function ARTinyURL()
		{
		}
		
		public function sendAndLoad( url:String ):void {
			
			var variables:URLVariables = new URLVariables();
			variables.url = String(url);
			
			var request:URLRequest = new URLRequest("http://tinyurl.com/api-create.php");
			var _urlloader:URLLoader = new URLLoader();
			_urlloader.dataFormat = URLLoaderDataFormat.TEXT;
			request.data = variables;
			request.method = URLRequestMethod.POST;
			_urlloader.addEventListener(Event.COMPLETE, handleComplete);
			_urlloader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_urlloader.load(request);
			
		}
		private function handleComplete(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
//			Debug.alert("TinyURL: " + loader.data);
			this.dispatchEvent(new ARTinyURLEvent(ARTinyURLEvent.SUCCESS, loader.data));
		}
		private function onIOError(event:IOErrorEvent):void {
//			Debug.alert("Error loading URL.");
			this.dispatchEvent(new ARTinyURLEvent(ARTinyURLEvent.FAIL));
		}
	}
}

