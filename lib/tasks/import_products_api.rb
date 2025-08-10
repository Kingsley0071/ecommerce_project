require "open-uri"
require "json"

url = "https://fakestoreapi.com/products"
products = JSON.parse(URI.open(url).read)

products.each do |prod|
  cat = Category.find_or_create_by!(name: prod["category"].titleize)
  Product.find_or_create_by!(
    name: prod["title"],
    description: prod["description"],
    price: prod["price"],
    stock: rand(1..100),
    category: cat
  )

  # Attach image if not already attached
  unless product.image.attached?
    file = URI.open(prod["image"])
    product.image.attach(io: file, filename: File.basename(prod["image"]))
  end
end
