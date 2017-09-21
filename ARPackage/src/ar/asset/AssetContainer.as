package ar.asset
{
	
	import ar.load.ILoadRequestor;
	
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.SWFLoader;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.EventDispatcher;
	
	public class AssetContainer extends EventDispatcher implements ILoadRequestor
	{
		private var _source	:SWFLoader 	= null;
		
		public function AssetContainer()
		{
			
		}
		
		
		
		
		//========================================================================
		// get library Object Method.
		//========================================================================
		
		public function makeDisplayObjectContainer($name:String):DisplayObjectContainer
		{
			var __class	:Class 					= this.getClass($name);
			var __mc	:DisplayObjectContainer = new __class();
			__mc.name = $name;
			//			(__mc as MovieClip).stop();
			return __mc;
		}
		
		public function makeMc($name:String):MovieClip
		{
			var __class	:Class 					= this.getClass($name);
			var __mc	:MovieClip				= new __class();
			__mc.name = $name;
			__mc.stop();
			
//			(__mc as MovieClip).stop();
			return __mc;
		}
		
		public function makeSimpleButton($name:String):SimpleButton
		{
			var __class	:Class 					= this.getClass($name);
			var __mc	:SimpleButton			= new __class();
			__mc.name = $name;
			
			return __mc;
		}
		
		public function makeBitmapData($name:String):BitmapData
		{
			var __class	:Class 					= this.getClass($name);
			var __mc	:BitmapData				= new __class();
			return __mc;
		}
		
		protected function getClass($class:String):Class
		{
			return _source.getClass($class);
		}
		
		
		
		
		
		
		//========================================================================
		// ILoadRequestor method.
		//========================================================================
		
		public function onLoadInit($e:LoaderEvent):void
		{
			_source = $e.target as SWFLoader;
		}
		
		public function onLoadProgress($e:LoaderEvent):void
		{
			
		}
		
		public function onLoadComplete($e:LoaderEvent):void
		{
			
		}
		
		private var _url:String = "";
		public function set url( $val:String ):void
		{
			_url = $val;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function get name():String
		{
			return "assetQueue";
		}
		
		public function get autoPlay():Boolean
		{
			return false;
		}
	}
}