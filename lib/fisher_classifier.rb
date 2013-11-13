require "fisher_classifier/version"

module FisherClassifier
  autoload :Classifier, 'fisher_classifier/classifier'
  autoload :Config, 'fisher_classifier/config'

  class << self
    def create(&block)
      config = Config.new block

      Classifier.new config
    end

    def create_in_memory
      create do
        @features = {}
        @categories = {}

        inc_feature do |feature, category|
          @features[category] ||= {}

          if @features[category].has_key? feature
            @features[category][feature] += 1
          else
            @features[category][feature] = 1
          end
        end

        inc_category do |category|
          if @categories.has_key? category
            @categories[category] += 1
          else
            @categories[category] = 1
          end
        end

        get_features do |text|
          text.split(' ')
        end

        categories do
          [:good, :bad]
        end

        category_count do |category|
          @categories[category] || 0
        end

        features_count do |feature, category|
          @features[category][feature] || 0
        end

        default_category do
          :none
        end

      end

    end
  end
end
