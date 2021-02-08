require "./lib/astrobin"

ARGV.each do|arg|
  Dir[arg].each do |file|
    start_time = Time.now
    puts "Binning #{file}..."
    bin_image(file)
    puts "Done - #{(Time.now - start_time)} seconds\n"
  end
end
