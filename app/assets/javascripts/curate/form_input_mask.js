// This widget manages the conditional display of form fields.
//
// Hide all values with an input mask @done
// Show values with a specific input mask @done
// If the value of the trigger matches an input mask show those fields @done
// If the initial value of the trigger matches an input mask hide all all OTHER
// input mask fields @TODO

(function($){
  'use strict';

  $.widget( 'curate.formInputMask', {
    options: {
      fields: null,
      inputMaskAttribute: 'input-mask',
      trigger: null,
      triggerEvent: 'change'
    },

    _create: function() {
      this.element.addClass('input-mask');

      this.hideAllInputMaskFields();

      var eventString = this.options.triggerEvent + ' ' + this.options.trigger,
          eventListeners = {};

      eventListeners[eventString] = 'toggleTypedInputFields';
      this._on( this.element, eventListeners);
    },

    hideAllInputMaskFields: function() {
      var inputMaskSelector = '*[data-' + this.options.inputMaskAttribute + ']';
      $(inputMaskSelector).hide();
    },

    showInputMaskFields: function( value ) {
      var specificInputMaskSelector = '*[data-' + this.options.inputMaskAttribute + '="' + value + '"]';
      $(specificInputMaskSelector).show();
    },

    toggleTypedInputFields: function( event ) {
      event.preventDefault();
      var triggerValue = $(event.target).val(),
          targetAttribute = this.options.fields[triggerValue];

      // It would be better to show or hide only the fields that are required
      // rather than simply hide them all before revealing tagged fields.
      this.hideAllInputMaskFields();
      if (!(targetAttribute === undefined)) {
        this.showInputMaskFields(targetAttribute);
      }
    },

    _destroy: function() {
      this.element.removeClass('input-mask');
    }
  });
})(jQuery);
