require_relative '../../app/controllers/home_controller'

describe HomeController do
  it "returns true" do
    home = HomeController.new
    expect(home).not_to be_nil
  end
end