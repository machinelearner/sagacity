require 'iconv'
class Tweet
    include MongoMapper::Document
    set_collection_name "predict_tweets"
    key :id, Integer
    key :text, String
    key :vector, String
    key :label, String

    before_save :generate_feature_vector

    def feature_hash
      vector = self.vector
      Rails.logger.info("##############"+ vector)
      vector = JSON.parse(vector)
      vector_with_int_keys = {}
      vector.each{|key,value| vector_with_int_keys[key.to_i] = value}
      return vector_with_int_keys
    end

    private
    def generate_feature_vector
        stemmed_words = words()
        return "" if stemmed_words.empty?
        feature_list = stemmed_words.map do |word|
            word_weight = DeltaTFIDF.where(:word=>word.value).first
            {"label" => word_weight.identifier,"score" => word_weight.value}
        end
        feature_list = feature_list.sort { |a, b| a["label"]<=> b["label"]}## sort by label
        feature_vector = Hash.new(0)
        feature_list.each do |feature|
            feature_vector[feature["label"].to_i] = feature["score"] unless feature["label"] == 0 || feature["score"] == 0
        end
        self.vector = feature_vector.to_json
    end

    def words
        self.text = Iconv.iconv('UTF-8', 'ISO-8859-1', self.text)[0]
        self.text = remove_uris(self.text)
        words = self.text.split(/\W+/)
        stemmed_words = []
        words.each do |w|
            word = Word.new(w)
            word.stem_and_stop
            stemmed_words << word if word.value != ""
        end
        stemmed_words
    end

    private

    URI_REGEX = %r"((?:(?:[^ :/?#]+):)(?://(?:[^ /?#]*))(?:[^ ?#]*)(?:\?(?:[^ #]*))?(?:#(?:[^ ]*))?)"

    def remove_uris(text)
        text.split(URI_REGEX).collect do |s|
            unless s =~ URI_REGEX
                s
            end
        end.join
    end
end
