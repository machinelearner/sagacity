require File.expand_path(File.join(File.dirname(__FILE__), "../models/database"))
require File.expand_path(File.join(File.dirname(__FILE__), "../models/labelled_tweet"))

class MongoSeed
    def self.bulk_seed_from_file(file_name,label,train_test_tag)
        tweets = File.readlines(file_name)
        if train_test_tag == "test"
            documentTagClass = LabelledTweetTest
        elsif train_test_tag == "train"
            documentTagClass = LabelledTweetTrain
        end
        tweets.each_with_index do |tweet,index|
            labelled_tweet = documentTagClass.new(:indentifier=>index+1,:label=>label,:text=>tweet)
            labelled_tweet.save
            print "."
        end
    end
end
