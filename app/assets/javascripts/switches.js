$(document).ready(function() {
    $('[name="weapons"]').bootstrapSwitch();
    $('[name="factory"]').bootstrapSwitch();
    $('input[name="weapons"]', 'input[name="factory"]').on('switchChange.bootstrapSwitch', function(event, state) {
      console.log(this); // DOM element
      console.log(event); // jQuery event
      console.log(state); // true | false
    });
});
