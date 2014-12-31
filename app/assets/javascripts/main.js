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
    ele('buid').value = getBuid("soclshd");
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
    ele('buid').value = getBuid("soclshd");
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

function googleTranslationTextbox(id, value) {
    if(ele(id) != null) 
	google.setOnLoadCallback(translateTextboxValue(id, value));
}

function translateTextboxValue(textboxId, destLang) {
    var options = {
        sourceLanguage: 'en',
        destinationLanguage: [destLang],
        transliterationEnabled: true
    };
    var control = new google.elements.transliteration.TransliterationControl(options);
    var ids = [textboxId];
    control.makeTransliteratable(ids);
}

function closeAllMenu() {    
    if((ele('prof-menu') != null) && (ele('prof-menu').style.display != "none")) 
	ele_hide('prof-menu');
    if((ele('noti-menu') != null) && (ele('noti-menu').style.display != "none")) 
	ele_hide('noti-menu');
    if((ele('help-menu') != null) && (ele('help-menu').style.display != "none")) 
	ele_hide('help-menu');
}

function clearProfile() {
    r = window.confirm("Do you really want to clear this session? all the question you ask will be untrackable in notification, Do you agree?")
    if(r == true) {
	clearBuid('soclshd');
	alert("Now you are like a new user, your old session is removed from this browser");
    }
    closeAllMenu();
}
var likedivid = "";
function likeObj(id, type, div_id) {
    likedivid = div_id;
    ele('objid').value = id;
    ele('objtype').value = type;
    ele('ltype').value = 1;
    ele('lbuid').value = getBuid("soclshd");
    submit_ajax_form("create-like-form");
}

function unlikeObj(id, type, div_id) {
    likedivid = div_id;
    ele('objid').value = id;
    ele('objtype').value = type;
    ele('ltype').value = -1;
    ele('lbuid').value = getBuid("soclshd");
    submit_ajax_form("create-like-form");
}

function loadingLike() {
    ele(likedivid).innerHTML = "Loading";
}

function compLike() {
    ele(likedivid).innerHTML = ele('like-cont').innerHTML;
    ele('like-cont').innerHTML = "";
}

function showTopNotification() {    
    try {
	var is_chrome = navigator.userAgent.toLowerCase().indexOf('chrome') > -1;
	if(is_chrome) {
	    var status = getCookie("sschrnot")
	    if((status != undefined) && (status != null) && (status.length > 0)) {
		ele_hide("top-noti")
	    } else {
		ele_show("top-noti");
	    }
	}
    } catch(e) {}
}

function dismissTopNotification() {
    setCookie("sschrnot", "1", 20*365);	    
    ele_hide("top-noti");    
}
