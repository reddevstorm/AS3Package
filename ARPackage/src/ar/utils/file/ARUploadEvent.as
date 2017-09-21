package ar.utils.file
{
	import flash.events.Event;
	import flash.net.URLVariables;
	
	public class ARUploadEvent extends Event
	{
		public static const COMPLETE	:String = "UploadEvent_COMPLETE";
		public static const ERROR		:String = "UploadEvent_ERROR";
		
		private var _success	:String = "0";
		private var _variable	:URLVariables = null;
		private var _jsonData	:Object = null;
		
		public function ARUploadEvent(type:String, $success:String = "1", $var:URLVariables=null, $jsonData:Object=null)
		{
			super(type);
			_success = $success;
			_variable = $var;
			_jsonData = $jsonData;
		}

		public function get jsonData():Object
		{
			return _jsonData;
		}

		public function get variable():URLVariables
		{
			return _variable;
		}

		public function get success():String
		{
			return _success;
		}
	}
}