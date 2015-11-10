
require_relative 'questions_database'

class Questions
  attr_accessor :title, :body, :author_id

  def initialize(options = {})
    @title, @body, @author_id = options.values_at('title', 'body', 'author_id')
  end

  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.id = ?
    SQL

    Questions.new(result.first)
  end

  def self.find_by_author_id(author_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions_like
      WHERE
        author_id = ?
    SQL

    results.map { |result| Questions.new(result) }
  end

  def author
    Users.find_by_id(author_id)
  end

  def replies
    Replies.find_by_question_id(id)
  end
end
