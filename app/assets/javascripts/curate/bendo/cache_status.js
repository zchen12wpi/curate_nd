// This widget manages querying and displaying the cache status of files in
// Bendo. There are a lot of assumptions about the structure of the classes and
// elements.

// Run on jQuery's ready event as well as Turbolinks's page change event.
Blacklight.onLoad(function() {
  'use strict';

  var filePids = $('#attached-files > .attached-file').map(function() {
    return $(this).data('pid');
  }).get();

  if (filePids.length > 0) {
    var cacheHit = 0;
    $.getJSON('/cache_status', { id: filePids }, function(data) {
      $.each( data, function(key, value) {
        if (value === true){
          cacheHit += 1;

          $('[data-pid="' + key + '"] .action')
            .removeClass('btn-info')
            .html('<i class="icon icon-download"></i> Download');
        }
      });

      if (cacheHit === filePids.length) {
        $('.file-delay-notice').remove();
      }
    });
  }

});
