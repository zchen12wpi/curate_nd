// require embargo release date for only embargo option
function embargoDateRequired(source_name, object_name) {
  if(source_name === "visibility_embargo"){
    $('[id$=' + object_name + '_embargo_release_date]').attr('required', 'true')
  }else{
    $('[id$=' + object_name + '_embargo_release_date]').removeAttr('required')
  }
}

// clear the embargo release date value for open access
function validateCurationConcernForm(form) {
    var is_open = $('#visibility_open')[0]
    var embargo_release_date = $('#' + form.dataset.modelName + '_embargo_release_date')[0]
    if(is_open.checked && embargo_release_date){
      embargo_release_date.value = ""
    }
    return true;
}
