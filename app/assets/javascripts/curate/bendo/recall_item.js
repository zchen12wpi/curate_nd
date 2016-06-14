// This script manages querying and displaying the cache status of files in
// Bendo. There are a lot of assumptions about the structure of the classes and
// elements.

// Run on jQuery's ready event as well as Turbolinks's page change event.
Blacklight.onLoad(function() {
  'use strict';

  $('.retrieval-progress-indicator').map(function() {
    var $this = $(this),
        post = $this.data('post'),
        poll = $this.data('poll'),
        redirect = $this.data('redirect'),
        message = $('.lead', $this);

    $.ajax({
      type: 'POST',
      url: post.uri,
      dataType: 'json'
    }).success( function() {
      message
        .addClass('pulse-opacity')
        .html('Loading…');
      $.poll(function(retry){
        $.getJSON(poll.uri, { item_slugs: [ poll.item_slug ] }, function(data) {
          $.each( data, function(slug, value) {
            if (value === true){
              $this.addClass('alert-success').removeClass('alert-info');
              message
                .removeClass('pulse-opacity')
                .html('Success!<br/><a href="' + redirect.uri + '" class="btn btn-large">Manual Download</a>');
              $('.retrieval-delay-notice').remove();
              window.location.href = window.location.origin + redirect.uri;
            } else {
              retry();
            }
          });
        });
      });
    }).fail( function(data) {
      $this
        .addClass('alert-error')
        .removeClass('alert-info');
      message
        .html('File retrieval failed: ' + data.status + ' ' + data.statusText + '<br/><a href="' + window.location.href + '" class="btn btn-large">Try again</a>');
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
