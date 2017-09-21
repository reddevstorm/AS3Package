package ar.component.combobox.event
{
	import ar.component.combobox.model.ARComboListBoxDataModel;
	
	import flash.events.Event;
	
	public class ARComboEvent extends Event
	{
		public static const CLICKED_TITLE_BOX	:String = "CLICKED_TITLE_BOX";
		public static const CLICKED_LIST_BOX	:String = "CLICKED_LIST_BOX";
		
		private var _data:ARComboListBoxDataModel = null;
		
		public function ARComboEvent(type:String, $bubble:Boolean=false, $data:ARComboListBoxDataModel=null)
		{
			super(type, $bubble);
			_data = $data;
		}
		
		
		public function get data():ARComboListBoxDataModel
		{
			return _data;
		}

	}
}