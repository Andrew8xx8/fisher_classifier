module FisherClassifier
  module Meta
    def meta_classify(text)
      features = get_features(text)

      {
        text: text,
        default_category: default_category,
        selected_category: classify(text),
        features: features,
        features_meta: meta_features(features),
        categories: categories,
        categories_meta: meta_categories(features),
      }
    end

    private

    def meta_categories(features)
      cats = {}

      categories.map do |category|
        pm = probs_multiply(features, category)
        cats[category] = {
          probs_multiply: pm,
          fisher_factor: fisher_factor(pm),
          fisher_prob: fisher_prob(category, features),
        }
      end

      cats
    end

    def meta_features(features)
      feats = {}

      features.map do |feature|
        feats[feature] =  {
          name: feature,
          feature_in_all_categories: feature_in_all_categories(feature),
          categories: meta_feature_categories(feature)
        }
      end

      feats
    end

    def meta_feature_categories(feature)
      cats = {}
      categories.map do |category|
        cats[category] = {
          category_prob: category_prob(feature, category),
          feature_prob: feature_prob(feature, category),
          weighted_prob: weighted_prob(feature, category),
          freqsum: feature_freqsum(feature, category)
        }
      end

      cats
    end
  end
end
