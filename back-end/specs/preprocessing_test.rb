require File.expand_path(File.join(File.dirname(__FILE__), "../pipeline/preprocessing.rb"))

class PreProcessingStageTest
    def shouldExecuteTrainingStage()
        PreProcessingStage.execute_training_stage()
    end

    def shouldExecuteTestingStage()
        PreProcessingStage.execute_testing_stage()
    end
end
