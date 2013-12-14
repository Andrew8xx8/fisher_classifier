module FisherClassifier
  module Meta
    def meta_classify(text)
      features = get_features(text)

      {
        text: text,
        default_category: default_category,
        selected_category: classify(text),
        features: meta_features(features),
        categories: meta_categories(features),
      }
    end

    private

    def meta_categories(features)
      categories.map do |category|
        pm = probs_multiply(features, category)
        {
          name: category,
          probs_multiply: pm,
          fisher_factor: fisher_factor(pm),
          fisher_prob: fisher_prob(category, features),
        }
      end
    end

    def meta_features(features)
      features.map do |feature|
        {
          name: feature,
          feature_in_all_categories: feature_in_all_categories(feature),
          categories: meta_feature_categories(feature)
        }
      end
    end

    def meta_feature_categories(feature)
      categories.map do |category|
        {
          name: category,
          category_prob: category_prob(category, feature),
          feature_prob: feature_prob(feature, category),
          weighted_prob: weighted_prob(feature, category),
          freqsum: feature_freqsum(feature, category)
        }
      end
    end
  end
end
