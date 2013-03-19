class SpellCorrector
    def self.words text
        text.downcase.scan(/[a-z]+/)
    end

    def self.train features
        model = Hash.new(1)
        features.each {|f| model[f] += 1 }
        model
    end
    TRAIN_FILE = File.dirname(__FILE__) + "/../../data/spell_corrector_train_file.txt"
    NWORDS = self.train(self.words(File.new(TRAIN_FILE).read))
    LETTERS = ("a".."z").to_a.join

    def self.edits1 word
        n = word.length
        deletion = (0...n).collect {|i| word[0...i]+word[i+1..-1] }
        transposition = (0...n-1).collect {|i| word[0...i]+word[i+1,1]+word[i,1]+word[i+2..-1] }
        alteration = []
        n.times {|i| LETTERS.each_byte {|l| alteration << word[0...i]+l.chr+word[i+1..-1] } }
        insertion = []
        (n+1).times {|i| LETTERS.each_byte {|l| insertion << word[0...i]+l.chr+word[i..-1] } }
        result = deletion + transposition + alteration + insertion
        result.empty? ? nil : result
    end

    def self.known_edits2 word
        result = []
        edits1(word).each {|e1| edits1(e1).each {|e2| result << e2 if NWORDS.has_key?(e2) }}
        result.empty? ? nil : result
    end

    def self.known words
        result = words.find_all {|w| NWORDS.has_key?(w) }
        result.empty? ? nil : result
    end

    def self.remove_repititions word
        normalized = word[0, 2]
        for i in 2...word.length
            normalized << word[i] if word[i] != word[i - 1] or word[i - 1] != word[i - 2]
        end
        normalized
    end

    def self.correct word
        word = word.downcase
        word = remove_repititions(word)
        #(known([word]) or known(edits1(word)) or known_edits2(word) or
         #[word]).max {|a,b| NWORDS[a] <=> NWORDS[b] }
        word
    end
end
