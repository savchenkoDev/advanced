# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ -> 
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
