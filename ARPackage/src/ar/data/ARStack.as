package ar.data
{
	import flash.display.BitmapData;
	import flash.utils.Dictionary;

	public class ARStack implements IStack
	{
		private static var		THIS	:ARStack = null;
		private static const	CHECKER	:Object = new Object();;
		public static function getInstance():ARStack
		{
			if (THIS == null)	THIS = new ARStack(CHECKER);
			return THIS;
		}
		
		
		
		private var _stackModelSet:Dictionary = null;
		
		public function ARStack($initObj:Object)
		{
			if ($initObj != CHECKER)
				throw new Error("Private constructor!");	
			
			_stackModelSet = new Dictionary();
		}
		
		public function makeNewStack($stackType:String, $stackID:String, $limit:int=50):void
		{
			trace("[ARStack] makeNewStack",$stackType,$stackID);
			if (_stackModelSet[$stackID] != null)
				return;
			
			var __newStackModel:IStack = null; 
			switch ($stackType)
			{
				case ARStackType.STACK_TYPE_IMAGE:
					__newStackModel = new ARImageStackModel($stackID, $limit);
					break;
			}
			
			_stackModelSet[$stackID] = __newStackModel;
		}
		public function pushImageData($stackID:String, $image_id:String, $imageData:BitmapData):void
		{
			var __modelSet:IStack = _stackModelSet[$stackID];
			trace("[ARStack] pushImageData",__modelSet);
			if (__modelSet != null)
				__modelSet.pushImageData($stackID, $image_id, $imageData);
			else
			{
				makeNewStack(ARStackType.STACK_TYPE_IMAGE,$stackID);
				pushImageData($stackID,$image_id,$imageData);
			}
		}
		public function getImageData($stackID:String, $image_id:String):BitmapData
		{
			var __modelSet:IStack = _stackModelSet[$stackID];
			if (__modelSet != null)
				return __modelSet.getImageData($stackID, $image_id);
			else
				return null;
		}
		public function clearStack($stackID:String):void
		{
			var __modelSet:IStack = _stackModelSet[$stackID];
			if (__modelSet != null)
			{
				__modelSet.clearStack($stackID);
//				delete _stackModelSet[$stackID];
			}
		}
		
		public function removeStack($stackID:String):void
		{
			var __modelSet:IStack = _stackModelSet[$stackID];
			if (__modelSet != null)
			{
				__modelSet.clearStack($stackID);
				delete _stackModelSet[$stackID];
			}
		}
	}
}

