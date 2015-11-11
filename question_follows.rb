require_relative 'questions_database'
require_relative 'questions'

class QuestionFollows
  attr_accessor :questions_id, :users_id

  def initialize(options = {})
    @questions_id, @users_id = options.values_at('questions_id', 'users_id')
  end

  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL

    QuestionFollows.new(result.first)
  end

  def self.followers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, questions_id)
      SELECT
        u.*
      FROM
        users u
      INNER JOIN
        question_follows qf ON u.id = qf.users_id
      WHERE
        questions_id = ?
    SQL

    results.map { |result| User.new(result) }
  end

  def self.followed_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        q.*
      FROM
        questions q
      INNER JOIN
        question_follows qf ON q.id = qf.questions_id
      WHERE
        user_id = ?
    SQL

    results.map { |result| Questions.new(result) }
  end

  def self.most_followed_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        q.*
      FROM
        question_follows qf
      JOIN
        questions q
      ON
        q.id = qf.questions_id
      GROUP BY
        questions_id
      ORDER BY
        COUNT(users_id) DESC
      LIMIT ?
    SQL

    results.map { |result| Questions.new(result)}
  end
end
