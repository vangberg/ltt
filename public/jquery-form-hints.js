;(function($) {
  $.fn.hints = function(options) {
    var opts = $.extend({}, $.fn.hints.defaults, options);

    return this.each(function() {
      var form = $(this);
      
      $("label", $(this)).each(function() {
        var label = $(this);
        var input = $("input[type='text']#" + label.attr('for'));
        
        if (!input[0]) { return; }

        var l_o = $.metadata ? $.extend({}, opts, label.metadata()) : opts;
        var i_o = $.metadata ? $.extend({}, opts, input.metadata()) : opts;
        
        var initial = label.hide().text().replace(':', '');
        
        input.blur(function() {
          if (input.val() == '' || input.val() == initial) { input.addClass(l_o['className']).val(initial); }
        }).focus(function() {
          if (input.val() == initial) { input.removeClass(l_o['className']).val(''); }
        }).blur();
        
        form.submit(function() {
          input.focus();
        });
      });
    });
  };
  
  $.fn.hints.defaults = {
    className: "hinted",
  }
})(jQuery);