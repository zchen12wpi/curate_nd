$(document).on('page:change', function(){
  'use strict';

  $('#browse').browseEverything()
    .done(function(data){
      $('#status').html(data.length.toString() + ' items selected');
    })
    .cancel(function(){
      window.alert('Canceled!');
    });
});
