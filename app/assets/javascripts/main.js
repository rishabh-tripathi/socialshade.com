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
