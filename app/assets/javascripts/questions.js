$(document).on('turbolinks:load', function (){
    $('.question').on('click', '.edit-question-link', function (e) {
        e.preventDefault();
        $(this).hide();
        const questionId = $(this).data('questionId');
        $('form#edit-question-' + questionId).removeClass('hidden');
    });

    $('.question').on('ajax:success', '.vote-buttons', function (e) {
        const question = e.detail[0];
        $('.question .vote .vote-buttons').hide();
        $('.question  .vote .cancel-vote').show();
        $('.question  .vote .rating').html(question.rating);
    });

    $('.question').on('ajax:success', '.cancel-vote', function (e) {
        const question = e.detail[0];
        $('.question  .vote .vote-buttons').show();
        $('.question  .vote .cancel-vote').hide();
        $('.question  .vote .rating').html(question.rating);
    });

    App.cable.subscriptions.create('QuestionsChannel', {
        connected() {
            this.perform('follow');
        },

        received(data) {
            $('.questions-list').append(`<a href="questions/${data.id}">${data.title}</a>`);
        }
    });
});
