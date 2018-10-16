# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  questionsList = $('.questions-list')
  $('.edit-question-link').click (e) ->
    console.log('event')
    e.preventDefault();
    $('.edit_question').show();
    $(this).hide();

  $('.question-rating').bind 'ajax:success', (e) ->
    $(".question-" + e.detail[0].id + "-rating").html('Rating: ' + e.detail[0].rating)
    if e.detail[0].type != 'destroy_vote'
      $(".question-" + e.detail[0].id + "-rating-buttons").html('<p><a data-type="json" data-remote="true" rel="nofollow" data-method="delete" href="/questions/' + e.detail[0].id + '/destroy_vote">Delete vote</a></p>')
    else 
      $(".question-" + e.detail[0].id + "-rating-buttons").html(
        '<p><a data-type="json" data-remote="true" rel="nofollow" data-method="patch" href="/questions/' + e.detail[0].id + '/like">Like</a></p>
        <p><a data-type="json" data-remote="true" rel="nofollow" data-method="patch" href="/questions/' + e.detail[0].id + '/dislike">Dislike</a></p>
      ')
  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform 'follow'
    ,
    received: (data) ->
      questionsList.append data
  })

  App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      @perform 'followQuestion'
    ,
    received: (data) ->
      
  })

  # $('.question-comment-form').bind 'ajax:success', (e) ->
  #   id= e.detail[0].id
  #   text= e.detail[0].text
  #   $('.question-comments-list').prepend('<li class=\"comment-' + id + '">' + text + '</li>')
  
  # $('.question-comment-form').bind 'ajax:error', (e) ->
  #   errors = e.detail[0]
  #   $('.comment-errors').html(errors)
    