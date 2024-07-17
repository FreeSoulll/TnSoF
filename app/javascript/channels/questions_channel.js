import consumer from './consumer'

$(document).on('turbolinks:load', function() {
  const questionsList = $('.questions-list');
  $('.question').on('click', '.edit-question-link', function(e) {0
    e.preventDefault();
    $(this).hide();
    const editQuestionBlock = $('.edit-answer-block');
    const editLinksBlock = $('#question-links .nested-fields');
    editLinksBlock.not(':first').remove();
    editLinksBlock.find('input').each(function() { $(this).val('') });
    editQuestionBlock.find('#edit-question').toggleClass('visually-hidden');
  })


  consumer.subscriptions.create({ channel: "QuestionsChannel" }, {
    received(data) {
      const { id, title, body } = JSON.parse(data);
      questionsList.append(question(id, title, body));
    }

  })

  function question(id, title, body) {
    return  `
      <div class='question'>
        <h2>
          <a href='/questions/${id}'>${title}</a>
        </h2>
        <p>${body}</p>
      </div>
    `
  }
});


