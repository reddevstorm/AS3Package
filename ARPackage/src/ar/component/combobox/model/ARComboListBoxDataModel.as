package ar.component.combobox.model
{
	import flash.text.TextFormat;

	public class ARComboListBoxDataModel
	{
		private var _id		:int = 0;
		private var _label	:String = "";
		private var _data	:Object = null;
		
		public function ARComboListBoxDataModel($id:int, $label:String, $data:Object=null)
		{
			_id = $id;
			_label = $label;
			_data = $data;
		}

		public function get id():int
		{
			return _id;
		}

		public function get data():Object
		{
			return _data;
		}

		public function get label():String
		{
			return _label;
		}

	}
}