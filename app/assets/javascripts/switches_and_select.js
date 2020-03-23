switches_and_select = function() {
    if ($('#switches').length) {
        setSwitches();
        $('input[name="physics"], input[name="weapons"]').on('switchChange.bootstrapSwitch', function(event, state) {
            var value;
            if (this.name === 'physics') {
                value = state ? 'pql' : 'vql';
            } else {
                value = state;
            }
            Turbolinks.visit(updateUrlParameter(location.href, this.name, value));
        });
    } else if ($('#mode-select').length) {
        setSelect();
        $('#mode-select').change(function() {
            var mode = this.value;
            if (mode === '-1') {
                Turbolinks.visit(location.pathname);
            } else {
                mode = parseInt(mode, 10);
                Turbolinks.visit(updateUrlParameter(location.href, 'mode', mode));
            }
        });
    }
};

setSelect = function() {
    var mode = parseInt(urlParam('mode'), 10);
    if (isNaN(mode) || (mode < 0 || mode > 3)) {
        $('#mode-select').val(-1).change();
    } else {
        $('#mode-select').val(mode).change();
    }
};

setSwitches = function() {
    if (urlParam('physics') === 'vql' || urlParam('physics') === 'classic') {
        $('input[name="physics"]').bootstrapSwitch('state', false, false);
    } else {
        $('input[name="physics"]').bootstrapSwitch('state', true, true);
    }

    if (urlParam('weapons') === 'false') {
        $('input[name="weapons"]').bootstrapSwitch('state', false, false);
    } else {
        $('input[name="weapons"]').bootstrapSwitch('state', true, true);
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
