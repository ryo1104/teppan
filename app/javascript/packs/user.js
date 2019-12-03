$(window).on("load", function(){
  /*初期表示*/
  $('.ChangeElem_Panel').hide();
  $('.ChangeElem_Panel').eq(0).show();
  $('.ChangeElem_Tab').eq(0).addClass('selected');
  /*クリックイベント*/
  $('.ChangeElem_Tab').each(function () {
    $(this).on('click', function () {
      var index = $('.ChangeElem_Tab').index(this);
      $('.ChangeElem_Tab').removeClass('selected');
      $(this).addClass('selected');
      $('.ChangeElem_Panel').hide();
      $('.ChangeElem_Panel').eq(index).show();
    });
  });
});
