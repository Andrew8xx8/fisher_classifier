require 'spec_helper'

describe FisherClassifier do
  before do
    # Use in-memory classifier
    @classifier = FisherClassifier.create_in_memory
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
