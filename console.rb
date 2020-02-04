require("pry-byebug")

require_relative("models/customer")
require_relative("models/film")
require_relative("models/ticket")
require_relative("models/screening")

Customer.delete_all()
Film.delete_all()
Ticket.delete_all()
Screening.delete_all()

customer1 = Customer.new({
  "name" => "Bob",
  "funds" => 100
  })
customer1.save()

customer2 = Customer.new({
  "name" => "John",
  "funds" => 50
  })
customer2.save()

film1 = Film.new({
  "title" => "Inception",
  "price" => 10
  })
film1.save()

film2 = Film.new({
  "title" => "Kill Bill",
  "price" => 9
  })
film2.save()

screening1 = Screening.new({
  "film_id" => film1.id,
  "screen_time" => "10:00",
  "capacity" => 5
  })
screening2 = Screening.new({
  "film_id" => film1.id,
  "screen_time" => "16:00",
  "capacity" => 10
  })
screening3 = Screening.new({
  "film_id" => film1.id,
  "screen_time" => "20:00",
  "capacity" => 30
  })
screening1.save()
screening2.save()
screening3.save()

customer1.buy_ticket(film1, screening1)
customer2.buy_ticket(film1, screening1)
customer2.buy_ticket(film1, screening2)

binding.pry
nil
