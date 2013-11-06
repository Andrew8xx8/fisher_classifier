require 'spec_helper'

describe FisherClassifier do
  before do
    # In-memory classifier
    @classifier = FisherClassifier.create do
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

  it 'should calculate feature prob' do
    expect(@classifier).to be

    @classifier.train 'the quick rabbit jumps fences', :good
    @classifier.train 'buy pharmaceuticals now', :bad

    cat =  @classifier.classify('buy now')
    expect(cat).to eq :bad

    cat =  @classifier.classify('buy stuff now')
    expect(cat).to eq :bad

    cat =  @classifier.classify('rabbit jumps now')
    expect(cat).to eq :good
  end

end
