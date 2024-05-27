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
});
