import consumer from './consumer'

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

  function answerRender(data) {
    const { id,body,rating, user_id, links } = JSON.parse(data);
    let finalBlock = `
    <div class='answer answer-${id}'>
      <h3>Answer - ${body}</h3>
      <div class='rating-block'>
        <span>Rating</span>
        <p class='rating-count-${id}'>${rating}</p>
      </div>
      ${renderVote(id, user_id)}
      ${renderLinks(links)}
    </div>
    `
    if(user_id != gon.user_id) {
      finalBlock
    }

    $('.new-answer').trigger("reset");
    return finalBlock
  }

   function renderVote(id, user_id) {
    if(user_id != gon.user_id) {
      return `
        <div class="vote">
          <a class="vote-up" data-type="json" data-remote="true" rel="nofollow" data-method="patch" href="/answers/${id}/up_vote">Vote up</a>
          <a class="vote-down" data-type="json" data-remote="true" rel="nofollow" data-method="patch" href="/answers/${id}/down_vote">Vote down</a>
        </div>
      `
    } else {
      return ''
    }
   }

  function renderLinks(links) {
    if(links.length > 0) {
      let linksList = ''

      links.forEach((item) => {
        linksList += `
          <li class="link link-${item.id}">
            <a href="${item.url}">${item.name}</a>
            <a data-remote="true" rel="nofollow" data-method="delete" href="/links?link_id=${item.id}">x</a>
          </li>
        `
      })
      return `
        <div>
          <p>Links:</p>
          <ul>
            ${linksList}
          </ul>
        </div>
      `;
    } else {
      return ''
    }
  }

  if (typeof gon !== 'undefined') {
    consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
      received(data) {
        $('.answers').append(answerRender(data));
      }
    })
  }
});
