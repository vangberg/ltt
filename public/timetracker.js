$(function() {
  $(".project .bar").click(function() {
    $(this).parent().find(".entries").slideToggle(500);
  })
})
