module TypeInference
  def infer_type(value)
    case value
    when /\A\d+(\.\d+)?\z/
      "numeric"
    when /\Atrue\z/i, /\Afalse\z/i
      "boolean"
    when /\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?Z\z/
      "datetime"
    else
      "text"
    end
  end
end
