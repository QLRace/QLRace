selects = function() {
    if ($('#mode-select').length) {
        setSelect();
        $('#mode-select').change(function() {
            var mode = this.value;
            if (mode === '-1') {
                Turbolinks.visit(location.pathname);
            } else {
                mode = parseInt(mode, 10);
                Turbolinks.visit(location.pathname + '?mode=' + mode);
            }
        });
    }
};

setSelect = function() {
    var mode = parseInt(urlParam('mode'), 10);
    if (isNaN(mode)) {
        mode = urlParam('weapons') === 'false' ? 1 : 0;
        if (urlParam('physics') === 'vql' || urlParam('physics') === 'classic') mode += 2;
    }
    if (mode < 0 || mode > 3) {
        $('#mode-select').prop('selectedIndex', 0);
    } else {
        $('#mode-select').val(mode).change();
    }
};

urlParam = function(name) {
    var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(location.href);
    return results === null ? null : results[1] || 0;
};

updateUrlParameter = function(uri, key, value) {
    // remove the hash part before operating on the uri
    var i = uri.indexOf('#');
    var hash = i === -1 ? '' : uri.substr(i);
    uri = i === -1 ? uri : uri.substr(0, i);

    var re = new RegExp('([?&])' + key + '=.*?(&|$)', 'i');
    var separator = uri.indexOf('?') !== -1 ? '&' : '?';
    if (uri.match(re)) {
        uri = uri.replace(re, '$1' + key + '=' + value + '$2');
    } else {
        uri = uri + separator + key + '=' + value;
    }
    return uri + hash; // finally append the hash as well
};
