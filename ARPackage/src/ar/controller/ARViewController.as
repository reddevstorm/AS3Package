package ar.controller 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * ...
	 * @author Zzanzza
	 */
	public class ARViewController extends MovieClip
	{
		protected var _clip		:MovieClip = null;
		
		public function ARViewController($clip:MovieClip = null) 
		{
			if ($clip)
			{
				_clip = $clip;
				this.addChild(_clip);
			}
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		protected function getChildByNameFromClip($name:String):DisplayObject
		{
			return this._clip.getChildByName($name);
		}
		
		protected function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			setLayout();
			addEvent();
		}
		
		protected function setLayout():void 
		{
			
		}
		
		protected function addEvent():void 
		{
			
		}
		
		protected function removeEvent():void 
		{
			
		}
		
		public function destroy():void 
		{
			
			removeEvent();
		}
		
		
		
		public function onResize($widht:int, $height:int):void
		{
			
		}
	}
	
}