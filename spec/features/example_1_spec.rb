require 'spec_helper'
require 'democritus'

RSpec.describe 'Example 1' do
  let(:model) do
    Democritus.build do |builder|
      builder.attributes do
        attribute(name: :name, default: proc { hello })
      end

      def hello
        'World'
      end
    end
  end

  it 'builds a class with methods and attributes' do
    object = model.new(name: 'My Name')
    expect(object.name).to eq('My Name')
    expect(object.hello).to eq('World')
    expect(object.method(:name)).to be_a(Method)
  end
end
