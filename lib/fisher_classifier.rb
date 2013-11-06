require "fisher_classifier/version"

module FisherClassifier
  autoload :Classifier, 'fisher_classifier/classifier'
  autoload :Config, 'fisher_classifier/config'

  class << self
    def create(&block)
      config = Config.new block

      Classifier.new config
    end
  end
end
