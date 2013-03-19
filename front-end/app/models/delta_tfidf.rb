class DeltaTFIDF
    include MongoMapper::Document
    set_collection_name "unigram_distribution_delta_tfidf"
    key :identifier, Integer
    key :word, String
    key :value, Float
end
