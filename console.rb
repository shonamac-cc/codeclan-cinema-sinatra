require_relative('./models/ticket')
require_relative('./models/customer')
require_relative('./models/film')


require('pry-byebug')

Customer.delete_all()
Film.delete_all()

customer1 = Customer.new({ 'name' => 'martin', 'funds' => 100})
customer2 = Customer.new({ 'name' => 'george', 'funds' => 70})
customer3 = Customer.new({ 'name' => 'bob', 'funds' => 20})

customer1.save()
customer2.save()
customer3.save()


film1 = Film.new({ 'title' => 'Shawshank Redemption', 'price' => 10})
film2 = Film.new({ 'title' => 'Finding Nemo', 'price' => 8})
film3 = Film.new({ 'title' => 'Fast and Furious', 'price' => 9})

film1.save()
film2.save()
film3.save()

ticket1 = Ticket.new({ 'customer_id' => customer1.id, 'film_id' => film1.id})
ticket2 = Ticket.new({ 'customer_id' => customer2.id, 'film_id' => film1.id})
ticket3 = Ticket.new({ 'customer_id' => customer1.id, 'film_id' => film2.id})
ticket4 = Ticket.new({ 'customer_id' => customer3.id, 'film_id' => film2.id})
ticket5 = Ticket.new({ 'customer_id' => customer2.id, 'film_id' => film3.id})
ticket6 = Ticket.new({ 'customer_id' => customer3.id, 'film_id' => film3.id})
ticket7 = Ticket.new({ 'customer_id' => customer1.id, 'film_id' => film3.id})

ticket1.save()
ticket2.save()
ticket3.save()
ticket4.save()
ticket5.save()
ticket6.save()
ticket7.save()

binding.pry
nil
