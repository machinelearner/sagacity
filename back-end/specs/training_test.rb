require File.expand_path(File.join(File.dirname(__FILE__), "../pipeline/training.rb"))
require "test/unit"

class TrainingStageTest  < Test::Unit::TestCase
    def test_shouldExecuteTrainingStage()
        TrainingStage.execute()
    end
    def test_shouldExecuteTrain()
        ll = LibLinear.new("train")
        ll.train()
    end
end

