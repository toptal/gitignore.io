'use strict';

$(document).ready(function () {
  $.ajax('/dropdown/templates.json').success(function(data) {
    $("#ignoreSearch").select2({
      placeholder: "Search Operating Systems, IDEs, or Programming Languages",
      multiple: true,
      minimumInputLength: 1,
      data: data
    });
    $("#ignoreSearch").select2("container").find("ul.select2-choices").sortable({
      containment: 'parent',
      start: function() { $("#ignoreSearch").select2("onSortStart"); },
      update: function() { $("#ignoreSearch").select2("onSortEnd"); }
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
