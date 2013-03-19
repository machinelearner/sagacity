class LibLinear
        MODEL_FILE = File.expand_path(File.join(File.dirname(__FILE__), "../../data/liblinear.model"))
        MODEL = RubyLinear::Model.load_file(MODEL_FILE)
        CLASS_LABEL = {
          0 => "Negative",
          1 => "Positive"
        }

    def self.predict(vector_hash)
            class_id = MODEL.predict(vector_hash)
            CLASS_LABEL[class_id]
    end

end
