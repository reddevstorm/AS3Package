package ar.animation
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class ARParticleAnimation
	{
		public function ARParticleAnimation()
		{
		}
		
		public static function doBreakAnimation($stage:Sprite, $displayObj:DisplayObject, $pixelWidth:int, $pixelHeight:int, $touchPointOfdisplayObj:Point):void
		{
			var __pw		:int = $pixelWidth;
			var __ph		:int = $pixelHeight;
			
			var __rect		:Rectangle = new Rectangle($displayObj.x, $displayObj.y, $displayObj.width, $displayObj.height);
			var __bmpD		:BitmapData = new BitmapData(__rect.width, __rect.height, true, 0x000000);
			__bmpD.draw($displayObj);
			var __bmpAry	:Vector.<VectorBitmapModel> = new Vector.<VectorBitmapModel>();
			var __wnum		:Number = Math.ceil(__rect.width / __pw);
			var __hnum		:Number = Math.ceil(__rect.height / __ph);
			
			
			var __xIndex	:Number = Math.floor($touchPointOfdisplayObj.x / __pw);
			var __yIndex	:Number = Math.floor($touchPointOfdisplayObj.y / __ph);
			var __pIndex	:uint = (__wnum * __yIndex) + __xIndex;
			
			
			var __len		:uint = __wnum * __hnum;
			for (var i:uint = 0 ; i<__len ; i++)
			{
				var __x:int = __pw*(i%__wnum);
				var __y:int = __ph*Math.floor(i/__wnum);
				var __n_btmpD	:BitmapData = new BitmapData(__pw, __ph, true, 0x000000);
				__n_btmpD.copyPixels(__bmpD, new Rectangle(__x, __y, __pw, __ph), new Point(0, 0));
				var __n_bmp		:VectorBitmapModel = new VectorBitmapModel(__n_btmpD);
				__n_bmp.x = __rect.x + __x;
				__n_bmp.y = __rect.y + __y;
				__bmpAry.push(__n_bmp);
				$stage.addChild(__n_bmp);
			}
			
			__bmpD.dispose();
			doMove(__bmpAry, $touchPointOfdisplayObj, __pIndex, Math.max(__rect.width, __rect.height));
		}
		
		private static function doMove($ary:Vector.<VectorBitmapModel>, $touchPoint:Point, $touchIndex:int, $maxLen:uint):void
		{
			var __p_btmp	:VectorBitmapModel = $ary[$touchIndex];
			var __px		:int = __p_btmp.x;
			var __py		:int = __p_btmp.y;
			
			var __pw		:int = __p_btmp.width;
			var __ph		:int = __p_btmp.height;
			
			var __cx		:int = $touchPoint.x + $ary[0].x;
			var __cy		:int = $touchPoint.y + $ary[0].y;
			
			var __t_btmp	:VectorBitmapModel;
			var __tx		:int;
			var __ty		:int;
			
			var __f			:Number = 0.1;
			var __p			:Number = $maxLen;
			
			var __len		:uint = $ary.length;
			for (var i:uint = 0 ; i < __len ; i++)
			{
				__t_btmp = $ary[i];
				__tx = __t_btmp.x;
				__ty = __t_btmp.y;
				
				var __d			:Number = Math.abs(Point.distance(new Point(__tx,__ty), new Point(__px,__py)));
				var __z_power	:Number = ((__d - (__d*__f)) / __p) * 1.2;
				var __xy_power	:Number = __d*(__d/__p) * 1.0;
				
				var __dx	:Number = __tx - __px;
				var __dy	:Number = __py - __ty;
				var __angle	:Number = Math.atan2(__dx,__dy);
				
				
				__t_btmp.ts = __t_btmp.scaleY = __z_power;
				__t_btmp.tx = __cx + int((__pw-(__t_btmp.width*__t_btmp.ts))*.5) + (__xy_power * Math.sin(__angle));
				__t_btmp.ty = __cy + int((__ph-(__t_btmp.height*__t_btmp.ts))*.5) - (__xy_power * Math.cos(__angle));
				/*
				__t_btmp.scaleX = __t_btmp.scaleY = __z_power;
				__t_btmp.x = __cx + int((_pw-__t_btmp.width)*.5) + (__xy_power * Math.sin(__angle));
				__t_btmp.y = __cy + int((_ph-__t_btmp.height)*.5) - (__xy_power * Math.cos(__angle));
				*/
				//				__vecAry.push(new VectorModel(__cx + int((_pw-__t_btmp.width)*.5) + (__xy_power * Math.sin(__angle)), __cy + int((_ph-__t_btmp.height)*.5) - (__xy_power * Math.cos(__angle)), __z_power));
			}
			
			var __newSp:Sprite = new Sprite();
			var __tween:TweenLite = TweenLite.to(__newSp, 1, {onUpdate:update, onUpdateParams:[$ary], onComplete:complete, onCompleteParams:[$ary], ease:Cubic.easeOut});
			__tween.play();
		}
		
		private static function update($bmpAry:Vector.<VectorBitmapModel>):void
		{
			var __len:uint = $bmpAry.length;
			var __v_bmp:VectorBitmapModel;
			var __sp:Number = 0.3;
			for (var i:uint = 0 ; i < __len ; i++)
			{
				__v_bmp = $bmpAry[i];
				__v_bmp.x += (__v_bmp.tx - __v_bmp.x) * __sp;
				__v_bmp.y += (__v_bmp.ty - __v_bmp.y) * __sp;
				__v_bmp.scaleX += (__v_bmp.ts - __v_bmp.scaleX) * __sp;
				__v_bmp.scaleY += (__v_bmp.ts - __v_bmp.scaleY) * __sp;
				__v_bmp.alpha += (-__v_bmp.alpha) * __sp;
			}
		}
		
		private static function complete($bmpAry:Vector.<VectorBitmapModel>):void
		{
			var __len:uint = $bmpAry.length;
			var __v_bmp:VectorBitmapModel;
			for (var i:uint = 0 ; i < __len ; i++)
			{
				__v_bmp = $bmpAry[i];
				__v_bmp.parent.removeChild(__v_bmp);
				__v_bmp.bitmapData.dispose();
				__v_bmp = null;
			}
			$bmpAry = null;
		}
	}
}

import flash.display.Bitmap;
import flash.display.BitmapData;

class VectorBitmapModel extends Bitmap
{
	public var tx:Number;
	public var ty:Number;
	public var ts:Number;
	
	public function VectorBitmapModel($bitmapData:BitmapData)
	{
		super($bitmapData);
	}
}