$(document).ready(function() {
    $('#search').bind('railsAutocomplete.select', function(event, data) {
        $('#search-form').submit()
    });
});
