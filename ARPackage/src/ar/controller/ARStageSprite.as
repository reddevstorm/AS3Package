package ar.controller
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ARStageSprite extends Sprite
	{
		public function ARStageSprite()
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			if ( stage.stageWidth === 0 && stage.stageHeight === 0 )
			{
				stage.addEventListener( Event.ENTER_FRAME, function (e:Event):void {
					if ( stage.stageWidth > 0 || stage.stageHeight > 0 ) 
					{
						stage.removeEventListener(e.type, arguments.callee);
						initOnStage();
					}
				});
			}
			else 
			{
				initOnStage();
			}
		}
		
		protected function initOnStage():void
		{
			
		}
	}
}