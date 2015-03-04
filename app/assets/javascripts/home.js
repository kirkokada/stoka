// Display flash notice modal 

function showFlashModal () {
  $("#flash-modal").modal("show");
}

// 

$(document).ready(function() {
  $('.user-follow-form').click(function () {
    $(this).submit();
  });
});
