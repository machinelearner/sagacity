require File.expand_path(File.join(File.dirname(__FILE__), "../models/delta_tfidf"))
require File.expand_path(File.join(File.dirname(__FILE__), "../models/liblinear"))

class TrainingStage
    def self.execute()
        liblinear = LibLinear.new("train")
        liblinear.generate_vectors
        liblinear.dump_vectors_to_file
        liblinear.train
    end
end

