require_relative 'questions_database.rb'
require_relative 'users'

class QuestionsLike
  attr_accessor :users_id, :questions_id

  def initialize(options = {})
    @users_id, @questions_id = options.values_at('users_id', 'questions_id')
  end

  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions_like
      WHERE
        question_like.id = ?
    SQL

    QuestionsLike.new(result.first)
  end

  def self.likers_for_question_id(questions_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, questions_id)
      SELECT
      u.*
      FROM
        questions_like ql
      JOIN
        users u
      ON
        ql.users_id = u.id
      WHERE
        ql.questions_id = ?
    SQL

    results.map { |result| Users.new(result) }
  end

  def self.num_likes_for_question_id(questions_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, questions_id)
      SELECT
        COUNT(users_id) num_likes
      FROM
        questions_like ql
      JOIN
        users u
      ON
        ql.users_id = u.id
      WHERE
        ql.questions_id = ?
    SQL

    results.first["num_likes"]
  end

   def self.liked_questions_for_user_id(user_id)
     results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        q.*
      FROM
        questions q
      JOIN
        questions_like ql
      ON
        ql.questions_id = q.id
      WHERE
        ql.users_id = ?
    SQL

    results.map { |result| Questions.new(result) }
  end

  def self.most_liked_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        q.*
      FROM
        questions q
      JOIN
        questions_like ql
      ON
        q.id = ql.questions_id
      GROUP BY
        q.id
      ORDER BY
        COUNT(ql.users_id) DESC
      LIMIT ?
    SQL

    results.map { |result| Questions.new(result) }
  end
end
