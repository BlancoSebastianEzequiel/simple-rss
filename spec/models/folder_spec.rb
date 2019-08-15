require 'rails_helper'

RSpec.describe Folder, type: :model do
  before { @folder = FactoryBot.build(:folder) }
  subject { @folder }
  it { should respond_to(:name) }

  describe "when name is not present" do
    before { @folder.name = " " }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should_not be_valid }
  end
end
