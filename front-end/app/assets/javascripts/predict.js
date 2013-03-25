$(function(){
    $('#generate_sentiment').click(function(){
            $('#sentiment_value').html("");
        $.post('predict', $('#tweet_text').serialize(),function(data) {
            $('#sentiment_value').html(data.class);
        });
    });
});

