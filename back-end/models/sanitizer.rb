require File.expand_path(File.join(File.dirname(__FILE__), "./helper/tweet"))
require File.expand_path(File.join(File.dirname(__FILE__), "./helper/spell_corrector"))
require File.expand_path(File.join(File.dirname(__FILE__), "./helper/word"))

class Sanitizer
    def clean(train_test_tag)
        return if train_test_tag.nil?
        p "Cleaning Process Begin"
        if train_test_tag == "test"
            documentTagClass = LabelledTweetTest
        elsif train_test_tag == "train"
            documentTagClass = LabelledTweetTrain
        end
        tweets = documentTagClass.all()
        p "Tweets Load Complete"
        tweets.each do |labelledTweet|
            tweet = Tweet.new(labelledTweet.text)
            one_line = ""
            tweet.words.each{|word| one_line+=word.value + " "}
            labelledTweet.clean_text = one_line
            labelledTweet.save
        end
        p "Done"
    end
end

p "Enter Train Test Tag" if ARGV[0].nil?

Sanitizer.new.clean(ARGV[0])
