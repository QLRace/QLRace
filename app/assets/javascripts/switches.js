$(document).ready(function() {
    if ($.urlParam('factory') === 'classic') {
        $('input[name="factory"]').bootstrapSwitch('state', false, false);
    } else {
        $('input[name="factory"]').bootstrapSwitch('state', true, true);
    }

    if ($.urlParam('weapons') === 'false') {
        $('input[name="weapons"]').bootstrapSwitch('state', false, false);
    } else {
        $('input[name="weapons"]').bootstrapSwitch('state', true, true);
    }

    $('input[name="factory"], input[name="weapons"]').on('switchChange.bootstrapSwitch', function(event, state) {
      var value
      if (this.name === 'factory') {
            if (state) {
                value = 'turbo';
            } else {
                value = 'classic';
            }
        } else {
            value = state;
        }
        insertParam(this.name, value);
    });
});

$.urlParam = function(name) {
    var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
    if (results === null) {
        return null;
    } else {
        return results[1] || 0;
    }
}

function insertParam(key, value) {
    key = escape(key);
    value = escape(value);

    var kvp = document.location.search.substr(1).split('&');
    if (kvp == '') {
        document.location.search = '?' + key + '=' + value;
    } else {
        var i = kvp.length;
        var x;
        while (i--) {
            x = kvp[i].split('=');

            if (x[0] == key) {
                x[1] = value;
                kvp[i] = x.join('=');
                break;
            }
        }

        if (i < 0) {
            kvp[kvp.length] = [key, value].join('=');
        }

        //this will reload the page, it's likely better to store this until finished
        document.location.search = kvp.join('&');
    }
}
