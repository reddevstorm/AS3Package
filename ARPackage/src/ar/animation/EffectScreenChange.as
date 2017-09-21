package ar.animation
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Strong;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;

	public class EffectScreenChange extends Sprite
	{
		public	static const ALPHA_0				:String = "ALPHA_0";
		public	static const SCALE_BIG_ALPHA_0		:String = "SCALE_BIG_ALPHA_0";
		public	static const SCALE_SMALL_ALPHA_0	:String = "SCALE_SMALL_ALPHA_0";
		public	static const MOVE_LEFT				:String = "MOVE_LEFT";
		public	static const PIXEL					:String = "PIXEL";
		public  static const MOVE_LEFT_SHOW			:String = "MOVE_LEFT_SHOW";
		public  static const MOVE_LEFT_HIDE			:String = "MOVE_LEFT_HIDE";
		
		
		private var _old		:Bitmap = null;
		private var _new		:Bitmap = null;
		private var _maskMc		:Sprite = new Sprite();
		
		private var _aniLayer	:Sprite = new Sprite();
//		private var _mskLayer	:Shape = new Shape();
		
	 	private var _width		:uint = 0;
		private var _height		:uint = 0;
		
		
		public function EffectScreenChange()
		{
//			_width = $width;
//			_height = $height;
			
			this.addChild(_aniLayer);
//			this.addChild(_mskLayer);
//			_aniLayer.mask = _mskLayer;
			
//			_mskLayer.graphics.beginFill(0x000000,1);
//			_mskLayer.graphics.drawRect(0,0,_width,_height);
//			_mskLayer.graphics.endFill();
			
			this.visible = false;
		}
		
		public function onReady($oldPage:DisplayObject):void
		{
			if ($oldPage == null || $oldPage.width == 0 || $oldPage.height == 0)
				return;
			
//			Debug.alert("onReady",$oldPage,$oldPage.width,$oldPage.height);
			
			tweenComplete();
//			_mskLayer.width = $oldPage.width;
//			_mskLayer.height = $oldPage.height;
			
			var __bitmapData:BitmapData = new BitmapData($oldPage.width, $oldPage.height,true,0x000000);
			__bitmapData.draw($oldPage,null,null,null,null,true);
			_old = new Bitmap(__bitmapData,"auto",true);
			
//			Debug.bitmap(_old);
		}
		
		public function doMove($aniType:String):void
		{
//			if (_old)	Debug.bitmap(_old);
//			if (_new)	Debug.bitmap(_new);
			
			if (_old)
				startAni(_old, $aniType);
			else
				tweenComplete();
		}
		
		public function onAnimationScreenMove($newPage:DisplayObject):void
		{
			var __bitmapData:BitmapData = new BitmapData($newPage.width, $newPage.height,true,0x000000);
			__bitmapData.draw($newPage);
			_new = new Bitmap(__bitmapData,"auto",true);
			
			if (_old)	startAni(_old, MOVE_LEFT_HIDE);
			startAni(_new, MOVE_LEFT_SHOW);
		}
		
		private function startAni($aniObj:Bitmap, $aniType:String):void
		{
			this.visible = true;
			TweenLite.killTweensOf($aniObj);
			var __tween:TweenLite = null;
			var __tScale:Number;
			var __speed:Number = 0.3;
			switch ($aniType)
			{
				case SCALE_BIG_ALPHA_0:
					__tScale = 1.2;
					__tween = new TweenLite($aniObj, __speed, {x:($aniObj.width-$aniObj.width*__tScale)/2 ,y:($aniObj.height-$aniObj.height*__tScale)/2 ,alpha:0, scaleX:__tScale, scaleY:__tScale, onComplete:tweenComplete, ease:Cubic.easeOut});
					break;
				case SCALE_SMALL_ALPHA_0:
					__tScale = 0.8;
					__tween = new TweenLite($aniObj, __speed, {x:($aniObj.width-$aniObj.width*__tScale)/2 ,y:($aniObj.height-$aniObj.height*__tScale)/2 ,alpha:0, scaleX:__tScale, scaleY:__tScale, onComplete:tweenComplete, ease:Cubic.easeOut});
					break;
				case ALPHA_0:
					__tween = new TweenLite($aniObj, __speed, {alpha:0, onComplete:tweenComplete, ease:Cubic.easeOut});
					break;
				case MOVE_LEFT_SHOW:
					$aniObj.x = $aniObj.width;
					__tween = new TweenLite($aniObj, __speed, {x:0, onComplete:tweenComplete, ease:Cubic.easeOut});
					break;
				case MOVE_LEFT_HIDE:
					$aniObj.x = 0;
					__tween = new TweenLite($aniObj, __speed, {x:-$aniObj.width, onComplete:tweenComplete, ease:Cubic.easeOut});
					break;
				case PIXEL:
//					__tween = new TweenLite($aniObj, __speed, {x:-$aniObj.width, onComplete:tweenComplete, ease:Cubic.easeOut});
					break;
				default:
					tweenComplete();
					break;
			}
			__tween.play();
			_aniLayer.addChild($aniObj);
		}
		
		private function tweenComplete():void
		{
			this.visible = false;
			if (_old)
			{
				TweenLite.killTweensOf(_old);
				if (_old.parent)	_aniLayer.removeChild(_old);
				_old = null;
			}
			if (_new)
			{
				TweenLite.killTweensOf(_new);
				if (_new.parent)	_aniLayer.removeChild(_new);
				_new = null
			}
			//this.dispatchEvent(new ScreenChangeEvent(ScreenChangeEvent.COMPLETE_TRANSITION));
		}
	}
}