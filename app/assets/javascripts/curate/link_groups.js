(function($, window, document) {
  let $this = undefined;

  // default settings
  const _settings =
    {default: 'cool!'};

  const _remover = $("<button class=\"btn btn-danger remove\"><i class=\"icon-white icon-minus\"></i><span>Remove</span></button>");
  const _adder   = $("<button class=\"btn btn-success add\"><i class=\"icon-white icon-plus\"></i><span>Add</span></button>");


  // This is your public API (no leading underscore, see?)
  // All public methods must return $this so your plugin is chainable.
  const methods = {
    init(options) {
      $this = $(this);
      // The settings object is available under its name: _settings. Let's
      // expand it with any custom options the user provided.
      $.extend(_settings, (options || {}));
      // Do anything that actually inits your plugin, if needed, right now!
      // An important thing to keep in mind, is that jQuery plugins should be
      // built so that one can apply them to more than one element, like so:
      //
      //  $('.matching-elements, #another-one').foobar()
      //

      //This code sets up all the "Add" and "Remove" buttons for the autocomplete fields.

      //For each autocomplete set on the page, add the "Add" and "Remove" buttons
      $this.each(function(index, el) {
        $('.autocomplete-groups').each((index, el) => _internals.autocompleteGroups(el));

        //Make sure these buttons have unique id's
        _adder.id = "adder_" + index;
        _remover.id = "remover_" + index;

        //Add the "Remove" button
        $('.field-wrapper:not(:last-child) .field-controls', this).append(_remover.clone());

        //Add the "Add" button
        $('.field-controls:last', this).append(_adder.clone());

        //Bind the buttons to onClick events
        $(el).on('click', 'button.add', function(e) {
          return _internals.addToList(this);
        });
        return $(el).on('click', 'button.remove', function(e) {
          return _internals.removeFromList(this);
        });
      });

      return $this;
    },

    // This method is often overlooked.
    destroy() {
      // Do anything to clean it up (nullify references, unbind events…).
      return $this;
    }
  };

  var _internals = {
    addToList(el) {
      const $activeControls = $(el).closest('.field-controls');
      const $listing = $activeControls.closest('.listing');
      $('.add', $activeControls).remove();
      const $removeControl = _remover.clone();
      $activeControls.prepend($removeControl);
      _internals.newRow($listing, el);
      return false;
    },

    newRow($listing, el) {
      $listing.append(_internals.newListItem($('li', $listing).size(), $listing, el));
      return _internals.autocompleteGroups($('.autocomplete-groups:last', $listing));
    },


    removeFromList(el) {
      const $currentGroup = $(el).closest('li');
      const $listing = $currentGroup.closest('.listing');
      $currentGroup.hide();
      $('input[data-info="not-persisted"]', $currentGroup).val('true');
      // set the destroy flag
      $('input:not([value])', $currentGroup).val('true');
      return false;
    },

    newListItem(index, el) {
      //# We have multiple places in a view where we need these autocomplete fields
      //# (Work edit view for example), so we don't want to use the first #entry-template.
      //# Using .closest isn't working, but this seems to for now.
      const source   =  $(el).parent().children().html();
      const template = Handlebars.compile(source);
      return template({index});
    },

    addExistingGroup($listItem, value, label) {
      const source   = $listItem.parent().prev().html();
      const template = Handlebars.compile(source);
      const $list = $listItem.closest('ul');
      $('input[required]', $list).removeAttr('required');
      $listItem.replaceWith(template({index: $('li', $list).index($listItem), value, label}));
      return _internals.newRow($list);
    },

    autocompleteGroups(el) {
      const $targetElement = $(el);
      return $targetElement.autocomplete({
        source(request, response) {
          $targetElement.data('url');
          return $.getJSON($targetElement.data('url'), { q: request.term + "*" }, function( data, status, xhr ) {
            const matches = [];
            $.each(data.response.docs, (idx, val) => matches.push({label: val['desc_metadata__title_tesim'][0], value: val['id']}));
            return response( matches );
          });
        },
        minLength: 2,
        focus( event, ui ) {
          $targetElement.val(ui.item.label);
          return event.preventDefault();
        },
        select( event, ui ) {
          _internals.addExistingGroup($targetElement.closest('li'), ui.item.value, ui.item.label);
          $targetElement.val('');
          return event.preventDefault();
        }
      });
    }
  };

  return $.fn.linkGroups = function(method) {
    if (methods[method]) {
      return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
    } else if ((typeof method === "object") || !method) {
      return methods.init.apply(this, arguments);
    } else {
      return $.error("Method " + method + " does not exist on jquery.linkGroups");
    }
  };
})(jQuery, window, document);
