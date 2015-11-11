class Replies
  attr_accessor :questions_id, :reply_id, :author_id, :reply_id, :id

  def initialize(options = {})
    @questions_id, @reply_id, @author_id, @reply_body = options.values_at(
    'questions_id', 'reply_id', 'author_id', 'reply_body')
  end

  def save
    raise "reply alreay exist" if id

    QuestionsDatabase.instance.execute(<<-SQL, questions_id, reply_id,author_id, reply_body)
      INSERT INTO
        replies (questions_id, repy_id, author_id, reply_body)
      VALUES
        (?, ?, ?, ?)
    SQL

    self.id = QuestionsDatabase.instance.last_insert_row_id
  end

  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.id = ?
    SQL

    Replies.new(result.first)
  end

  def self.find_by_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL

    results.map { |result| replies.new(result) }
  end

  def author
    Users.find_by_id(author_id)
  end

  def question
    Questions.find_by_id(questions_id)
  end

  def parent_reply
    Replies.find_by_id(reply_id)
  end

  def child_replies
    results = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        replies
      WHERE
        reply_id = :id
    SQL

    results.map { |result| Reply.new(result) }
  end
end
