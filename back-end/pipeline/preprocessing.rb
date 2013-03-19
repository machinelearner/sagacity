require File.expand_path(File.join(File.dirname(__FILE__), "../models/sanitizer"))
require File.expand_path(File.join(File.dirname(__FILE__), "../models/unigram_distribution"))

class PreProcessingStage
    def self.execute_training_stage()
        sanitizer = Sanitizer.new
        sanitizer.clean("train")
        UnigramDistribution.generate_delta_tfidf
    end

    def self.execute_testing_stage()
        sanitizer = Sanitizer.new
        sanitizer.clean("test")
    end
end

