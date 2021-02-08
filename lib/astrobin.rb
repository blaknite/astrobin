require "mini_magick"

def get_pixels(image)
  convert = MiniMagick::Tool::Convert.new
  convert << image.path
  convert.depth(16)
  convert << "RGB:-"

  shell = MiniMagick::Shell.new
  output, * = shell.run(convert.command)

  pixels_array = output.unpack("S*")
  pixels = pixels_array.each_slice(3).each_slice(image.width).to_a

  output.clear
  pixels_array.clear

  pixels
end

def bin_image(file)
  image = MiniMagick::Image.open(file)

  pixels = get_pixels(image)

  binned_pixels = []

  0.step(image.height - 1, 2) do |row|
    binned_pixels[row / 2] = []

    0.step(image.width - 1, 2) do |column|
      pixel_1 = pixels[row][column + 1]
      pixel_2 = pixels[row][column]
      pixel_3 = pixels[row + 1][column]
      pixel_4 = pixels[row + 1][column + 1]

      binned_pixels[row / 2][column / 2] = [
        (pixel_1[0] + pixel_2[0] + pixel_3[0] + pixel_4[0]) / 4,
        (pixel_1[1] + pixel_2[1] + pixel_3[1] + pixel_4[1]) / 4,
        (pixel_1[2] + pixel_2[2] + pixel_3[2] + pixel_4[2]) / 4,
      ]
    end
  end

  binned_image = MiniMagick::Image.import_pixels(
    binned_pixels.flatten.pack('S*'),
    image.width / 2,
    image.height / 2,
    16,
    "rgb",
    "tif"
  )

  path = File.dirname(File.absolute_path(file))
  basename = File.basename(file, File.extname(file))

  binned_image.write("#{path}/b_#{basename}.tif")

  pixels.clear
  binned_pixels.clear
end
