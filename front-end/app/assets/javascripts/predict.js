$(function(){
    $('#generate_sentiment').click(function(){
        $.post('predict', $('#tweet_text').serialize(),function(data) {
            $('#sentiment_value').html(data.class);
        });
    });
});

