require File.expand_path(File.join(File.dirname(__FILE__), "delta_tfidf"))
require File.expand_path(File.join(File.dirname(__FILE__), "labelled_tweet"))

class UnigramDistribution
    def self.generate_tfidf(polarity)
        docs = LabelledTweetTrain.all(:label=>polarity)
        number_of_documents = docs.length
        tf = Hash.new(0)
        df = Hash.new(0)
        tfidf = Hash.new(0)
        p "Calculating TFIDF"
        docs.each do |doc|
            words = doc.clean_text.split
            words.each{|word| tf[word] += 1}
            words.uniq.each{|word| df[word] += 1}
        end
        p "Writing TFIDF"
        tf.map do |word,tf|
            tfidf_value = tf * Math.log2(number_of_documents/df[word]).round(4)
            tfidf[word] = tfidf_value
        end
        tfidf
    end

    def self.generate_delta_tfidf()
        tfidf_pos = generate_tfidf("positive")
        tfidf_neg = generate_tfidf("negative")
        delta_tfidf = Hash.new(0)

        p "Calculating Delta TFIDF"
        tfidf_pos.each do |word,value|
            delta_tfidf[word] =  value - tfidf_neg[word]
        end
        tfidf_neg.each do |word,value|
            delta_tfidf[word] =  -1 * value unless delta_tfidf.has_key? word
        end

        p "Saving Delta TFIDF"
        delta_tfidf = delta_tfidf.sort_by{|word,delta| -delta}
        delta_tfidf.each_with_index do |(word,delta),index|
            delta = DeltaTFIDF.new(:identifier=>index+1,:word=>word,:value=>delta)
            delta.save
        end
    end
end
