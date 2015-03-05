// Display flash notice modal 

function showFlashModal () {
  $("#flash-modal").modal("show");
}

function hideFlashModal () {
  $("#flash-modal").modal("hide");
}

  // Submit user-follow-form without button

$(document).ready(function() {
  $('.user-follow-form').click(function () {
    $(this).submit();
  }); 
});

// Display loading animation during ajax events 

$(document).ajaxStart(function() {
  $('#loading-modal').modal('show')
}).ajaxStop(function() {
  $('#loading-modal').modal('hide')
})
