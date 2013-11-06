require 'spec_helper'

describe FisherClassifier::Config do
  before do
    config = Proc.new do
      key :value

      features_count do
        3
      end
    end

    @instance = FisherClassifier::Config.new config
  end

  it 'should be initialized with configuration block' do
    expect( @instance ).to be
  end

  it 'should raise error if config value missing' do
    expect{ @instance.get(:missing_value) }.to raise_error
  end

  it 'should raise error if config method missing' do
    expect{ @instance.get(:missing_value) }.to raise_error
  end

  it 'should be save value for key' do
    value = @instance.get(:key)

    expect( value ).to eq :value
  end

  it 'should execute block stored in config' do
    result = @instance.call(:features_count)

    expect( result ).to eq 3
  end
end
