require 'rake_helper'

describe 'DependLister' do
  subject(:task) { Rake.application['DependLister'] }

  it 'execute DependLister' do
    expect { task.invoke }.to eq 'hoge'
  end 
end

# Spec.describe DependLister do
#   it "has a version number" do
#     expect(DependLister::VERSION).not_to be nil
#   end

#   it "does something useful" do
#     expect(false).to eq(true)
#   end
# end
