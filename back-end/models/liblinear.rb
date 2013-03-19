require File.expand_path(File.join(File.dirname(__FILE__), "database"))
require File.expand_path(File.join(File.dirname(__FILE__), "delta_tfidf"))
require File.expand_path(File.join(File.dirname(__FILE__), "labelled_tweet"))
require File.expand_path(File.join(File.dirname(__FILE__), "helper/tweet"))
require 'ruby_linear'

class LibLinear
    def initialize(train_test_tag,libsvm_file = File.expand_path(File.join(File.dirname(__FILE__),"../../data/#{train_test_tag}ing/#{train_test_tag}_tweets.libsvm")))
        @train_test_tag = train_test_tag
        if @train_test_tag == "test"
            @documentTagClass = LabelledTweetTest
        elsif @train_test_tag == "train"
            @documentTagClass = LabelledTweetTrain
        end
        @model_file = File.expand_path(File.join(File.dirname(__FILE__), "../../front-end/data/liblinear.model"))
        @libsvm_file = libsvm_file
    end

    def generate_vectors()
        tweets = @documentTagClass.all()
        delta_tfidf = Hash.new(0)
        delta_tfidf_distribution = DeltaTFIDF.all()
        delta_tfidf_distribution.each do |term|
            delta_tfidf[term.word] = term.value, term.identifier
        end
        p "Generating Vectors"
        tweets.each do |labelled_tweet|
            words = labelled_tweet.clean_text.split.uniq
            feature_list = words.map do |word|
                {"label" => delta_tfidf[word][1],"score" => delta_tfidf[word][0]}
            end
            feature_list = feature_list.sort { |a, b| a["label"]<=> b["label"]}
            feature_vector = ""
            feature_list.each do |feature|
                feature_vector += "#{feature["label"]}:#{feature["score"]} " unless feature["label"] == 0
            end
            labelled_tweet.feature_vector = Tweet::LABELLED_DICTIONARY[labelled_tweet.label].to_s + " " + feature_vector
            labelled_tweet.save
        end
        p "Done"
    end

    def dump_vectors_to_file()
        libsvm_dump_file = File.new(@libsvm_file,"w")
        p "Generating libsvm #{@train_test_tag}ing file"
        feature_vectors = @documentTagClass.fields(:feature_vector).all().collect{|tweet| tweet.feature_vector}
        feature_vectors.each do |vector|
            libsvm_dump_file.write("#{vector}\n")
        end
        p "Done"
    end
    def train()
        p "Cannot Perform Train on a test instance" if @train_test_tag == "test"
        return if @train_test_tag == "test"
        liblinear_bias = -1
        liblinear_problem = RubyLinear::Problem.load_file(@libsvm_file,liblinear_bias)
        liblinear_model = RubyLinear::Model.new(liblinear_problem, :solver => RubyLinear::L1R_L2LOSS_SVC)
        liblinear_model.save(@model_file)
        p "Done"
    end

    CURRENT_MODEL_VALIDATE = "solver_type L1R_L2LOSS_SVC\nnr_class 2\nlabel 1 0"
    def predict_bulk()
        p "Cannot Perform Predict on a train instance" if @train_test_tag == "train"
        return if @train_test_tag == "train"
        model = RubyLinear::Model.load_file(@model_file)
        liblinear_problem = RubyLinear::Problem.load_file(@libsvm_file,liblinear_bias)
        labels = liblinear_problem.labels
        miss_classification = 0
        for i in (0..liblinear_problem.l-1)
            prediction = model.predict(Hash[liblinear_problem.feature_vector(i)])
            if (labels[i] != prediction)
                miss_classification = miss_classification + 1
            end
        end
        puts " Classification = #{labels.length - miss_classification}/#{labels.length}, accuracy = #{(miss_classification/labels.length.to_f) * 100}"
        puts " Error Rate = #{(miss_classification/labels.length.to_f) * 100 }"
    end
end
