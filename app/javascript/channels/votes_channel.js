import $ from 'jquery'

$(document).on('turbolinks:load', function() {
  $(document).on('ajax:success', '.vote', function(e) {
    const data = e.originalEvent.detail[0];
    $(`.rating-count-${data.id}`).text(data.rating);
  });
});
