class Template < ApplicationRecord
  belongs_to :sender
  validates :title, presence: true, uniqueness: true

  def vars
    index = 0
    vars_found = []

    while index.present?
      result = find_var index
      index = result[:index]
      unless result[:variable].nil?
        vars_found << result[:variable]
      end
    end

    if vars_found.length > 0
      variables = ['email'] + vars_found
    else
      variables = []
    end

    variables
  end

  def find_var(index)
    start_index = body.index '{{', index
    if start_index.nil?
      end_index = nil
      variable = nil
    else
      start_index += 2
      end_index = body.index '}}', start_index
      variable = body[start_index, end_index - start_index]
      end_index += 2
    end
    {
        variable: variable,
        index: end_index
    }
  end

end
