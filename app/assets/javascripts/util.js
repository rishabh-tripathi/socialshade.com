_.templateSettings = {
    interpolate: /\{\{\=(.+?)\}\}/g,
    evaluate: /\{\{(.+?)\}\}/g
};

function ele(id) {
    return document.getElementById(id);
}

function ele_show(id) {
    document.getElementById(id).style.display="";
}

function ele_hide(id) {
    document.getElementById(id).style.display="none";
}

function ele_toggle(id) {
    if(document.getElementById(id).style.display=="none") {
	document.getElementById(id).style.display="";
    } else {
	document.getElementById(id).style.display="none";
    }
}

function submit_ajax_form(id) {
    $("#"+id).trigger("submit.rails");
}

function get_hash_keys(hsh) {
    var keys = [];
    for(var i in hsh) { if (hsh.hasOwnProperty(i)) keys.push(i); }
    return keys;
}

function objDef(obj) {
    return ((obj != undefined) && (obj != null))? true : false;
}

function hasLen(obj) {
    return (obj.length > 0)? true : false;
}

function showTrans() {
    ele_show("transLayer");
}

function hideTrans() {
    ele_hide("transLayer");
}
