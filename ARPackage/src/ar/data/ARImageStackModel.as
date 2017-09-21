package ar.data
{
	import flash.display.BitmapData;
	import flash.utils.Dictionary;

	public class ARImageStackModel implements IStack
	{
		private var _imageType	:String = "";
		private var _stackLimit	:int = 50;
		public	var ids			:Vector.<String> = null;
		public	var imageSet	:Dictionary = null;
		
		public function ARImageStackModel($stackID:String, $stackLimit:int = 50)
		{
			_imageType = $stackID;
			_stackLimit = $stackLimit;
			ids = new Vector.<String>();
			imageSet = new Dictionary();
		}
		
		public function pushImageData($stackID:String, $sid:String, $imageData:BitmapData):void
		{
			if (imageSet[$sid] != null)
				updateImageData($sid, $imageData);
			else
			{
				ids.push($sid);
				imageSet[$sid] = $imageData;
				checkLimit();
			}
		}
		public function getImageData($stackID:String, $sid:String):BitmapData
		{
			if (imageSet[$sid])	return (imageSet[$sid] as BitmapData).clone();
			return null;
		}
		public function clearStack($stackID:String):void
		{
			var __len:int = ids.length;
			for (var i:int = 0; i<__len ; i++)
			{
				var __id:String = ids[i];
				(imageSet[__id] as BitmapData).dispose();
				delete imageSet[__id];
				ids[i] = null;
			}
			imageSet = new Dictionary();
			ids = new Vector.<String>();
		}
		protected function updateImageData($sid:String, $imageData:BitmapData):void
		{
			(imageSet[$sid] as BitmapData).dispose();
			delete imageSet[$sid];
			imageSet[$sid] = $imageData;
			
			var __len:int = ids.length;
			for (var i:int=0; i<__len; i++)
			{
				if (ids[i] == $sid)
				{
					ids.splice(i,1);
					ids.push($sid);
				}
			}
		}
		protected function checkLimit():void
		{
			if (ids.length > _stackLimit)
			{
				var __removeId:String = ids.shift();
				(imageSet[__removeId] as BitmapData).dispose();
				delete imageSet[__removeId];
				checkLimit();
			}
		}
	}
}
