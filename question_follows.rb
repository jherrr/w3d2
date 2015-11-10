require_relative 'QuestionsDatabase'

class QuestionFollows
  attr_accessor :questions_id, :users_id

  def initialize(options = {})
    @questios_id, @users_id = options.values_at('questions_id', 'users_id')
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
end
