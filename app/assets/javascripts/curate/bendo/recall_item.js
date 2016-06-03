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

    $.getJSON(poll.uri, { id: poll.id }, function(data) {
      $.poll(function(retry){
        if (data) {
          var cache_hit = data[poll.id];
          if (cache_hit){
            $this.addClass('alert-success').removeClass('alert-info');
            message.text('Success! You will recieve the file shortly.');
            window.location.href = window.location.origin + redirect.uri;
          } else {
            message.addClass('pulse-opacity');
            retry();
          }
        }
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
