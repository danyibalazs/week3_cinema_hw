require_relative("../db/sql_runner")

class Film

  attr_reader :id
  attr_accessor :title, :price

  def initialize(options)
    @id = options["id"].to_i() if options["id"]
    @title = options["title"]
    @price = options["price"].to_i()
  end

  def save()
    sql = "INSERT INTO films
    (title, price)
    VALUES
    ($1, $2)
    RETURNING id"
    values = [@title, @price]
    result = SqlRunner.run(sql, values)
    @id = result[0]["id"].to_i()
  end

  def delete()
    sql = "DELETE FROM films
    WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "UPDATE films
    SET
    (title, price) = ($1, $2)
    WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def customers()
    sql = "SELECT customers.* FROM customers
    INNER JOIN tickets ON
    customers.id = tickets.customer_id
    WHERE film_id = $1"
    value = [@id]
    results = SqlRunner.run(sql, value)
    customers = results.map{|customer| Customer.new(customer)}
    return customers
  end

  def customer_count()
    sql = "SELECT * FROM tickets
    WHERE film_id = $1"
    values = [@id]
    customers = SqlRunner.run(sql, values)
    return customers.count()
  end

  def popular_screening()
    sql = "SELECT * FROM tickets
    WHERE film_id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    screening_id_array = results.map{|ticket| ticket["screening_id"]}
    frequencies = Hash.new(0)
    screening_id_array.each{|id| frequencies[id] += 1}
    frequencies = frequencies.sort_by {|key, value| value}
    frequencies.reverse!
    screening_id = frequencies[0][0].to_i()
    sql = "SELECT * FROM screenings
    WHERE id = $1"
    values = [screening_id]
    result = SqlRunner.run(sql, values)
    screening = Screening.new(result[0])
    return screening.screen_time
  end

  def self.all()
    sql = "SELECT * FROM films"
    results = SqlRunner.run(sql)
    films = results.map{|film| Film.new(film)}
    return films
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

end
