//2012.05.22  Anlik 
//美术在开发时，切勿将文字打成组
//alert(' 开发时，切勿将文字打成组 !!! ');
fl.outputPanel.clear();
var dom=fl.getDocumentDOM();
//检查文本:
var total=0;
var totalFont=0;
var fontObj=new Object();
var txtArr=new Array();

if(document.library.getSelectedItems().length==0){
alert('  没有选中任何元件！ ');	
}
var arr_step=[];
for each(var item in document.library.getSelectedItems()){
	
	    if( item.timeline!=null){
	     for(var layerId in item.timeline.layers){
			var layer=item.timeline.layers[layerId];
			for(var frameId in layer.frames){
				var frame=layer.frames[frameId];
				for(var elementId in frame.elements){
					var element=frame.elements[elementId];
					checkTxt();
				}
			}
		}
		}
}

fl.trace("共检查"+total+"个文本.");

function checkTxt(){
	//遍历changeSex_POP下的所有元素，若元素类型为textField，修改文本字体
	//但是漏掉了按钮
	if(element.elementType=="text"){
        
	   
		var font=element.getTextAttr("face");
		var no=frameId;
		no++;
		fl.trace(' 检测到文本--'+' 文本位置： '+item.name+' 图层名字--'+layer.name+' 帧号--'+no);
		if(font){
			font="_sans";
			element.setTextAttr("face",font);
		}
		if(fontObj[font]){

		}else{
			fontObj[font]=getPath();
			totalFont++;
		}
		txtArr.push(element);
		total++;
		
	}
	if(element.elementType=='tlfText'){
		
		var no=frameId;
		no++;
		fl.trace(' ！！！！惊现TLF文本，线索：库中名字--'+item.name+' 图层名字--'+layer.name+' 帧号--'+no);
		
	}

}
function getPath(){

	return item.name+",第"+(Number(layerId)+1)+"层,第"+(Number(frameId)+1)+"帧";
}