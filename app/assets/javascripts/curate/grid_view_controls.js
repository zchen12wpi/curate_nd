$(function(){
  // Tile search results menu (TSRM)
  $('.tile-menu-toggle').on('click', function(e) {
    e.preventDefault();
    $('.tile-actions-menu.focus').removeClass('focus');
    $(this).parent('.tile-actions-menu').toggleClass('focus');
    e.stopPropagation();
  });

  // TSRM: Save mouse-wielding users having to click
  $('.tile-menu-toggle').on('mouseover', function() {
    $('.tile-actions-menu.focus').removeClass('focus');
    $(this).parent('.tile-actions-menu').addClass('focus');
  });

  // TSRM: Catch-all for dismissing open menus
  $('.page-main').on('click', function() {
    $('.tile-actions-menu.focus').removeClass('focus');
  });

  // TSRM: Turn on tile display
  $('.search .choose-list-format .grid').on('click', function(e) {
    e.preventDefault();
    if(!($(this).hasClass('active'))){
      if(window.location.search === ''){
        window.location.href = window.location.href + '?display=grid';
      } else {
        window.location.href = window.location.href + '&display=grid';
      }
    }
  });

  // TSRM: Turn off tile display
  $('.search .choose-list-format .listing').on('click', function(e) {
    e.preventDefault();
    if(!($(this).hasClass('active'))){
      var url = window.location.href.split('?'),
          params = url[1].split('&'),
          nonDisplayParams = params.filter(function(param){
            return param.split('=')[0] !== 'display';
          }),
          target = url[0] + '?' + nonDisplayParams.join('&');

      window.location.href = target;
    }
  });
});
