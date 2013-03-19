require File.expand_path(File.join(File.dirname(__FILE__), "../models/liblinear"))

class BulkPredictionStage
    def self.execute()
        liblinear = LibLinear.new("test")
        liblinear.generate_vectors
        liblinear.dump_vectors_to_file
        liblinear.predict_bulk
    end
end
