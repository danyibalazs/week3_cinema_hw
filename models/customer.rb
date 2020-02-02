require_relative("../db/sql_runner")

class Customer

  attr_reader :id
  attr_accessor :name, :funds

  def initialize(options)
    @id = options["id"].to_i() if options["id"]
    @name = options["name"]
    @funds = options["funds"].to_i()
  end

  def save()
    sql = "INSERT INTO customers
    (name, funds)
    VALUES
    ($1, $2)
    RETURNING id"
    values = [@name, @funds]
    result = SqlRunner.run(sql, values)
    @id = result[0]["id"].to_i()
  end

  def delete()
    sql = "DELETE FROM customers
    WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "UPDATE customers
    SET
    (name, funds) = ($1, $2)
    WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def films()
    sql = "SELECT films.* FROM films
    INNER JOIN tickets ON
    films.id = tickets.film_id
    WHERE customer_id = $1"
    value = [@id]
    results = SqlRunner.run(sql, value)
    films = results.map{|film| Film.new(film)}
    return films
  end

  def buy_ticket(film, screening)
    return if @funds < film.price
    return if screening.capacity == 0
    return if film.id != screening.film_id
    @funds -= film.price
    self.update()
    screening.capacity -= 1
    screening.update()
    ticket = Ticket.new({
      "customer_id" => @id,
      "film_id" => film.id,
      "screening_id" => screening.id
      })
    ticket.save()
  end

  def ticket_count()
    sql = "SELECT * FROM tickets
    WHERE customer_id = $1"
    values = [@id]
    tickets = SqlRunner.run(sql, values)
    return tickets.count()
  end

  def self.all()
    sql = "SELECT * FROM customers"
    results = SqlRunner.run(sql)
    customers = results.map{|customer| Customer.new(customer)}
    return customers
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

end
