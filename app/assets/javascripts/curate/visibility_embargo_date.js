function dateRequired(source_name, object_name) {
  if(source_name === "visibility_embargo"){
    $('[id$=' + object_name + '_embargo_release_date]').attr('required', 'true')
  }else{
    $('[id$=' + object_name + '_embargo_release_date]').removeAttr('required')
  }
}
