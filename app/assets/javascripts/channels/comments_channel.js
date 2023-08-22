$(document).on('turbolinks:load', function (){
    App.cable.subscriptions.create({ channel: 'CommentsChannel', question_id: gon.question_id }, {
        connected() {
            this.perform('follow');
        },

        received(data) {
            if (gon.user_id != data.user_id) {
                if (data.commentable_type == 'Answer') {
                    $(`#answer-${data.commentable_id} .comments`).append(`<br>${data.body}`);
                } else if (data.commentable_type == 'Question') {
                    $(`.question .comments`).append(`<br>${data.body}`);
                }
            }
        }
    });
});