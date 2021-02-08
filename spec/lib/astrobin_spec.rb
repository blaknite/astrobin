require "./lib/astrobin"

RSpec.describe "#get_pixels" do
  let(:image) { MiniMagick::Image.open("./spec/support/test.tif") }

  it "should return a matrix of pixels" do
    expect(get_pixels(image)).to be_an(Array)
    expect(get_pixels(image).first).to be_an(Array)
    expect(get_pixels(image).first.first).to be_an(Array)
    expect(get_pixels(image).first.first.length).to eq(3)
  end
end
