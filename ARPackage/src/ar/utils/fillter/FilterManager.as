package ar.utils.fillter 
{
	/**
	 * ...
	 * @author jucina
	 */
	
	import ar.utils.bitmap.*;
	import ar.utils.color.*;
	
	import flash.display.*;
	import flash.filters.*;
	import flash.geom.*;
	
	public class FilterManager
	{
		
		public function FilterManager() 
		{
			
		}
		public static function identy($displayObject:DisplayObject):void
		{
			$displayObject.filters = [];
			$displayObject.blendMode = BlendMode.NORMAL
		}
		public static function cublic($displayObject:DisplayObject, $multiply:Number =1):void
		{
			var customBlendMode:CublicFilter = new CublicFilter();
			customBlendMode.scaleX = [$multiply];
			customBlendMode.scaleY = [$multiply];
			var myFilter:ShaderFilter = new ShaderFilter(customBlendMode);
			$displayObject.filters = [myFilter];
		}
		public static function lineBlur($displayObject:DisplayObject, $multiply:Number =1.2, $saturation:Number = 0.6):void
		{
			var customBlendMode:BlendLinearBlur = new BlendLinearBlur();
			customBlendMode.lineEquation = [0,0.8,20];
			customBlendMode.uScale = [$multiply];
			customBlendMode.vScale = [$multiply];
			var colorm:ColorMatrixFilterManager = new ColorMatrixFilterManager();
			colorm.Saturation = $saturation;
			var myFilter:ShaderFilter = new ShaderFilter(customBlendMode);
			$displayObject.filters = [myFilter, colorm.Filter];
		}
		public static function bitLineBlur($bitmapData:BitmapData, $multiply:Number =1.2, $saturation:Number = 0.6, $cubic:Number = 20):BitmapData
		{
			//var bitmap:Bitmap = new Bitmap($bitmapData.clone());
			var bitmap:Bitmap = new Bitmap($bitmapData);
			var customBlendMode:BlendLinearBlur = new BlendLinearBlur();
			customBlendMode.lineEquation = [0,0.8,$cubic];
			customBlendMode.uScale = [$multiply];
			customBlendMode.vScale = [$multiply];
			var colorm:ColorMatrixFilterManager = new ColorMatrixFilterManager();
			colorm.Saturation = $saturation;
			var myFilter:ShaderFilter = new ShaderFilter(customBlendMode);
			bitmap.filters = [myFilter, colorm.Filter];
			return bitmap.bitmapData;
		}
		public static function blur($displayObject:BitmapData, $blur:Number=4):BitmapData
		{
			var __bit:BitmapData = $displayObject.clone();
			__bit.applyFilter($displayObject, $displayObject.rect, new Point(), new BlurFilter($blur, $blur));
			return __bit;
		}
		public static function blurblur($displayObject:BitmapData, $blur:Number=4):BitmapData
		{
//			var __bit:BitmapData = $displayObject.clone();
			var __bit:BitmapData = new BitmapData($displayObject.width + 10, $displayObject.height + 10, true,0x000000);
			__bit.copyPixels($displayObject, $displayObject.rect, new Point(5,5),null,null,true);
			__bit.applyFilter($displayObject, __bit.rect, new Point(5,5), new BlurFilter($blur, $blur));
			return __bit;
		}
		
		public static function customBlur($displayObject:BitmapData, $objectBlur:Number=4, $roundBlur:Number=0, $roundNum:Number=0):BitmapData
		{
			var gap:Number = $roundBlur;
			var maskShape:Shape = new Shape();
			maskShape.graphics.beginFill(0x000000,1);
			maskShape.graphics.drawRoundRect(0,0,$displayObject.width,$displayObject.height,gap,gap);
			maskShape.graphics.endFill();
			
			var maskBit:BitmapData = new BitmapData(maskShape.width, maskShape.height, true, 0x000000);
			maskBit.draw(maskShape);
			
			var __maskBit:BitmapData = new BitmapData(maskBit.width + (gap*2), maskBit.height + (gap*2), true,0x000000);
			__maskBit.copyPixels(maskBit, maskBit.rect, new Point(gap,gap),null,null,true);
			__maskBit.applyFilter(maskBit, maskBit.rect, new Point(gap,gap), new BlurFilter($roundBlur, $roundBlur));
			
			
			var __bit:BitmapData = ARCropBitmapDataUtil.cropLimitOfLength($displayObject, $displayObject.width + (gap*2), $displayObject.height + (gap*2));
			__bit.applyFilter(__bit, __bit.rect, new Point(0,0), new BlurFilter($objectBlur, $objectBlur));
			
			
			var __bitmap:Bitmap = new Bitmap(__bit);
			var __mBitmap:Bitmap = new Bitmap(__maskBit);
			
			__bitmap.cacheAsBitmap = true;
			__mBitmap.cacheAsBitmap = true;
			
			var sp:Sprite = new Sprite();
			sp.addChild(__bitmap);
			sp.addChild(__mBitmap);
			
			__bitmap.mask = __mBitmap;
			
			var __result:BitmapData = new BitmapData(sp.width, sp.height, true, 0x000000);
			__result.draw(sp);
			
			__bit.dispose();
			__maskBit.dispose();
			
			return __result;
		}
		
		
		
		public static function black($displayObject:DisplayObject, $alpha:Number = 1, $multiply:Number =1):void
		{
			ColorMatrixFilterManager.setSaturation($displayObject, $multiply * 100);
		}
		public static function bitBlack($displayObject:BitmapData, $alpha:Number = 1, $multiply:Number =1):void
		{
			ColorMatrixFilterManager.setBitSaturation($displayObject, $multiply * 100);
		}
		public static function mutiply($displayObject:DisplayObject, $alpha:Number = 1, $multiply:Number =1):void
		{
			$displayObject.alpha = $alpha;
			$displayObject.blendMode = BlendMode.MULTIPLY;
		}
		public static function bitScreen($displayObject:BitmapData,$multiply:Number = 0.7):BitmapData
		{
			var __bit:BitmapData = $displayObject.clone();
			var __temp:ColorTransform = new ColorTransform();
			__temp.alphaMultiplier = $multiply;
			__bit.draw(__bit, null, __temp, BlendMode.SCREEN);
			return __bit;
		}
		public static function screen($displayObject:DisplayObject, $alpha:Number = 1, $multiply:Number =1):void
		{
			$displayObject.alpha = $alpha;
			$displayObject.blendMode = BlendMode.SCREEN;
		}
		public static function none($displayObject:DisplayObject):void
		{
			$displayObject.alpha = 1;
			$displayObject.blendMode = BlendMode.NORMAL;
		}
		public static function control($bitmapData:BitmapData, $bright:Number = 0, $contrast:Number = 0, $saturation:Number = 0):BitmapData
		{
			var bitmap:Bitmap = new Bitmap($bitmapData.clone());
			//var bitmap:Bitmap = new Bitmap($bitmapData);
			bitmap.filters = [MatrixUtil.setBrightness($bright), MatrixUtil.setContrast($contrast), MatrixUtil.setSaturation($saturation)];
			return bitmap.bitmapData;
		}
		public static function borderBlur($bitmapData:BitmapData, $border:Number=5, $blur:Number=2):BitmapData
		{
			var __bit:BitmapData = $bitmapData.clone();
			
			var _w:Number = __bit.width+$border;
			var _h:Number = __bit.height+$border;
			var _s:Shape  = new Shape();
			_s.graphics.beginFill(0x000000, 0);
			_s.graphics.drawRect(0,0,_w, _h);
			_s.graphics.endFill();
			_s.graphics.beginBitmapFill(__bit, null, true, true);
			_s.graphics.drawRect($border,$border,__bit.width, __bit.height);
			_s.graphics.endFill();
			
			var bmpd_draw:BitmapData = new BitmapData(_w, _h,true);
			bmpd_draw.draw(_s,null,null,null,null,true);
			_s.graphics.clear();
			return blur(bmpd_draw,$blur);
		}
		public static function whiteBalance($bitmapData:BitmapData, $color:uint = 0xFFFFFF):BitmapData
		{
			//var bitmap:Bitmap = new Bitmap($bitmapData.clone());
			var bitmap:Bitmap = new Bitmap($bitmapData);
			var sprite:Sprite = new Sprite();
			var temp:Sprite = new Sprite();
			temp.graphics.beginFill($color);
			temp.graphics.drawRect(0, 0, bitmap.width, bitmap.height);
			temp.graphics.endFill();
			sprite.addChild(bitmap);
			sprite.addChild(temp);
			
			FilterManager.mutiply(temp, 1, 1);
			
			
			var newBit:BitmapData = new BitmapData(bitmap.width, bitmap.height, true, 0x000000);
			newBit.draw(sprite);
			//$bitmapData.dispose();
			return newBit;
		}
		public static function tintColor($bitmapData:BitmapData, $color:uint, $alpha:Number):BitmapData
		{
			var bitmap:Bitmap = new Bitmap($bitmapData);
			var sprite:Sprite = new Sprite();
			var temp:Sprite = new Sprite();
			temp.graphics.beginFill($color, $alpha);
			temp.graphics.drawRect(0, 0, bitmap.width, bitmap.height);
			temp.graphics.endFill();
			sprite.addChild(bitmap);
			sprite.addChild(temp);
			
			var newBit:BitmapData = new BitmapData(bitmap.width, bitmap.height, true, 0x000000);
			newBit.draw(sprite);
			return newBit;
		}
		public static function threshold($bitmapData:BitmapData, $amount:uint):BitmapData
		{
			var bit:BitmapData = new BitmapData($bitmapData.width, $bitmapData.height, true, 0x000000);
			var bit2:BitmapData = new BitmapData(bit.width, bit.height, true, 0x000000);
			
			bit.draw(ARColorUtil.setMonoTone($bitmapData));
			$bitmapData.dispose();
			
			bit.threshold(bit, new Rectangle(0,0,bit.width, bit.height), new Point(), '<', 65793*$amount, 0xFF000000, 0xff, false);
			bit2 = bit.clone();
			bit.dispose();
			bit2.threshold(bit2, new Rectangle(0,0,bit2.width, bit2.height), new Point(), '!=', 0x000000, 0x00000000, 0xff, false);
			return bit2;
		}
		public static function makeNoise($bitmapData:BitmapData, $step:Number = 0.2):BitmapData
		{
			//var bitmap:Bitmap = new Bitmap($bitmapData.clone());
			var bitmap:Bitmap = new Bitmap($bitmapData);
			var sprite:Sprite = new Sprite();
			
			
			var bmd1:BitmapData = new BitmapData(bitmap.width, bitmap.height);
			var seed:int = 1;
			bmd1.noise(seed, 0, 0xFF, BitmapDataChannel.RED, true);
			var bm1:Bitmap = new Bitmap(bmd1);
			
			
			sprite.addChild(bitmap);
			sprite.addChild(bm1);
			
			FilterManager.screen(bm1, 0.05, $step);
			
			var newBit:BitmapData = new BitmapData(bitmap.width, bitmap.height, false);
			newBit.draw(sprite);
			
			return newBit;
		}
		public static function resize($bitmapData:BitmapData, $width:Number, $height:Number):BitmapData
		{
			var __bit:BitmapData = $bitmapData.clone();
			var mat:Matrix = new Matrix();
			mat.scale($width/__bit.width, $height/__bit.height);
			var bmpd_draw:BitmapData = new BitmapData($width, $height, false);
			bmpd_draw.draw(__bit, mat, null, null, null, true);
			return bmpd_draw;
		}
		public static function scale($bitmapData:BitmapData, $scale:Number):BitmapData
		{
			var __bit:BitmapData = $bitmapData.clone();
			var mat:Matrix = new Matrix();
			mat.scale($scale, $scale);
			var bmpd_draw:BitmapData = new BitmapData(__bit.width*$scale, __bit.height*$scale, false);
			bmpd_draw.draw(__bit, mat, null, null, null, true);
			return bmpd_draw;
		}
		public static function scaleCrop($bitmapData:BitmapData, $width:Number, $height:Number):BitmapData
		{
			var newBit:BitmapData = new BitmapData($width, $height, true, 0x000000);
			var __bit:BitmapData = null;
			if($width>$height)
			{
				__bit = scale($bitmapData,$height/$bitmapData.height);
				newBit.copyPixels(__bit, new Rectangle(0,0,$width,$height),new Point((__bit.width-$width)/2, 0));
			}else{
				__bit = scale($bitmapData,$width/$bitmapData.width)
				newBit.copyPixels(__bit, new Rectangle(0,0,$width,$height),new Point(0, (__bit.height-$height)/2));
			}

			return newBit;
		}
		public static function mappingToBit($sourceBD:BitmapData, $mappingBD:BitmapData):BitmapData
		{
			var newBD:BitmapData = new BitmapData($sourceBD.width, $sourceBD.height);
			var sRect:Rectangle  = new Rectangle(0,0,$sourceBD.width,$sourceBD.height);
			var destP:Point 	 = new Point(0,0);
			var alphP:Point 	 = new Point(0,0);
			
			newBD.copyPixels($mappingBD, sRect, destP, $sourceBD, alphP, true);
			$mappingBD.dispose();
			return newBD;
		}
		
		
		
		public static function setAlpha($bd:BitmapData, $alpha:Number):BitmapData
		{
			if($alpha < 0) $alpha = 0;
			else if($alpha > 1) $alpha = 1; 
			
			var newBD:BitmapData  = new BitmapData($bd.width, $bd.height, true);
			var ct:ColorTransform = new ColorTransform();
			ct.alphaMultiplier = $alpha;
			newBD.copyPixels($bd, $bd.rect, new Point());
			newBD.colorTransform($bd.rect, ct);
			$bd.dispose();
			return newBD;
		}
		
		
		
		public static function sketch($bitmapData:BitmapData):BitmapData
		{
			var container:Sprite   = new Sprite();
			var overBD :BitmapData = new BitmapData($bitmapData.width, $bitmapData.height);
			var underBD:BitmapData = $bitmapData.clone();
			
			underBD.applyFilter(underBD, underBD.rect, new Point(), MatrixUtil.grayscale);
			container.addChild(new Bitmap(underBD.clone()));
			container.addChild(new Bitmap(underBD.clone()));
			container.getChildAt(1).blendMode = BlendMode.INVERT;
			overBD.draw(container, null,null,null,null,true);
			overBD.applyFilter(overBD, overBD.rect, new Point, new BlurFilter(15,15));
			
			return ARBitmapCustomBlend.colorDodge(overBD, underBD);
		}
	}
}