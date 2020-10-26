// jQuery(function($) {
//  const ready = () => $('.autocomplete-vocab').each(function(index, el) {
//    const $targetElement = $(el);
//    return $targetElement.autocomplete({
//      source(request, response) {
//        $targetElement.data('url');
//        return $.getJSON($targetElement.data('url'), { q: request.term }, function( data, status, xhr ) {
//          const matches = [];
//          $.each(data, function(idx, val) {
//            console.log("data from ajax url: "+ val);
//            matches.push({label: val['label'], value: val['id']});
//            return console.log("Matches: "+ matches);
//          });
//          return response( matches );
//        });
//      },
//      minLength: 2,
//      focus( event, ui ) {
//        $targetElement.val(ui.item.label);
//        return event.preventDefault();
//      },
//      select( event, ui ) {
//        $targetElement.val(ui.item.label);
//        return event.preventDefault();
//      }
//    });
//  });
//
//  $(document).ready(ready);
//  return $(document).on('page:load', ready);
// });
