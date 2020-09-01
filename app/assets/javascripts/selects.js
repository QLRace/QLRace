function urlParam(name) {
    var results = new RegExp('[?&]' + name + '=([^&#]*)').exec(location.href);
    return results === null ? null : results[1] || 0;
}

function selects() {
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
}

function setSelect() {
    var mode = parseInt(urlParam('mode'), 10);
    if (isNaN(mode)) {
        if (urlParam('weapons') === null && urlParam('physics') === null) return;
        var weapons = urlParam('weapons') === null ? null : urlParam('weapons').toLowerCase()
        var physics = urlParam('physics') === null ? null : urlParam('physics').toLowerCase()
        mode = weapons === 'false' || weapons === '0' ? 1 : 0;
        if (physics === 'vql' || physics === 'classic') mode += 2;
    }
    if (mode >= 0 && mode <= 3) {
        $('#mode-select').val(mode);
    }
}
