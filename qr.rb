require 'rqrcode'
require 'csv'
require 'RMagick'

include Magick

CSV_DIR = "csv"
OUTPUT_DIR = "output"

def cleanup
  system("rm #{OUTPUT_DIR}/png/box/*")
  system("rm #{OUTPUT_DIR}/png/shelf/*")
  system("rm #{OUTPUT_DIR}/png/fridge/*")
  system("rm #{OUTPUT_DIR}/pdf/*")
end

def load_csv(filename)
  csv = CSV.foreach(filename, col_sep: ',', headers: true, :header_converters => :symbol, :converters => :all)
  csv = csv.to_a.map { |row| row.to_hash }
  csv
end

def write_png(content, filename, obj)
  qrcode = RQRCode::QRCode.new(content)
  image = qrcode.as_png(size: 250)
  IO.write("#{OUTPUT_DIR}/png/#{obj}/#{filename}", image.to_s)
end

def annotate_png(legend, filename, obj)
  png_filename = "#{OUTPUT_DIR}/png/#{obj}/#{filename}"
  image = Magick::Image.read(png_filename).first
  text = Magick::Draw.new
  text.font_family = 'helvetica'
  text.pointsize = 20
  text.gravity = Magick::SouthGravity
  text.annotate(image, 0,0,0,0, legend)
  image.write(png_filename)
end

def write_pdf(obj)
  list = Magick::ImageList.new
  Dir["#{OUTPUT_DIR}/png/#{obj}/*"].each do |i|
    list << Magick::Image.read(i).first()
  end
  list.write("#{OUTPUT_DIR}/pdf/#{obj}.pdf")
end

cleanup()

boxes = load_csv("#{CSV_DIR}/box.csv")
boxes.each do |b|
  write_png(b[:name], "#{b[:name]}.png", "box")
  annotate_png("#{b[:name]} | #{b[:vaccine_type]}", "#{b[:name]}.png", "box")
end
write_pdf("box")

shelves = load_csv("#{CSV_DIR}/shelf.csv")
shelves.each do |b|
  write_png(b[:name], "#{b[:name]}.png", "shelf")
  annotate_png("#{b[:name]} | #{b[:vaccine_type]}", "#{b[:name]}.png", "shelf")
end
write_pdf("shelf")

fridges = load_csv("#{CSV_DIR}/fridge.csv")
fridges.each do |b|
  write_png(b[:name], "#{b[:name]}.png", "fridge")
  annotate_png("#{b[:name]}", "#{b[:name]}.png", "fridge")
end
write_pdf("fridge")