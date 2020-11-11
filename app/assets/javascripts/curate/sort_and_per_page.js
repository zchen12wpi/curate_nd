jQuery(function($) {
  const ready = function() {
    $('.submit-sort-per-page').hide();
    return $('.sort-per-page-dropdown').on('change', function(event) {
      return this.form.submit();
    });
  };

  $(document).ready(ready);
  return $(document).on('page:load', ready);
});
