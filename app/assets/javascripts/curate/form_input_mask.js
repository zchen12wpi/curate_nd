// This widget manages the conditional display of form fields. "Input masks" are
// sets of fields that are hidden or shown depending on configurable criteria.
//
// Initialize the widget with a hash of options.
//
// Key                 | Value
// --------------------|--------------------------------------------------------
// trigger (required)  | jQuery selector for the input control that determines
//                     | which input mask is applied to the form.
//                     |
// fields (required)   | Hash where the key is the value of the trigger input
//                     | control and the value is the value of the data
//                     | attribute of the input mask.
//                     |
// inputMaskAttribute  | The data attribute suffix used to indicate an input
//                     | mask. The default 'input-mask' means the widget acts
//                     | upon input containers with a 'data-input-mask'
//                     | attribute.
//                     |
// triggerEvent        | The event on the trigger control that will update the
//                     | input mask. Defaults to 'change' which is suitable for
//                     | select controls.

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

      this.toggleTypedInputFields($(this.options.trigger));

      var eventString = this.options.triggerEvent + ' ' + this.options.trigger,
          eventListeners = {};

      eventListeners[eventString] = 'toggleTypedInputFieldsHandler';
      this._on( this.element, eventListeners);
    },

    hideAllInputMaskFields: function() {
      var inputMaskSelector = '*[data-' + this.options.inputMaskAttribute + ']';
      $(inputMaskSelector).each(function(){
        var $element = $(this),
            $input = $element.find('input').first(),
            value = $input.val();

        // If a field has a value display it anyway; it displayed on the final
        // object if there is a value present.
        if (value === '') {
          $element.hide();
        }
      });
    },

    showInputMaskFields: function( value ) {
      var specificInputMaskSelector = '*[data-' + this.options.inputMaskAttribute + '="' + value + '"]';
      $(specificInputMaskSelector).show();
    },

    toggleTypedInputFields: function( element ) {
      var triggerValue = $(element).val(),
          targetAttribute = this.options.fields[triggerValue];

      // It would be more efficient to show or hide only the fields that are
      // required rather than simply hide them all before showing specific fields.
      this.hideAllInputMaskFields();
      if (targetAttribute !== undefined) {
        this.showInputMaskFields(targetAttribute);
      }
    },

    toggleTypedInputFieldsHandler: function (event) {
      event.preventDefault();
      this.toggleTypedInputFields(event.target);
    },

    _destroy: function() {
      this.element.removeClass('input-mask');
    }
  });
})(jQuery);
