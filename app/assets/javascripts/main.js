function getPasteEvent(e) {
    e.preventDefault();
    if(e.clipboardData) {
	content = (e.originalEvent || e).clipboardData.getData('text/plain');
	document.execCommand('insertText', false, content);
    }
    else if(window.clipboardData) {
	content = window.clipboardData.getData('Text');
	document.selection.createRange().pasteHTML(content);
    }   
}

function setPasteEvent(id) {
    if(ele(id) != null) { 
	ele(id).addEventListener("paste", function(e) { getPasteEvent(e) });
    }
}

function removePasteEvent(id) {
    if(ele(id) != null) { 
	ele(id).removeEventListener("paste", function(e) { getPasteEvent(e) });
    }
}

function saveTextAnswer() {
    ele('ans').value = ele('ans-txt').innerHTML;
    submit_ajax_form('save-ans-form');
}

function submitOptAns(id, all) {
    for(var i=0;i<all.length;i++) {
	$('#'+all[i]+'-icon').removeClass('checked');
	$('#'+all[i]+'-icon').addClass('unchecked');
    }
    $('#'+id+'-icon').removeClass('unchecked');
    $('#'+id+'-icon').addClass('checked');    
    ele('ans').value = id;
    submit_ajax_form('save-ans-form');
}

function drawChart() {
    console.log('no need to draw any chart');
}

function afterSave() {
    hideTrans();
    if(ele('qu-txt') != null)
	ele_del('qu-txt');
    if(ele('qu-opt') != null) 
	ele_del('qu-opt');
    drawChart();
}
