document.addEventListener("turbo:load", () => {
    console.log("Turbo has loaded");
    var $play = $('.play'),
        $detail = $('.detail'),
        $board_game = $('.board_game', $detail),
        $close = $('.close');
  
    $('.board_games .board_game').click(function () {
      $board_game.html($(this).html());
      $play.appendTo($board_game);
  
      $poster = $('.poster', this).addClass('active');
  
      $('.poster', $detail).css({
        top: $poster.position().top,
        left: $poster.position().left,
        width: $poster.width(),
        height: $poster.height()
      }).data({
        top: $poster.position().top,
        left: $poster.position().left,
        width: $poster.width(),
        height: $poster.height()
      });
  
      $detail.show();
  
      $('.poster', $detail).delay(10).queue(function (next) {
        $detail.addClass('ready');
        next();
      }).delay(100).queue(function (next) {
        $(this).css({
          top: '-10%',
          left: '-6%',
          width: 266,
          height: 400
        });
        next();
      });
    });
  
    function close() {
      var $p = $('.detail .poster');
      $p.css({
        top: $p.data('top'),
        left: $p.data('left'),
        width: $p.data('width'),
        height: $p.data('height'),
      });
      $detail.removeClass('ready').delay(500).queue(function (next) {
        $(this).hide();
        $poster.removeClass('active');
        next();
      });
    }
  
    $close.click(close);
    $('body').click(function (e) {
      var $p = $(e.target).parents();
      if ($p.is('.app')) {
        return false;
      } else {
        close();
      }
    });
  
    setTimeout(function () {
      $('.board_game:eq(0)').click();
    }, 300);
    setTimeout(function () {
      close();
    }, 1700);
  });
  