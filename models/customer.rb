require_relative('../db/sql_runner')

class Customer

  attr_reader :id
  attr_accessor :name, :funds

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds']
  end

  def save()
    sql = " INSERT INTO customers (
    name,
    funds
    )
    VALUES ($1, $2)
    RETURNING id"
    values = [@name, @funds]
    customer = SqlRunner.run(sql, values)[0]
    @id = customer['id'].to_i
  end

  def update()
    sql = " UPDATE customers SET (name, funds) = ($1, $2) WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM customers where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM customers"
    customers = SqlRunner.run(sql)
    result = customers.map{ |customer| Customer.new( customer )}
    return result
  end

  def self.delete_all
    sql = "DELETE FROM customers"
    values = []
    SqlRunner.run(sql, values)
  end

  def films()
    sql = "SELECT films.* FROM films
    INNER JOIN tickets ON films.id = tickets.film_id
    WHERE customer_id = $1 ORDER BY price"
    values = [@id]
    film_data = SqlRunner.run(sql, values)
    return film_data.map{ |film| Film.new(film)}
  end

  def film_count()
    return films.count
  end

  # count number of tickets a customer has using sql query
  def ticket_count_sql()
    sql = "SELECT COUNT(*) FROM tickets
    WHERE customer_id = $1"
    values = [@id]
    SqlRunner.run(sql, values)[0]['count'].to_i
  end

  def tickets()
    sql = "SELECT * FROM tickets where customer_id = $1"
    values = [@id]
    ticket_data = SqlRunner.run(sql, values)
    return ticket_data.map{ |ticket| Ticket.new(ticket) }
  end

  # Check if customer has sufficient funds then calculate customer funds based on one film and add ticket for the film to tickets table
  def buy(film)
    if @funds >= film.film_price
      bought_ticket = Ticket.new({ 'customer_id' => @id, 'film_id' => film.id})
      bought_ticket.save
      @funds -= film.film_price
      update
    end
    return "insufficient funds, ask your mate for a loan"
  end

  # calculate customer funds based on all films they have tickets for, used imdb end code as an example
  # This creates an array of the price for all films a customer is going to see, converts to an integer, then combines all the values.  This combined price is then deducted from customer funds
  def remaining_funds()
    films = self.films()
    film_prices = films.map{ |film| film.price.to_i}
    combined_prices = film_prices.sum
    @funds -= combined_prices
    update
  end

end
