Blacklight.onLoad(function() {
  'use strict';

  // Function by @padolsey
  // http://james.padolsey.com/javascript/bujs-1-getparameterbyname/
  // http://stackoverflow.com/questions/901115/how-can-i-get-query-string-values-in-javascript/5158301#5158301
  function getParameterByName(name) {
    var match = RegExp('[?&]' + name + '=([^&]*)').exec(window.location.search);
    return match && decodeURIComponent(match[1].replace(/\+/g, ' '));
  }

  var page = getParameterByName('page'),
      q = getParameterByName('q');
  if (page > 1 || q ) {
    $('.toggle-collection-meta').addClass('collapsed');
    $('.collection-meta').hide();
  }

  $('#main').on('click', '.toggle-collection-meta', function() {
    $(this).toggleClass('collapsed');
    $('.collection-meta').slideToggle();
  });
});
