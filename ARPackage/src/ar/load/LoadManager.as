package ar.load
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.MP3Loader;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.XMLLoader;
	
	import flash.events.EventDispatcher;
	
	public class LoadManager extends EventDispatcher
	{
		protected var _loader	:LoaderMax = new LoaderMax({name:"mainQueue", 
															onChildOpen	:childOpenHandler,
															onProgress	:progressHandler,
															onComplete	:completeHandler,
															onError		:errorHandler});
		
		public function LoadManager($maxConnections:int=1, $autoLoad:Boolean=true)
		{
			_loader.maxConnections = $maxConnections;
			_loader.autoLoad = $autoLoad;
		}
		
		
		
		
		
		
		//========================================================================
		// public method.
		//========================================================================
		
		public function appendSWFMainQueue($loadRequestor:ILoadRequestor):void
		{
			_loader.append(new SWFLoader($loadRequestor.url, 
										{	name		:$loadRequestor.name,
											autoPlay	:$loadRequestor.autoPlay,
											onInit		:$loadRequestor.onLoadInit,
											onComplete	:$loadRequestor.onLoadComplete,
											onProgress	:$loadRequestor.onLoadProgress}
			));
		}
		
		public function appendImageMainQueue($loadRequestor:ILoadRequestor):void
		{
			_loader.append(new ImageLoader($loadRequestor.url, 
				{	name		:$loadRequestor.name,
					autoPlay	:$loadRequestor.autoPlay,
					onInit		:$loadRequestor.onLoadInit,
					onComplete	:$loadRequestor.onLoadComplete,
					onProgress	:$loadRequestor.onLoadProgress}
			));
		}
		
		
		
		public var loaded:Number = 0;
		
		//========================================================================
		// LoaderMax Event Handler.
		//========================================================================
		
		public function completeHandler($e:LoaderEvent):void
		{
			trace("[LoadManager] completeHandler");
		}
		
		public function progressHandler($e:LoaderEvent):void
		{
//			trace("[LoadManager] progressHandler - ",$e.target.progress);
			loaded = $e.target.progress;
		}
		
		public function childOpenHandler($e:LoaderEvent):void
		{
			trace("[LoadManager] childOpenHandler");
		}
		
		public function errorHandler($e:LoaderEvent):void
		{
			trace("[LoadManager] errorHandler - ",$e.text,$e.data);
		}
	}
}