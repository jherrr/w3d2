require_relative 'questions_database'
require_relative 'questions'
require_relative 'replies'

class Users
  attr_accessor :fname, :lname

  def initialize(options = {})
    @fname, @lname = options.values_at('fname', 'lname')
  end

  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        users.id = ?
    SQL

    Users.new(result.first)
  end

  def self.find_by_name(fname, lname)
    result = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL

    results.map { |result| Users.new(result) }
  end

  def authored_questions(id)
    Question.find_by_author_id(id)
  end

  def authored_replies(id)
    Replies.find_by_id(id)
  end
end
