$(document).on('turbolinks:load', function (){
    App.cable.subscriptions.create('QuestionsChannel', {
        connected() {
            this.perform('follow');
        },

        received(data) {
            $('.questions-list').append(`<a href="questions/${data.id}">${data.title}</a>`);
        }
    });
});
