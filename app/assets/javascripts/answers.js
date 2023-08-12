$(document).on('turbolinks:load', function (){
   $('.answers').on('click', '.edit-answer-link', function (e) {
        e.preventDefault();
        $(this).hide();
        const answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('hidden');
   });

   $('.answers').on('ajax:success', '.vote-buttons', function (e) {
       const answer = e.detail[0];
       $('#answer-' + answer.id + ' .vote-buttons').hide();
       $('#answer-' + answer.id + ' .cancel-vote').show();
       $('#answer-' + answer.id + ' .rating').html(answer.rating);
   });

   $('.answers').on('ajax:success', '.cancel-vote', function (e) {
       const answer = e.detail[0];
       $('#answer-' + answer.id + ' .vote-buttons').show();
       $('#answer-' + answer.id + ' .cancel-vote').hide();
       $('#answer-' + answer.id + ' .rating').html(answer.rating);
   });
});
