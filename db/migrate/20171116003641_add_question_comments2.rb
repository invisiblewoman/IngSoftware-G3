class AddQuestionComments2 < ActiveRecord::Migration[5.1]
  def change
  	add_reference :comments, :question
  end
end

