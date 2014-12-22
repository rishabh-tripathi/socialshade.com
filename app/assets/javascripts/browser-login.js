function valpre(val) {
    return ((val != undefined) && (val != null)) 
}

function setBuid(id, uid) {
    if(!valpre(id)) {
	id = "bwloginid"
    }    
    clearBuid(id);
    localStorage.setItem(id, uid);
    setCookie(id, uid, 20*365);
}

function getBuid(id) {
    if(!valpre(id)) {
	id = "bwloginid"
    }
    var uid = localStorage.getItem(id);
    if(valpre(uid)) {	
	return uid;
    } else {
	var uid = getCookie(id);
	if(valpre(uid) && (uid.length > 0)) {
	    return uid;
	} else {
	    var uid = randomString(15);
	    localStorage.setItem(id, uid);
	    setCookie(id, uid, 20*365);
	}
    }
    return uid;
}

function clearBuid(id) {
    localStorage.removeItem(id);
    delCookie(id);
}

function setCookie(cname, cvalue, exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = "expires="+d.toUTCString();
    document.cookie = cname + "=" + cvalue + "; " + expires;
}

function getCookie(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for(var i=0; i<ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1);
        if (c.indexOf(name) != -1) return c.substring(name.length,c.length);
    }
    return "";
}

var delCookie = function(name) {
    document.cookie = name + '=;expires=Thu, 01 Jan 1970 00:00:01 GMT;';
};

function randomString(strLength) {
    var str = "";
    var chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz".split('');
    if(!strLength) {
        strLength = Math.floor(Math.random() * chars.length);
    }
    for(var i = 0; i < strLength; i++) {
        str += chars[Math.floor(Math.random() * chars.length)];
    }
    return str;
}
