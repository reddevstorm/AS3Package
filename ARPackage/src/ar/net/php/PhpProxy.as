package ar.net.php
{
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class PhpProxy extends Sprite
	{
		private static var		THIS	:PhpProxy = null;
		private static const	CHECKER	:Object = new Object();;
		public static function getInstance():PhpProxy
		{
			if (THIS == null)	THIS = new PhpProxy(CHECKER);
			return THIS;
		}	
		
		public function PhpProxy($initObj:Object)
		{
			if ($initObj != CHECKER)
				throw new Error("Private constructor!");
		}
		
		public function sendData($url:String, $vars:URLVariables):void
		{
			var _loader:URLLoader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			var _request:URLRequest = new URLRequest($url);
			
			_request.data = $vars;
			_request.method = URLRequestMethod.POST;
			
			addConfig(_loader);
			_loader.load(_request);
		}
		
		private function addConfig($eventDispatcher:IEventDispatcher):void
		{
			$eventDispatcher.addEventListener(Event.COMPLETE, onComplete);
			$eventDispatcher.addEventListener(IOErrorEvent.IO_ERROR, onError);
			$eventDispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
		}
		
		private function removeConfig($eventDispatcher:IEventDispatcher, $single:Boolean=true):void
		{
			$eventDispatcher.removeEventListener(Event.COMPLETE, onComplete);
			$eventDispatcher.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			$eventDispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			$eventDispatcher = null;
		}
		
		private function onComplete(e:Event):void 
		{
			removeConfig(e.currentTarget as IEventDispatcher);
			
			
			try{
				var _vars:URLVariables = new URLVariables(e.target.data);
				if (_vars.success == "1" || _vars.success == 1 || _vars.success == true || _vars.success == "true" )
				{
					this.dispatchEvent(new PhpProxyEvent(PhpProxyEvent.COMPLETE, _vars.success, _vars));
				}
				else
				{
					this.dispatchEvent(new PhpProxyEvent(PhpProxyEvent.ERROR, _vars.msg));
				}
			}catch(error:Error){
				var jsonData:Object = JSON.parse(e.target.data);
				for (var i:String in jsonData)
				{
					trace(i + ": " + jsonData[i]);
				}
				if (jsonData.success == "1" || jsonData.success == 1 || jsonData.success == true || jsonData.success == "true" )
				{
					this.dispatchEvent(new PhpProxyEvent(PhpProxyEvent.COMPLETE, jsonData.success, null, jsonData));
				}
				else
				{
					this.dispatchEvent(new PhpProxyEvent(PhpProxyEvent.ERROR, jsonData.msg));
				}
			}
			
			
		}
		
		private function onError(e:IOErrorEvent):void 
		{
			//			Debug.alert(e);
			removeConfig(e.currentTarget as IEventDispatcher);
			this.dispatchEvent(new PhpProxyEvent(PhpProxyEvent.ERROR, e.text));
		}
	}
}