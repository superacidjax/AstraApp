require "test_helper"

class TypeInferenceTest < ActiveSupport::TestCase
  include TypeInference

  # Numeric Tests
  test "should infer numeric for integer values" do
    assert_equal "numeric", infer_type("12345")
  end

  test "should infer numeric for decimal values" do
    assert_equal "numeric", infer_type("123.45")
  end

  test "should not infer numeric for mixed strings" do
    assert_equal "text", infer_type("12a34")
    assert_equal "text", infer_type("abc123.45")
  end

  # Boolean Tests
  test "should infer boolean for true" do
    assert_equal "boolean", infer_type("true")
    assert_equal "boolean", infer_type("True")
    assert_equal "boolean", infer_type("TRUE")
  end

  test "should infer boolean for false" do
    assert_equal "boolean", infer_type("false")
    assert_equal "boolean", infer_type("False")
    assert_equal "boolean", infer_type("FALSE")
  end

  test "should not infer boolean for invalid true/false values" do
    assert_equal "text", infer_type("truely")
    assert_equal "text", infer_type("falsey")
  end

  # Datetime Tests
  test "should infer datetime for ISO 8601 format" do
    assert_equal "datetime", infer_type("2024-09-25T08:28:24Z")
    assert_equal "datetime", infer_type("2024-09-25T08:28:24.123Z")
  end

  test "should not infer datetime for invalid ISO 8601 format" do
    assert_equal "text", infer_type("2024/09/25 08:28:24")
    assert_equal "text", infer_type("2024-09-25 08:28:24")
  end

  # General Text Tests
  test "should infer text for general strings" do
    assert_equal "text", infer_type("Boat533.5")
    assert_equal "text", infer_type("Hello World")
    assert_equal "text", infer_type("130/90")
  end
end
