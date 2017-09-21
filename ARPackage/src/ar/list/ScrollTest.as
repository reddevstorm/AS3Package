package ar.list
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class ScrollTest extends Sprite
	{
		public function ScrollTest()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		protected function onAddedToStage(event:Event):void
		{
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			
			
			//setting
			var i:int=0;
			var __data:Array = new Array();
			for(i = 0;i<100;i++)
			{
				__data[i] = "scroll item : "+String(i);
			}
			var __scroll:ARAbstractScrollView = new ARAbstractScrollView();
			this.addChild(__scroll);//must
//			__scroll.setRowHeight(100).setRect(new Rectangle(0,0,960,640), 0xffcc00).setData(__data).initialize();
		}
	}
}