$(document).ready(function() {
    if (location.pathname === '/recent' || location.pathname === '/recentwrs') {
        var mode = parseInt(urlParam('mode'), 10);
        if (isNaN(mode) || (mode < 0 || mode > 3)) {
            document.getElementById('mode').value = 'All';
        } else {
            document.getElementById('mode').value = mode;
        }
    } else {
        if (urlParam('factory') === 'classic') {
            $('input[name="factory"]').bootstrapSwitch('state', false, false);
        } else {
            $('input[name="factory"]').bootstrapSwitch('state', true, true);
        }

        if (urlParam('weapons') === 'false') {
            $('input[name="weapons"]').bootstrapSwitch('state', false, false);
        } else {
            $('input[name="weapons"]').bootstrapSwitch('state', true, true);
        }

        $('input[name="factory"], input[name="weapons"]').on('switchChange.bootstrapSwitch', function(event, state) {
            var value;
            if (this.name === 'factory') {
                value = state ? 'turbo' : 'classic';
            } else {
                value = state;
            }
            Turbolinks.visit(updateUrlParameter(window.location.href, this.name, value));
        });
    }
});

function getMode(option) {
    var mode = option.value;
    if (mode === 'All') {
        Turbolinks.visit(location.pathname);
    } else {
        mode = parseInt(mode, 10);
        Turbolinks.visit(updateUrlParameter(window.location.href, 'mode', mode));
    }
}

function urlParam(name) {
    var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
    return results === null ? null : results[1] || 0;
}

function updateUrlParameter(uri, key, value) {
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
}
