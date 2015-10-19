$(document).ready(function() {
    $('#search').bind('railsAutocomplete.select', function () {
        $('#search-form').submit()
    });
});
