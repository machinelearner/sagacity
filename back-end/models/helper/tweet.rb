require 'iconv'
class Tweet
    LABELLED_DICTIONARY = {
        "positive" => 1,
        "negative" => 0
    }
    def initialize(sentence)
        @text = sentence
    end

    #def feature_vector
        #stemmed_words = words()
        #return "" if stemmed_words.empty?
        #feature_list = stemmed_words.map do |word|
            #{"label" => Sentiment.word_label(word),"score" => Sentiment.word_score(word)}
        #end
        #feature_list = feature_list.sort { |a, b| a["label"]<=> b["label"]}## sort by label
        #feature_vector = ""
        #feature_list.each do |feature|
            #feature_vector += "#{feature["label"]}:#{feature["score"]} " unless feature["label"] == 0 || feature["score"] == 0
        #end
        #feature_vector
    #end

    def words
        @text = Iconv.iconv('UTF-8', 'ISO-8859-1', @text)[0]
        @text = remove_uris(@text)
        words = @text.split(/\W+/)
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
