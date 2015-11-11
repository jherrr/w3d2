require_relative 'questions_database'

class ModelBase

  def self.find_by_id(id, table, table_class)
    result = QuestionsDatabase.instance.execute(<<-SQL, id: id)
      SELECT
        *
      FROM
        #{table}
      WHERE
        id = :id
    SQL

    table_class.new(result.first)
  end


end
