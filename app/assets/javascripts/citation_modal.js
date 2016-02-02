$(function(){
  'use strict';

  $('.citation-modal-js').on('click', function(event){
    event.preventDefault();

    var $modal = $('#ajax-modal'),
        target = $(this).attr('href')
    ;

    setTimeout(function(){
      $modal.load(target + ' #citations', function(){
        $('body').modalmanager('loading');
        $modal.modal();
      });
    }, 1000);
  });
});
