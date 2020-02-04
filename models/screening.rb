require_relative("../db/sql_runner")

class Screening

  attr_reader :id
  attr_accessor :film_id, :screen_time, :capacity

  def initialize(options)
    @id = options["id"].to_i() if options["id"]
    @film_id = options["film_id"].to_i()
    @screen_time = options["screen_time"]
    @capacity = options["capacity"].to_i()
  end

  def save()
    sql = "INSERT INTO screenings
    (film_id, screen_time, capacity)
    VALUES
    ($1, $2, $3)
    RETURNING id"
    values = [@film_id, @screen_time, @capacity]
    result = SqlRunner.run(sql, values)
    @id = result[0]["id"].to_i()
  end

  def delete()
    sql = "DELETE FROM screenings
    WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "UPDATE screenings
    SET
    (film_id, screen_time, capacity) = ($1, $2, $3)
    WHERE id = $4"
    values = [@film_id, @screen_time, @capacity, @id]
    SqlRunner.run(sql, values)
  end

  def tickets()
    sql = "SELECT * FROM tickets WHERE screening_id = $1"
    values = [@id]
    # continue
  end

  def seats_left()
    number_of_tickets_sold = tickets().count()
    seats_left = capacity - number_of_tickets_sold
    return seats_left
  end

  def self.all()
    sql = "SELECT * FROM screenings"
    results = SqlRunner.run(sql)
    screenings = results.map{|screening| Screening.new(screening)}
    return screenings
  end

  def self.delete_all()
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end

end
