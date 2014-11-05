// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//
// Required by Blacklight
//= require blacklight/blacklight
//= require curate
//= require jquery.sticky
//= require_tree .

$(function(){
  $("#more-information").sticky({topSpacing:0});
  $("a[rel=popover]").popover({ html : true, trigger: "hover" });
  $("a[rel=popover]").click(function() { return false;});

  $('#accept_contributor_agreement').each(function(){
    $.fn.disableAgreeButton = function(element) {
      var $submit_button = $('input.require-contributor-agreement');
      $submit_button.prop("disabled", !element.checked);
    };
    $.fn.disableAgreeButton(this);
    $(this).on('change', function(){
      $.fn.disableAgreeButton(this);
    });
  });

  $('#announcements').on('ajax:success', function(event, xhr, status){
    var $target = $(event.target),
        $announcment = $target.parent('.announcement');

    $announcment.fadeOut(100);
  });

  $("dt.attribute:contains('Date of birth:') + dd").remove();
  $("dt.attribute:contains('Date of birth:')").remove();
  $("dt.attribute:contains('Gender:') + dd").remove();
  $("dt.attribute:contains('Gender:')").remove();

  $('table.attributes').ready(function(){
    $('li.attribute.abstract').each(function(){
      var str = $(this).html();
      var regex = /(https?:\/\/([-\w\.]+)+(:\d+)?(\/([\w\/_\.]*(\?\S+)?)?)?)/ig
      var replaced_text = str.replace(regex, "<a href='$1' target='_blank'>$1</a>");
      $(this).html(replaced_text);
    });
  });
});
