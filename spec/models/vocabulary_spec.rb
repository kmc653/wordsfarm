require 'spec_helper'

describe Vocabulary do
  it { should validate_presence_of(:word) }
  it { should validate_presence_of(:part_of_speech) }
  it { should validate_presence_of(:example) }
  it { should validate_uniqueness_of(:word) }

end