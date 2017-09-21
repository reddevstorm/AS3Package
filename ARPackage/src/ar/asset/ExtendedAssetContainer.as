package ar.asset
{
	import ar.asset.AssetContainer;
	import ar.observer.PageEventBroadcastor;
	
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.SWFLoader;
	
	import flash.events.Event;
	import flash.media.Sound;
	
	public class ExtendedAssetContainer extends AssetContainer
	{
		private static var		THIS	:ExtendedAssetContainer = null;
		private static const	KEY		:Object = new Object();;
		public static function getInstance():ExtendedAssetContainer
		{
			if (THIS == null)	THIS = new ExtendedAssetContainer(KEY);
			return THIS;
		}
		
		
		
		public function ExtendedAssetContainer($initObj:Object)
		{
			if ($initObj != KEY)
				throw new Error("Private constructor!");
		}
		
		
		
		public function makeSound($name:String):Sound
		{
			var __class	:Class 					= this.getClass($name);
			var __mc	:Sound				= new __class();
			return __mc;
		}
		
		
		//========================================================================
		// ILoadRequestor method.
		//========================================================================
		
		override public function onLoadProgress($e:LoaderEvent):void
		{
//			trace("[InnisfreeAssetContainer] onLoadProgress - ",($e.target as SWFLoader).progress * 100,$e.target.progress);
//			Debug.alert("progress",($e.target as SWFLoader).progress * 100,$e.target.progress);
		}
		
		override public function onLoadComplete($e:LoaderEvent):void
		{
			trace("[InnisfreeAssetContainer] onLoadComplete");
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}