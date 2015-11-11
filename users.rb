require_relative 'questions'
require_relative 'replies'
require_relative 'model_base'

class Users < ModelBase
  attr_accessor :fname, :lname, :id

  def initialize(options = {'id' => nil})
    @id, @fname, @lname = options.values_at('id', 'fname', 'lname')
  end

  def save
    if id
      update
    else
      QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
        INSERT INTO
          users ('fname', 'lname')
        VALUES
          (?, ?)
      SQL

      self.id = QuestionsDatabase.instance.last_insert_row_id
    end
  end

  def update
    QuestionsDatabase.instance.execute(<<-SQL, fname, lname, id)
      UPDATE
        users
      SET
        fname = ?,
        lname = ?
      WHERE
        users.id = ?
    SQL
  end

  def self.find_by_id(id)
    super(id, "users", self)
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

  def followed_questions
    QuestionFollows.followed_questions_for_user_id(id)
  end

  def liked_questions
    QuestionsLike.liked_questions_for_user_id(id)
  end

  def average_karma
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        CAST(COUNT(ql.users_id) AS FLOAT)/COUNT(DISTINCT(q.id)) avg_karma
      FROM
        questions q
      LEFT OUTER JOIN
        questions_like ql
      ON
        q.id = ql.questions_id
      WHERE
        q.author_id = ?
    SQL

    results.first["avg_karma"]
  end
end
