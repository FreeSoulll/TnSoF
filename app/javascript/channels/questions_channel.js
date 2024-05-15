$(document).on('turbolinks:load', function() {
  $('.question').on('click', '.edit-question-link', function(e) {0
    e.preventDefault();
    $(this).hide();
    const editQuestionBlock = $('.edit-answer-block');
    editQuestionBlock.find('#edit-question').show();
  })
});
