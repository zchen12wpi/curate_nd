jQuery(function($) {
  const ready = () => $('.autocomplete').each( function(index, el) {
    const $targetElement = $(el);
    return $targetElement.tokenInput($targetElement.data("url"), {
      theme: 'facebook',
      prePopulate: $('.autocomplete').data('load'),
      jsonContainer: "docs",
      propertyToSearch: "title",
      preventDuplicates: true,
      tokenValue: "pid",
      onResult(results) {
        const pidsToFilter = $targetElement.data('exclude');
        $.each(results.docs, function(index, value) {
          // Filter out anything listed in data-exclude.  ie. the current object.
          if (pidsToFilter.indexOf(value.pid) > -1) {
            return results.docs.splice(index, 1);
          }
        });
        return results;
      }
    });
  });

  $(document).ready(ready);
  return $(document).on('page:load', ready);
});
