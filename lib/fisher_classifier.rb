require "fisher_classifier/version"

module FisherClassifier
  autoload :Classifier, 'fisher_classifier/classifier'
  autoload :Config, 'fisher_classifier/config'
  autoload :Meta, 'fisher_classifier/meta'

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
          @features[category][feature] ||= 0
          @features[category][feature] += 1
        end

        inc_category do |category|
          @categories[category] ||= 0
          @categories[category] += 1
        end

        get_features do |text|
          text.split(' ').map { |s| s.downcase }
        end

        categories do
          [:good, :bad]
        end

        category_count do |category|
          if @categories.has_key?(category)
            @categories[category]
          else
            0
          end
        end

        features_count do |feature, category|
          if @features.has_key?(category) && @features[category].has_key?(feature)
            @features[category][feature]
          else
            0
          end
        end

        default_category do
          :none
        end

      end

    end
  end
end
