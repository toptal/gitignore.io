'use strict';

$(document).ready(function () {
  $.ajax('/dropdown.json').success(function(data) {
    $("#ignoreSearch").select2({
      placeholder: "Search Operating Systems, IDEs, or Programming Languages",
      tags: true,
      minimumInputLength: 1,
      data: data
    });
  });
});

function generateGitIgnore(){
  if ($("#ignoreSearch").select2("val").length > 0){
    window.location="/api/"+$("#ignoreSearch").select2("val");
    $("#ignoreSearch").select2("val", "");
  }
}

function generateGitIgnoreFile(){
  if ($("#ignoreSearch").select2("val").length > 0){
    window.location="/api/f/"+$("#ignoreSearch").select2("val");
  }
}
