require 'iconv'
class Word

    STOP_WORDS = ["a", "about", "above", "after", "again", "against", "all", "am", "an", "and", "any", "are", "aren't", "as", "at", "be", "because", "been", "before", "being", "below", "between", "both", "but", "by","did", "do", "does", "doing", "during", "each", "few", "for", "from", "had", "has", "having", "he", "he'd", "he'll", "he's", "her", "here", "here's", "hers", "herself", "him", "himself", "his", "how", "how's", "i", "i'd", "i'll", "i'm", "i've", "if", "in", "into", "is", "it", "it's", "its", "itself", "let's", "me", "mustn't", "my", "myself", "of", "on", "once", "only", "or", "other", "ought", "our", "ours", "ourselves", "over", "own", "same", "shan't", "she", "she'd", "she'll", "she's", "should", "so", "such", "than", "that", "that's", "the", "their", "theirs", "them", "themselves", "then", "there", "there's", "these", "they", "they'd", "they'll", "they're", "they've", "this", "those", "through", "to", "too", "under", "until", "up", "very", "was", "wasn't", "we", "we'd", "we'll", "we're", "we've", "were", "what", "what's", "when", "when's", "where", "where's", "which", "while", "who", "who's", "whom", "why", "why's", "with", "won't", "would", "you", "you'd", "you'll", "you're", "you've", "your", "yours", "yourself", "yourselves"]

    def initialize(word)
        @value = word
    end

    def stem_and_stop
        @value = "" if !!( @value =~ /^\d+$/)
        @value = "" if @value.length == 1
        @value = "" if STOP_WORDS.include? @value
        return if @value == ""
        is_a_word = !!(@value =~ /^[a-zA-Z]+$/)
        if is_a_word
            stemmed_word = SpellCorrector.correct(@value)
        else
            charred_word = @value.gsub(/[^a-zA-Z]/,'')
            if !charred_word.empty?
                stemmed_word = SpellCorrector.correct(@value)
            else
                stemmed_word = @value
            end
        end
        @value = stemmed_word
    end
    def value
        @value
    end
end
