require File.expand_path(File.join(File.dirname(__FILE__), "database"))

class LabelledTweetTrain
    include MongoMapper::Document
    set_collection_name "labelled_tweets_training"
    key :id, Integer
    key :label,String
    key :text, String
    key :clean_text, String
    key :feature_vector, String
end

class LabelledTweetTest
    include MongoMapper::Document
    set_collection_name "labelled_tweets_testing"
    key :id, Integer
    key :label,String
    key :text, String
    key :clean_text, String
    key :feature_vector, String
end

