//= require simplemde.min

$(function(){
  'use strict';
  var $richTextAreas = $('.rich-textarea-js');

  // HTML5 require directives need the original form element to be focusable
  $richTextAreas.removeAttr('required');

  // Only decorate the FIRST rich text area
  new SimpleMDE({
    element: $richTextAreas[0],
    hideIcons: ['image', 'heading']
  });
});
