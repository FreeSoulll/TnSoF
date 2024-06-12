import consumer from './consumer'

$(document).on('turbolinks:load', function() {
  function addComment(body, email) {
    return `
      <div class="comment">
        <p>${body}</p>
        <p>${email}</p>
      <div>
    `
  }
  if (typeof gon !== 'undefined') {
    consumer.subscriptions.create({ channel: "CommentsChannel", question_id: gon.question_id }, {
      received(data) {
        const parsedData = JSON.parse(data);
        const body = parsedData.body;
        const email = parsedData.user['email'];
        const elementId = parsedData.commentable_id;

        if($(`.answer-${elementId}`).length) {
          $(`.answer-${elementId} .comments`).append(addComment(body, email));
        } else {
          $('.comments-question').append(addComment(body, email));
        }

        $(`.comment-${elementId}-form`).trigger("reset");
      }
    })
  }
})
