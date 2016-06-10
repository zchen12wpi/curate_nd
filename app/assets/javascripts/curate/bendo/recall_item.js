// This widget manages querying and displaying the cache status of files in
// Bendo. There are a lot of assumptions about the structure of the classes and
// elements.

// Run on jQuery's ready event as well as Turbolinks's page change event.
Blacklight.onLoad(function() {
  'use strict';

  $('.retrieval-progress-indicator').map(function() {
    var $this = $(this),
        poll = $this.data('poll'),
        redirect = $this.data('redirect'),
        message = $('.lead', $this);

    console.log(poll);
    $.getJSON(poll.uri, { item_slugs: [ poll.item_slug ] }, function(data) {
      $.poll(function(retry){
        $.each( data, function(slug, value) {
          if (value === true){
            $this.addClass('alert-success').removeClass('alert-info');
            message.html('Success! (<a href="' + redirect.uri + '">Download</a>)');
            $('.retrieval-delay-notice').remove();
            window.location.href = window.location.origin + redirect.uri;
          } else {
            message.addClass('pulse-opacity');
            retry();
          }
        });
      });
    });
  });

  // Simple recursive polling function
  $.poll = function(wait, callback) {
    if ($.isFunction(wait)) {
      callback = wait;
      wait = 1000;
    }
    (function retry() {
      setTimeout(function(){ callback(retry); }, wait);
      wait = wait * 1.5;
    })();
  };
});
