$(document).on('turbolinks:load', function (){
    App.cable.subscriptions.create({ channel: 'AnswersChannel', question_id: gon.question_id }, {
        connected() {
            this.perform('follow');
        },

        received(data) {
            if (gon.user_id != data.user_id) {
                $('.answers').append(JST["templates/answer"]({answer: data}));
            }
        }
    });
});
