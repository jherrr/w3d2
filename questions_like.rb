

require_relative 'questions_database.rb'

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
end
