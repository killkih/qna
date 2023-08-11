$(document).on('turbolinks:load', function (){
    $('.question').on('click', '.edit-question-link', function (e) {
        e.preventDefault();
        $(this).hide();
        const questionId = $(this).data('questionId');
        $('form#edit-question-' + questionId).removeClass('hidden');
    });
    $('.question').on('ajax:success', '.vote', function (e) {
        const question = e.detail[0];
        console.log(question);
        $('.vote .rating').html(question.rating);
    });
});
