$(document).ready(function() {
    if ($.urlParam('factory') === 'classic') {
        $('input[name="factory"]').bootstrapSwitch('state', false, false);
    }
    else {
        $('input[name="factory"]').bootstrapSwitch('state', true, true);
    }

    weps = $.urlParam('weapons')
    // if there is no weapons param set it to true
    if (weps == null) {
        weps = true
    }

    if (!weps) {
        $('input[name="weapons"]').bootstrapSwitch('state', false, false);
    }
    else {
        $('input[name="weapons"]').bootstrapSwitch('state', true, true);
    }

    $('input[name="factory"]', 'input[name="weapons"]').on('switchChange.bootstrapSwitch', function(event, state) {
        console.log(this); // DOM element
        console.log(event); // jQuery event
        console.log(state); // true | false
    });
});

$.urlParam = function(name){
    var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
    if (results==null){
       return null;
    }
    else{
       return results[1] || 0;
    }
}
