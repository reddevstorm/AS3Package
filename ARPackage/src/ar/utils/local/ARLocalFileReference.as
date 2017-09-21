package ar.utils.local
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	public class ARLocalFileReference extends FileReference
	{
		public static const IMAGE_READY	:String = "imageReady";
		
		private var isLoading:Boolean = false;
		private var loader:Loader = new Loader();
		private var	_imagesFilter		:FileFilter = new FileFilter("Images", "*.jpg;*.gif;*.png;*.jpeg;");
		private var _imageData			:BitmapData = null;
		
		public function ARLocalFileReference()
		{
			super();
			addEvent();
		}
		
		private function addEvent():void
		{
			this.addEventListener(Event.SELECT, onFileSelected);
			this.addEventListener(Event.CANCEL, onFileCancel);
			this.addEventListener(Event.COMPLETE, loadComplete);
			this.addEventListener(IOErrorEvent.IO_ERROR, onFileLoadError);
		}
		
		private function removeEvent():void
		{
			this.removeEventListener(Event.SELECT, onFileSelected);
			this.removeEventListener(Event.CANCEL, onFileCancel);
			this.removeEventListener(Event.COMPLETE, loadComplete);
			this.removeEventListener(IOErrorEvent.IO_ERROR, onFileLoadError);
		}
		
		private function onFileSelected(e:Event):void
		{
			trace("onFileSelected");
			this.load();
		}
		
		private function onFileCancel(e:Event):void 
		{
			trace("onFileCancel");
//			removeFileR();
		}
		
		private function onFileLoadError(event:Event):void
		{
			trace("onFileLoadError");
//			removeFileR();
		}
		
		private function loadComplete(e:Event):void
		{
			trace("File loaded");
			loadImageData(this["data"]);
//			removeFileR();
		}
		
		private function createFileR():void
		{
			trace("createFileR");
			
			//			_file = new FileReference();
			
			this.browse([_imagesFilter]);
		}
		
		
		
		
		
		//=======================================================================================================================================================
		//	import Image file
		//=======================================================================================================================================================
		public function importImageFile():void
		{
//			removeFileR();
			createFileR();
		}
		
		public function destroy():void
		{
			removeEvent();
			unloadImage();
			loader = null;
			imageData = null;
		}
		
		
		
		
		
		//=======================================================================================================================================================
		//	import-load Image
		//=======================================================================================================================================================
		
		private function loadImageData($data:ByteArray):void 
		{
//			initVariable();
//			pause();
//			removeImage();
			
			
			unloadImage();
			isLoading = true;
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, readyImage);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadError);
			loader.loadBytes($data);
		}
		
		private function loadError(e:IOErrorEvent):void 
		{
			unloadImage();
			trace('LOAD ERROR!!');
		}
		
		public function unloadImage():void
		{
			if (!isLoading)	return;
			isLoading = false;
			
			loader.unloadAndStop(true);
			
			if (loader.contentLoaderInfo.hasEventListener(Event.COMPLETE))
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, readyImage);
			
			if (loader.contentLoaderInfo.hasEventListener(IOErrorEvent.IO_ERROR)) 
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadError);
		}
		
		private function readyImage(e:Event):void 
		{
			isLoading = false;
			
			var bit:BitmapData = e.target.content.bitmapData;
			imageData = bit.clone();
			bit.dispose();
			
			unloadImage();
			this.dispatchEvent(new Event(ARLocalFileReference.IMAGE_READY));
		}
		
		public function get imageData():BitmapData
		{
			return _imageData;
		}
		
		public function set imageData(value:BitmapData):void
		{
			if (_imageData)
			{
				_imageData.dispose();
				_imageData = null;
			}
			_imageData = value;
		}
	}
}