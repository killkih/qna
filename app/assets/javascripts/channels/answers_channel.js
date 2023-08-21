$(document).on('turbolinks:load', function (){

    const element = document.getElementById('question-id');
    const questionId = element.getAttribute('data-question-id');

    App.cable.subscriptions.create({ channel: 'AnswersChannel', question_id: questionId }, {
        connected() {
            this.perform('follow');
            console.log('connected to answer channel')
        },

        received(data) {
            console.log(data)
        }
    });
});
