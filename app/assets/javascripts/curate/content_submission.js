var toggleLicenseText = function(){
  'use strict';

  showHideLicenseText();

  $('[id$=type_of_license]').change(function(){
    showHideLicenseText();
  });
};

function showHideLicenseText(){
  'use strict';

   var $license_text = $('[id$=type_of_license] option:selected').text();
   if($license_text === 'Independently Licensed'){
      $('#self_deposit').hide();
      $('#independent_license').show();
      $('[id$=license]').attr('required', 'true');
    }else{
      $('#independent_license').hide();
      $('#self_deposit').show();
      $('[id$=license]').removeAttr('required');
    }
}

$(document).ready(toggleLicenseText);
$(document).on('page:load', toggleLicenseText);
