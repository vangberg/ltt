$(function() {
  $(".project .bar").click(function() {
    $(this).parent().find(".project-body").slideToggle(500);
  })

  $(".entry button").click(function() {
    if (confirm("Do you want to delete this entry?"))
      return true;
    else
      return false;
  })
})
