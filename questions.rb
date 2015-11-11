require_relative 'questions_database'
require_relative 'question_follows'

class Questions < ModelBase
  attr_accessor :title, :body, :author_id, :id

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

  def save
    raise 'question already exists' if id

    QuestionsDatabase.instance.execute(<<-SQL, title, body, author_id)
      INSERT INTO
        questions
        (title, body, author_id)
      VALUES
        (?, ?, ?)
    SQL

    self.id = QuestionsDatabase.instance.last_insert_row_id
  end

  def author
    Users.find_by_id(author_id)
  end

  def replies
    Replies.find_by_question_id(id)
  end

  def followers
    QuestionFollows.followers_for_question_id(id)
  end

  def self.most_followed(n)
    QuestionFollows.most_followed_questions(n)
  end

  def likers
    QuestionsLike.likers_for_question_id(id)
  end

  def num_likes
    QuestionsLike.num_likes_for_question_id(id)
  end

  def most_liked(n)
    QuestionsLike.most_liked_questions(n)
  end
end
