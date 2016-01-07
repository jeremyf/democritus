require 'spec_helper'

RSpec.describe Democritus::FromJsonClassBuilder do
  let(:json) do
    doc = <<-DOC
    {
      "attributes": {
        "attribute": [
          { "name:": "agree_to_terms_of_service", "type:": "Boolean", "validates:": "acceptance" }
        ]
      }
    }
    DOC
    doc.strip
  end
  let(:generated_class) { described_class.new(json).generate_class }
  subject { generated_class.new(agree_to_terms_of_service: true) }

  it { should respond_to :agree_to_terms_of_service }
  it 'will allow for the setting of the defined attribute' do
    expect(subject.agree_to_terms_of_service).to eq(true)
  end
end
