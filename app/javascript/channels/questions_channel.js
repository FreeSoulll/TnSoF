$(document).on('turbolinks:load', function() {
  $('.question').on('click', '.edit-question-link', function(e) {0
    e.preventDefault();
    $(this).hide();
    const editQuestionBlock = $('.edit-answer-block');
    const editLinksBlock = $('#question-links .nested-fields');
    editLinksBlock.not(':first').remove();
    editLinksBlock.find('input').each(function() { $(this).val('') });
    editQuestionBlock.find('#edit-question').show();
  })
});


