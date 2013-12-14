# encoding: utf-8
module FisherClassifier
  class Classifier
    include FisherClassifier::Meta

    def initialize(config)
      @config = config
    end

    def train(text, category)
      get_features(text).each do |feature|
        inc_feature(feature, category)
        inc_category(category)
      end
    end

    def classify(text)
      features = get_features(text)
      best = default_category
      max = 0.0

      categories.each do |category|
        prob = fisher_prob(category, features)

        if prob > max
          best = category
          max = prob
        end
      end

      best
    end

    private

    def fisher_prob(category, features)
      invchi2(
        fisher_factor(
          probs_multiply(features, category)
        ), features.size * 2
      )
    end

    def fisher_factor(probs_multiply)
      -2 * Math.log(probs_multiply)
    end

    def probs_multiply(features, category)
      fprobs = features.map { |f| weighted_prob(f, category) }
      probs_multiply = fprobs.inject(:*)
      probs_multiply ||= 0
    end

    def feature_prob(feature, category)
      cc = category_count(category)
      return cc if cc.zero?

      features_count(feature, category) / cc.to_f
    end

    def weighted_prob(feature, category)
      current_prob = category_prob(category, feature)
      totals = feature_in_all_categories(feature)

      (weight * ap + totals * current_prob) / ( weight + totals).to_f
    end

    def feature_in_all_categories(feature)
      counts = categories.map { |c| features_count(feature, c) }
      counts.inject(:+)
    end

    def category_prob(category, feature)
      fp = feature_prob(feature, category)
      return fp if fp.zero?

      fp / feature_freqsum(feature, category)
    end

    def feature_freqsum(feature, category)
      counts = categories.map { |c| feature_prob(feature, c) }
      counts.inject(:+)
    end

    def invchi2(chi, df)
      m = chi / 2.0
      sum = term = Math.exp(-m)

      for i in 1..(df / 2)
        term *= m / i
        sum += term
      end

      [sum, 1.0].min
    end

    def default_category
      @config.call(:default_category)
    end

    def category_threshold(category)
      @config.call(:category_threshold, category)
    end

    def weight
      @config.get(:weight)
    end

    def ap
      @config.get(:ap)
    end

    def get_features(text)
      @config.call(:get_features, text)
    end

    def categories
      @config.call(:categories)
    end

    def category_count(category)
      @config.call(:category_count, category)
    end

    def features_count(feature, category)
      @config.call(:features_count, feature, category)
    end

    def inc_feature(feature, category)
      @config.call :inc_feature, feature, category
    end

    def inc_category(category)
      @config.call :inc_category, category
    end
  end
end
