package ar.utils.local
{
	import ar.utils.bitmap.ARCropBitmapDataUtil;
	import ar.utils.shape.ARShape;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class ARImportPicUtil extends Sprite
	{
		
		// customize
		private var 	RECT_IMAGE			:Rectangle = null;
		private var 	RECT_DRAG_SCALE		:Rectangle = null;
		private var		BT_IMPORT			:Sprite = null;
		private var		BT_SCALE			:Sprite = null;
		
		
		// variable
		private const	SIZE_DEFAULT		:Number = 0;
		private var		SIZE_CURRENT		:Number = 0;
		
		private var 	RECT_DRAG_IMAGE		:Rectangle = null;
		
		
		// image
		private var		_imageBox			:Sprite = null;
		private var		_imageContainer		:Sprite = null;
		private var 	_imageBitmap		:Bitmap = null;
		
		
		// for import
		private var		_fileR				:ARLocalFileReference = new ARLocalFileReference();;
		
		
		
		
		
		public function ARImportPicUtil()
		{
			customize();
			setLayout();
			addEvent();
		}
		
		protected function customize():void
		{
			RECT_IMAGE = new Rectangle(0, 0, 200, 200);
			RECT_DRAG_SCALE = new Rectangle(10, 230, 180, 0);
			
			BT_IMPORT = new Sprite();
			BT_IMPORT.addChild(ARShape.getRectangleShape(20, 200, 100, 20, 0xff0000 , 1));
			
			BT_SCALE = new Sprite();
			BT_SCALE.addChild(ARShape.getRectangleShape(-5,-5,10, 10, 0xff0000 , 1));
		}
		
		protected function setLayout():void 
		{
			// image container
			_imageBox = new Sprite();
			_imageContainer = new Sprite();
			
			this.addChild(_imageBox);
			_imageBox.addChild(_imageContainer);
			_imageContainer.addChild(ARShape.getRectangleShape(RECT_IMAGE.x, RECT_IMAGE.y, RECT_IMAGE.width, RECT_IMAGE.height, 0xff0000 , 0.5));
			
			
			
			// image mask
			var __make:Shape = ARShape.getRectangleShape(RECT_IMAGE.x, RECT_IMAGE.y, RECT_IMAGE.width, RECT_IMAGE.height, 0xff0000 , 1);
			this.addChild(__make);
			_imageContainer.mask = __make;
			
			
			
			// BT_SCALE
			if (BT_SCALE)
			{
				this.addChild(BT_SCALE);
				BT_SCALE.x = RECT_DRAG_SCALE.x;
				BT_SCALE.y = RECT_DRAG_SCALE.y;
			}
			
			
			// BT_IMPORT
			if (BT_IMPORT)
				this.addChild(BT_IMPORT);
		}
		
		protected function addEvent():void 
		{
			trace("TransformThumbnailView addEvent");
			_imageContainer.buttonMode = true;
			_imageContainer.addEventListener(MouseEvent.MOUSE_DOWN, startDragImage);
			if (BT_IMPORT)	
			{
				BT_IMPORT.buttonMode = true;
				BT_IMPORT.addEventListener(MouseEvent.CLICK, importImageFile);
			}
			
			if (BT_SCALE)	
			{
				BT_SCALE.mouseEnabled = false;
				BT_SCALE.buttonMode = true;
				BT_SCALE.addEventListener(MouseEvent.MOUSE_DOWN, startDragScaleBt);
			}
			
			_fileR.addEventListener(ARLocalFileReference.IMAGE_READY, readyImage);
		}
		
		protected function removeEvent():void 
		{
			if (_imageContainer.hasEventListener(MouseEvent.MOUSE_DOWN))	_imageContainer.removeEventListener(MouseEvent.MOUSE_DOWN, startDragImage);
			if (BT_IMPORT)
				BT_IMPORT.removeEventListener(MouseEvent.CLICK, importImageFile);
			
			if (BT_SCALE)
				BT_SCALE.removeEventListener(MouseEvent.MOUSE_DOWN, startDragScaleBt);
			
			_fileR.removeEventListener(ARLocalFileReference.IMAGE_READY, readyImage);
		}
		
		private function pause():void
		{
			if (BT_SCALE)
				BT_SCALE.mouseEnabled = false;
			if (BT_IMPORT)
				BT_IMPORT.mouseEnabled = false;
			_imageContainer.mouseEnabled = false;
		}
		
		private function resume():void
		{
			if (BT_SCALE)
				BT_SCALE.mouseEnabled = true;
			if (BT_IMPORT)
				BT_IMPORT.mouseEnabled = true;
			_imageContainer.mouseEnabled = true;
		}
		
		public function destroy():void
		{
			_fileR.destroy();
			pause();
			removeEvent();
			removeImage();
		}
		
		
		
		
		
		
		
		//=======================================================================================================================================================
		//	import Image file
		//=======================================================================================================================================================
		private function importImageFile(e:MouseEvent):void
		{
			_fileR.importImageFile();
		}
		
		private function readyImage(e:Event):void 
		{
			removeImage();
			
			var bit:BitmapData = _fileR.imageData.clone();
			var rate :Number = ((bit.width / RECT_IMAGE.width) < (bit.height / RECT_IMAGE.height))?	((2 * RECT_IMAGE.width) / bit.width) : ((2 * RECT_IMAGE.height) / bit.height);
			
			var newBitmapData	:BitmapData = ARCropBitmapDataUtil.cropLimitOfLength(bit, bit.width * rate, bit.height * rate);
			_imageBitmap = new Bitmap(newBitmapData);
			
			initVariable();
			setImage();
			resume();
		}
		
		private function initVariable():void
		{
			SIZE_CURRENT = SIZE_DEFAULT + .5;
			
			if (_imageContainer != null)
				_imageContainer.scaleX = _imageContainer.scaleY = 1;
			
			if (BT_SCALE != null)
				BT_SCALE.x = RECT_DRAG_SCALE.x;
		}
		
		private function removeImage():void
		{
			if (_imageBitmap != null) 
			{
				_imageContainer.removeChild(_imageBitmap);
				_imageBitmap.bitmapData.dispose();
				_imageBitmap = null;
			}
			
			if (BT_SCALE)
				BT_SCALE.mouseEnabled = false;
		}
		
		private function setImage():void
		{
			_imageContainer.addChild(_imageBitmap);
			_imageBitmap.x = -_imageBitmap.width / 2;
			_imageBitmap.y = -_imageBitmap.height / 2;
			_imageContainer.width = _imageContainer.width * SIZE_CURRENT;
			_imageContainer.scaleY = _imageContainer.scaleX;
			_imageContainer.x = Math.floor(RECT_IMAGE.width * .5);
			_imageContainer.y = Math.floor(RECT_IMAGE.height * .5);
			setDragRect();
			
			if (BT_SCALE)
				BT_SCALE.mouseEnabled = true;
		}
		
		
		
		
		
		
		//=======================================================================================================================================================
		//	drag Image
		//=======================================================================================================================================================
		private var isDragImage:Boolean = false;
		private function startDragImage(e:MouseEvent):void 
		{
			trace('startDragImage');
			isDragImage = false;
			
			_imageContainer.startDrag(false, RECT_DRAG_IMAGE);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragImage);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, dragImage);
		}
		
		private function dragImage(e:MouseEvent):void 
		{
			isDragImage = true;
		}
		
		private function stopDragImage(e:MouseEvent):void 
		{
			trace('stopDragImage');
			_imageContainer.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragImage);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragImage);
			
			isDragImage = false;
		}
		
		private function setDragRect():void
		{
			var dragW	:uint = Math.floor(Math.abs(_imageContainer.width - RECT_IMAGE.width));
			var dragH	:uint = Math.floor(Math.abs(_imageContainer.height - RECT_IMAGE.height));
			var dragX	:int = Math.floor((RECT_IMAGE.width * .5) - (_imageContainer.width - (RECT_IMAGE.width * .5) - (_imageContainer.width * .5)));
			var dragY	:int = Math.floor((RECT_IMAGE.height * .5) - (_imageContainer.height - (RECT_IMAGE.height * .5) - (_imageContainer.height * .5)));
			
			RECT_DRAG_IMAGE = new Rectangle(dragX, dragY, dragW, dragH);
		}
		
		private function startDragScaleBt(e:MouseEvent):void
		{
			BT_SCALE.startDrag(false, RECT_DRAG_SCALE);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, checkScale);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDragScaleBt);
		}
		
		private function stopDragScaleBt(e:MouseEvent):void 
		{
			setDragRect();
			BT_SCALE.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, checkScale);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragScaleBt);
		}
		
		private function checkScale(e:MouseEvent):void 
		{
			SIZE_CURRENT = ((BT_SCALE.x - RECT_DRAG_SCALE.x) * .5 / RECT_DRAG_SCALE.width) + .5;
			_imageContainer.scaleX = _imageContainer.scaleY = SIZE_CURRENT;
			checkVertex();
		}
		
		private function checkVertex():void 
		{
			if		(_imageContainer.x < RECT_DRAG_IMAGE.x) 							_imageContainer.x = RECT_DRAG_IMAGE.x;
			else if	(_imageContainer.x > RECT_DRAG_IMAGE.x + RECT_DRAG_IMAGE.width) 	_imageContainer.x = RECT_DRAG_IMAGE.x + RECT_DRAG_IMAGE.width;
			
			if		(_imageContainer.y < RECT_DRAG_IMAGE.y) 								_imageContainer.y = RECT_DRAG_IMAGE.y;
			else if	(_imageContainer.y > RECT_DRAG_IMAGE.y + RECT_DRAG_IMAGE.height) 	_imageContainer.y = RECT_DRAG_IMAGE.y + RECT_DRAG_IMAGE.height;
		}
		
		
		
		
		
		
		
		
		//=======================================================================================================================================================
		//	get image
		//=======================================================================================================================================================
		public function getImageData():BitmapData
		{
			var imageTopLeftX:int = _imageContainer.x - (_imageContainer.width * .5);
			var imageTopLeftY:int = _imageContainer.y - (_imageContainer.height * .5);
			
			var cropRectX:int = Math.floor(-imageTopLeftX / SIZE_CURRENT);
			var cropRectY:int = Math.floor(-imageTopLeftY / SIZE_CURRENT);
			var cropRectW:int = Math.floor(RECT_IMAGE.width / SIZE_CURRENT);
			var cropRectH:int = Math.floor(RECT_IMAGE.height / SIZE_CURRENT);
			
			var cropRect:Rectangle = new Rectangle(0, 0, cropRectW, cropRectH);
			
			var matrix:Matrix = new Matrix();
			matrix.tx = -cropRectX;
			matrix.ty = -cropRectY;
			var newBitmapData:BitmapData = new BitmapData(cropRect.width, cropRect.height);
			newBitmapData.draw(_imageBitmap.bitmapData.clone(), matrix);
			
			//trace(SIZE_CURRENT,"top",imageTopLeftX,imageTopLeftY,"rect",RECT_IMAGE.x,RECT_IMAGE.y,"crop",cropRectX,cropRectY,cropRectW,cropRectH, "image", image.bitmapData.width, image.bitmapData.height);
			return newBitmapData;
		}
		
		public function isReady():Boolean
		{
			if (_imageBitmap == null) 
				return false;
			
			if (_imageBitmap.bitmapData == null) 
				return false;
			
			return true;
		}
	}
}