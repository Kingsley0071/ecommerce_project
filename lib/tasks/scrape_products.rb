require "nokogiri"
require "open-uri"

# Scrape categories
doc = Nokogiri::HTML(URI.open("https://books.toscrape.com/"))
categories = doc.css(".side_categories ul li ul li a").map { |a| a.text.strip }

categories.each do |cat_name|
  Category.find_or_create_by!(name: cat_name)
end

# Scrape products (first page of each category)
Category.all.each do |category|
  cat_url = "https://books.toscrape.com/catalogue/category/books/#{category.name.downcase.gsub(' ', '-')}_1/index.html"
  begin
    cat_doc = Nokogiri::HTML(URI.open(cat_url))
    cat_doc.css(".product_pod").each do |prod|
      title = prod.css("h3 a").attr("title").value
      price = prod.css(".price_color").text.gsub("£", "").to_f
      Product.find_or_create_by!(
        name: title,
        description: "Imported from books.toscrape.com",
        price: price,
        stock: rand(1..100),
        category: category
      )
    end
  rescue
    puts "Could not scrape #{cat_url}"
  end
end
