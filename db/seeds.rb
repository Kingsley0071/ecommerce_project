# Create an admin user for development
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

# Clear existing data
Product.destroy_all
Category.destroy_all

# Create categories
categories = [
  Category.create!(name: "Shoes"),
  Category.create!(name: "Shirts"),
  Category.create!(name: "Accessories"),
  Category.create!(name: "Electronics"),
  Category.create!(name: "Cars")
]

# Create products
Product.create!(
  name: "Running Shoes",
  description: "Comfortable running shoes for all terrains.",
  price: 89.99,
  stock: 40,
  category: categories[0]
)

Product.create!(
  name: "Formal Shirt",
  description: "Elegant formal shirt for office and events.",
  price: 39.99,
  stock: 60,
  category: categories[1]
)

Product.create!(
  name: "Leather Belt",
  description: "Genuine leather belt for men.",
  price: 24.99,
  stock: 80,
  category: categories[2]
)

Product.create!(
  name: "Bluetooth Headphones",
  description: "Wireless headphones with noise cancellation.",
  price: 129.99,
  stock: 30,
  category: categories[3]
)

Product.create!(
  name: "Sports Car",
  description: "A fast and stylish sports car.",
  price: 25000.00,
  stock: 2,
  category: categories[4]
)

Product.create!(
  name: "Sneakers",
  description: "Trendy sneakers for everyday use.",
  price: 59.99,
  stock: 50,
  category: categories[0]
)

Product.create!(
  name: "Casual Shirt",
  description: "Comfortable shirt for casual outings.",
  price: 29.99,
  stock: 70,
  category: categories[1]
)

Product.create!(
  name: "Sunglasses",
  description: "Stylish sunglasses with UV protection.",
  price: 19.99,
  stock: 100,
  category: categories[2]
)

Product.create!(
  name: "Smartphone",
  description: "Latest model smartphone with advanced features.",
  price: 699.99,
  stock: 25,
  category: categories[3]
)

Product.create!(
  name: "SUV",
  description: "Spacious and comfortable SUV.",
  price: 35000.00,
  stock: 3,
  category: categories[4]
)