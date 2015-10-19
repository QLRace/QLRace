$(document).on('page:fetch', function() {
  $('.loader').attr('style', 'display');
});
$(document).on('page:change', function() {
  $('.loader').attr('style', 'display:none');
});
