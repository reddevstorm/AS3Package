package ar.utils.file
{
	import ar.adobe.images.JPGEncoder;
	import ar.adobe.images.PNGEncoder;
	
	import com.greensock.easing.Back;
	
	import flash.display.BitmapData;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	public class ARImageUploader extends EventDispatcher
	{
//		private var uploadPath:String = MainData.URL_ROOT_EC + "simpleUpload.php";
		private var localPath:String = null;
		private var datas:Array = new Array();
		private var queryData:Array = new Array();
		private var total:int = 0;
		private var current:int = 0;
		private var _failSave	:Boolean = true;
		
		public function ARImageUploader($phpPath:String)
		{
			localPath = $phpPath;
		}
		
		public function quer(...rest):void
		{
			_failSave = true;
			if (queryData.length > 0)
			{
				queryData.length = 0;
				datas.length = 0;
				datas = null;
			}
			datas = rest;
			
			total = rest.length;
			if (total % 2 > 0) {
				this.dispatchEvent(new ARUploadEvent(ARUploadEvent.ERROR));
				return;
			}
			var str:String;
			var bit:BitmapData;
			var id:int = 0;
			for (var i:uint = 0; i < total; i++ )
			{
				
				if (i % 2 > 0)
				{
					bit = datas[i];
					id = Math.ceil(i / 2);
					uploadImage(str, bit, false);
					queryData[id] = {name:str, bit:bit, loader:null}
				}else {
					str = datas[i];
				}
			}
			
		}
		
		public function uploadImage($fileName:String, $bitmapData:BitmapData, $single:Boolean=true, $param:URLVariables=null):void
		{
			var urlLoader:URLLoader;
//			var bytes:ByteArray = PNGEncoder.encode($bitmapData);
			
			var encoder:JPGEncoder = new JPGEncoder(100);
			var bytes:ByteArray = encoder.encode($bitmapData);
			var parameters:URLVariables = $param;
			var urlRequest:URLRequest = new URLRequest();
			
			urlRequest.url = localPath;
//			urlRequest.url = "http://innored168.aiyonet.com/cdn/imageUpload_test.php";
			urlRequest.contentType = 'multipart/form-data; boundary=' + ARUploadHelper.getBoundary();
			urlRequest.method = URLRequestMethod.POST;
			
			urlRequest.data = ARUploadHelper.getPostData($fileName+".jpg", bytes, parameters);
			urlRequest.requestHeaders.push( new URLRequestHeader( 'Cache-Control', 'no-cache' ) );
			urlRequest.requestHeaders.push( new URLRequestHeader( 'Content-Type', 'multipart/form-data; boundary=' +ARUploadHelper.getBoundary()) );
			
			urlLoader = new URLLoader();
			addConfigSingle(urlLoader);
			
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.load(urlRequest);
		}
		
		private function addConfigSingle($eventDispatcher:IEventDispatcher):void
		{
			$eventDispatcher.addEventListener(Event.COMPLETE, onCompleteSingle);
			$eventDispatcher.addEventListener(IOErrorEvent.IO_ERROR, onErrorSingle);
			$eventDispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorSingle);
		}
		
		private function onCompleteSingle(e:Event):void 
		{
			removeConfigSingle(e.currentTarget as IEventDispatcher);
			
			try{
				var _vars:URLVariables = new URLVariables(String(e.target.data));
				if (_vars.success == "1" || _vars.success == 1 || _vars.success == true || _vars.success == "true" )
				{
					this.dispatchEvent(new ARUploadEvent(ARUploadEvent.COMPLETE, _vars.success, _vars));
				}
				else
				{
					this.dispatchEvent(new ARUploadEvent(ARUploadEvent.ERROR, _vars.success));
				}
			}catch(error:Error){
				var jsonData:Object = JSON.parse(String(e.target.data));
				for (var i:String in jsonData)
				{
					trace(i + ": " + jsonData[i]);
				}
				if (jsonData.success == "1" || jsonData.success == 1 || jsonData.success == true || jsonData.success == "true" )
				{
					this.dispatchEvent(new ARUploadEvent(ARUploadEvent.COMPLETE, jsonData.success, null, jsonData));
				}
				else
				{
					this.dispatchEvent(new ARUploadEvent(ARUploadEvent.ERROR, jsonData.success));
				}
			}
			
			
		}
		
		private function onErrorSingle(e:ErrorEvent):void 
		{
			//			Debug.alert(e);
			removeConfigSingle(e.currentTarget as IEventDispatcher);
			this.dispatchEvent(new ARUploadEvent(ARUploadEvent.ERROR, e.text));
		}
		
		private function removeConfigSingle($eventDispatcher:IEventDispatcher, $single:Boolean=true):void
		{
			$eventDispatcher.removeEventListener(Event.COMPLETE, onCompleteSingle);
			$eventDispatcher.removeEventListener(IOErrorEvent.IO_ERROR, onErrorSingle);
			$eventDispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorSingle);
			$eventDispatcher = null;
		}
		
		
		
		
		
		
		
		private function addConfigMultiple($eventDispatcher:IEventDispatcher):void
		{
			$eventDispatcher.addEventListener(Event.COMPLETE, onCompleteMultiple);
			$eventDispatcher.addEventListener(IOErrorEvent.IO_ERROR, onErrorMultiple);
			$eventDispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorMultiple);
		}
		
		private function onCompleteMultiple(e:Event):void 
		{
			var _vars:URLVariables = new URLVariables(e.target.data);
			if (_vars.success == "1" || _vars.success == 1 || _vars.success == true || _vars.success == "true" )
				_failSave = false;
			
//			Debug.error("_vars.success " + String(_vars.success));
			
			removeConfigMultiple(e.currentTarget as IEventDispatcher, false);
			current++;
//			Debug.alert("upload done : ", current, total/2, current == total/2, typeof(current), typeof(total/2));
			if (current == total / 2) {
//				Debug.alert("[ImageMaker] onComplete2");
				if (!_failSave)
					this.dispatchEvent(new ARUploadEvent(ARUploadEvent.COMPLETE, _vars.success, _vars));
				else
					this.dispatchEvent(new ARUploadEvent(ARUploadEvent.ERROR, _vars.success));
			}
		}
		
		private function removeConfigMultiple($eventDispatcher:IEventDispatcher, $single:Boolean=true):void
		{
			$eventDispatcher.removeEventListener(Event.COMPLETE, onCompleteMultiple);
			$eventDispatcher.removeEventListener(IOErrorEvent.IO_ERROR, onErrorMultiple);
			$eventDispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorMultiple);
			$eventDispatcher = null;
		}
		
		private function onErrorMultiple(e:ErrorEvent):void 
		{
//			Debug.alert(e);
			removeConfigMultiple(e.currentTarget as IEventDispatcher);
			this.dispatchEvent(new ARUploadEvent(ARUploadEvent.ERROR, e.text));
		}
		
	}
}