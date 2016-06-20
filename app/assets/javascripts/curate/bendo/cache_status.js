// This script manages querying and displaying the cache status of files in
// Bendo. There are a lot of assumptions about the structure of the classes and
// elements.

// Run on jQuery's ready event as well as Turbolinks's page change event.
Blacklight.onLoad(function() {
  'use strict';

  var filePids = $('#attached-files > .attached-file').map(function() {
    return $(this).data('bendo_item_slug');
  }).get();

  if (filePids.length > 0) {
    var cacheHit = 0;
    $.getJSON('/cache_status', { item_slugs: filePids }, function(data) {
      $('.attached-file .action.btn-info').tooltip();
      $.each( data, function(slug, value) {
        if (value === true){
          cacheHit += 1;

          $('[data-bendo_item_slug="' + slug + '"] .action')
            .removeClass('btn-info')
            .html('<i class="icon icon-download"></i> Download');
          $('[data-bendo_item_slug="' + slug + '"] [data-alternate]').map(function() {
            var $this = $(this);
            $this.attr('href', $this.data('alternate'));
          });
        }
      });

      if (cacheHit === filePids.length) {
        $('.file-delay-notice').remove();
      }
    });
  } else {
    $('.file-delay-notice').remove();
  }

});
