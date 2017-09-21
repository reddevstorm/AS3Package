package ar.events
{
	import flash.events.Event;
	import flash.net.URLVariables;
	
	public class LoadVarEvent extends Event
	{
		public 			var 	vars			:URLVariables;
		public static 	const 	LOAD_COMPLETE	:String 		= "LoadVarEvent_LOAD_COMPLETE";
		public static 	const 	SEND_COMPLETE	:String 		= "LoadVarEvent_SEND_COMPLETE";
		public static 	const 	LOAD_ERROR		:String 		= "LoadVarEvent_LOAD_ERROR";
		
		public static 	const 	IMAGE_ERROR		:String 		= "LoadVarEvent_IMAGE_ERROR";
		public static 	const 	IMAGE_COMPLETE	:String 		= "LoadVarEvent_IMAGE_COMPLETE";
		public function LoadVarEvent($type:String, $vars:URLVariables=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super($type, bubbles, cancelable);
			this.vars = $vars;
		}
	}
}