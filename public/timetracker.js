$(function() {
  $(".project a.name").click(function() {
    $(this).parent().find(".entries").slideToggle(500);
  })
})
