# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  answersList = $('.answers')
  questionId = $('.question').data('id')
  userId = $('.question').data('user')
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $('form#edit-answer-' + answer_id).show();

  $('.answer-rating').bind 'ajax:success', (e) ->
    $(".answer-"+e.detail[0].id+"-rating").html('Rating: ' + e.detail[0].rating)
    if e.detail[0].type != 'destroy_vote'
      $(".answer-"+e.detail[0].id+"-rating-buttons").html('<p><a data-type="json" data-remote="true" rel="nofollow" data-method="delete" href="/answers/' + e.detail[0].id + '/destroy_vote">Delete vote</a></p>')
    else 
      $(".answer-" + e.detail[0].id + "-rating-buttons").html(
        '<p><a data-type="json" data-remote="true" rel="nofollow" data-method="patch" href="/answers/' + e.detail[0].id + '/like">Like</a></p>
        <p><a data-type="json" data-remote="true" rel="nofollow" data-method="patch" href="/answers/' + e.detail[0].id + '/dislike">Dislike</a></p>
      ')

  App.cable.subscriptions.create('AnswersChannel', {
    connected: ->
      @perform 'follow', { id: questionId }
    ,
    received: (data) ->
      answersList.append(JST['templates/answer']({
        answer: data.answer,
        attachments: data.attachments,
        current_user: userId,
        rating: data.rating,
        question_author: data.question_author
      }))
  })
  App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      @perform 'follow_answer', {id: questionId}
    ,
    received: (data) ->
      object = JSON.parse(data)
      $('.answer-' + object.id + '-comments-list').append('<li class="comment-'+object.comment.id+'">'+object.comment.text+'</li>')
  })