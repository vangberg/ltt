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

  $(".delete input").click(function() {
    if (confirm("Do you want to delete this project?"))
      return true;
    else
      return false;
  })

  $("form[action='/stop']").submit(function() {
    var description = prompt('Description:');
    $(this).find('[name=description]').val(description);
  })

  $(".controls").hints()
})
