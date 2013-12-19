Classifier = FisherClassifier.create do
  assumed_prob 0.4
  fisher_threshold 0.1

  inc_feature do |feature, category|
    feature = ClassifierFeature.find_or_initialize_by(name: feature, category: category)
    feature.count += 1 if feature
    feature.save
  end

  get_features do |text|
    if text
      text.to_s.split(' ').map { |s| s.downcase }
    else
      []
    end
  end

  categories do
    ClassifierFeature.categories
  end

  category_count do |category|
    ClassifierFeature.where(category: category).count
  end

  features_count do |feature, category|
    f = ClassifierFeature.find_by(name: feature, category: category)
    if f
      f.count
    else
      0
    end
  end

  default_category do
    "bad"
  end
end
