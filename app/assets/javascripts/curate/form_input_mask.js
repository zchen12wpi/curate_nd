// This widget manages the conditional display of form fields.

(function($){
  'use strict';

  $.widget( 'curate.formInputMask', {
    options: {
      target: null
    },

    _create: function() {
      this.element.addClass('input-mask');

      var eventString = 'change ' + this.options.target,
          eventListeners = {};

      eventListeners[eventString] = 'toggleTypedInputFields';
      this._on( this.element, eventListeners);
    },

    toggleTypedInputFields: function( event ) {
      event.preventDefault();
      console.log('toggleTypedInputFields');
    },

    _destroy: function() {
      this.actions.remove();
      this.element.removeClass('input-mask');
    }
  });
})(jQuery);
