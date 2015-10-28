(function($) {
  'use strict';

  $('a[rel=popover]').popover({ html: true, trigger: 'hover' });
  $('a[rel=popover]').click(function() { return false;});

  $('#accept_contributor_agreement').each(function(){
    $.fn.disableAgreeButton = function(element) {
      var $submitButton = $('input.require-contributor-agreement');
      $submitButton.prop('disabled', !element.checked);
    };

    $.fn.disableAgreeButton(this);

    $(this).on('change', function(){
      $.fn.disableAgreeButton(this);
    });
  });
})(jQuery);
