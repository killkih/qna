$(document).on('turbolinks:load', function (){
   $('.answers').on('click', '.edit-answer-link', function (e) {
        e.preventDefault();
        $(this).hide();
        const answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('hidden');
   });
   $('.answers').on('ajax:success', '.vote', function (e) {
       const answer = e.detail[0];
       console.log(answer);
       $('#answer-' + answer.id + ' .rating').html(answer.rating);
   });
});
