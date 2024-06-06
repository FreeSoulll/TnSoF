$(document).on('turbolinks:load', function() {
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    const answerId = $(this).data('answerId');
    const form = $('form#edit-answer-' + answerId)
    const editLinksBlock = form.find('.answer-links .nested-fields');
    editLinksBlock.not(':first').remove();
    editLinksBlock.find('input').each(function() { $(this).val('') });
    form.show();
  })

  $('form.new-answer').on('ajax:success', function(e) {
    const answer = e.originalEvent.detail[0];
    $(this).trigger("reset");

    $('.answers').append(`
    <div class='answer'>
      <h3>Answer - ${answer.body}</h3>
      <h3>Votes</h3>
      <h4>Rating</h4>
      <p class='rating-count-${answer.id}'>${answer.rating}</p>
    </div>
    `);
  })
    .on('ajax:error', function(e) {
      const errors = e.originalEvent.detail[0];

      $.each(errors, function(index, value) {
        $(".answer-create-errors").append('<p>' + value + '</p>')
      })
    })
});
