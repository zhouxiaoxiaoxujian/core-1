package cactus.ui.demo {
import flash.events.Event;
import flash.events.MouseEvent;
import com.he.ui.bind.PAutoView;
import com.he.ui.bind.PView;
import com.he.ui.control.*;
import flash.display.MovieClip;
import flash.text.TextField;

public class Demo1Renderer_UI extends PAutoView{

public var mmc_movie_PB:MovieClip;
public var txt_title_PB:TextField;
public var btn_ok_PB:PButton;

public function Demo1Renderer_UI(src:*=null){super(src)}

 override public function init():void{super.init();
btn_ok_PB.addEventListener(MouseEvent.CLICK,btn_okClick);
}
 override public function destroy():void{super.destroy();
btn_ok_PB.removeEventListener(MouseEvent.CLICK,btn_okClick);
}
 override public function fireDataChange():void{super.fireDataChange();}
private function btn_okClick(evt:MouseEvent):void{}
}}
