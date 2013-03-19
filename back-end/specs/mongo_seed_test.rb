require File.expand_path(File.join(File.dirname(__FILE__), "../pipeline/mongo_seed.rb"))

class MongoSeedTest
    def shouldExecuteForTraining()
        MongoSeed.bulk_seed_from_file( File.expand_path(File.join(File.dirname(__FILE__),"../../data/training/positive_train.txt")),"positive","train")
        MongoSeed.bulk_seed_from_file( File.expand_path(File.join(File.dirname(__FILE__),"../../data/training/negative_train.txt")),"negative","train")
    end

    def shouldExecuteTestingStage()
        MongoSeed.bulk_seed_from_file( File.expand_path(File.join(File.dirname(__FILE__),"../../data/testing/positive_test.txt")),"positive","test")
        MongoSeed.bulk_seed_from_file( File.expand_path(File.join(File.dirname(__FILE__),"../../data/testing/negative_test.txt")),"negative","test")
    end
end

