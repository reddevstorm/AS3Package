package ar.component.combobox.list
{
	import ar.component.combobox.event.ARComboEvent;
	import ar.component.combobox.model.ARComboListBoxDataModel;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class ARComboListBox extends ARComboCoreBox
	{
		private var _data		:ARComboListBoxDataModel = null;
		private var _selected	:Boolean = false;
		
		public function ARComboListBox()
		{
			super();
		}
		
		public function get data():ARComboListBoxDataModel
		{
			return _data;
		}

		public function setData($data:ARComboListBoxDataModel):void
		{
			_data = $data;
			this._textField.text = $data.label;
		}
		
		public function set selected($value:Boolean):void
		{
			trace("selected",$value,this._selected == $value);
			if (this._selected == $value)
				return;
			
			this._selected = $value;
			if (this._selected)
			{
				this.removeEvent();
				changeSkin(_skin_down);
			}
			else
			{
				this.addEvent();
				changeSkin(_skin_normal);
			}
		}
		
		override protected function mouseClickHandler($e:MouseEvent):void
		{
			this.dispatchEvent(new ARComboEvent(ARComboEvent.CLICKED_LIST_BOX, true, data));
		}
		
		override public function clear():void
		{
			super.clear();
			this.selected = false;
		}
	}
}