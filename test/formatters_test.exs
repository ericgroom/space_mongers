defmodule SpaceMongers.FormattersTest do
  use ExUnit.Case, async: true

  import SpaceMongers.Formatters
  alias SpaceMongers.FullResponse

  @success {:ok, %FullResponse{
    status: 200,
    body: %{success: true}
  }}

  @failure {:error, %FullResponse{
    status: 400,
    body: %{"error" => %{"message" => "invalid"}}
  }}

  @status_failure {:ok, %FullResponse{
    status: 400,
    body: %{"error" => %{"message" => "invalid"}}
  }}

  @nonstandard_body_failure {:ok, %FullResponse{
    status: 500,
    body: %{"unknown" => "value"}
  }}

  @nonhttp_error {:error, "reason"}

  describe "format_response/3" do
    test "doesn't process sucesss response when skip_deserialization is passed" do
      result = format_response(@success, fn _resp -> raise "shouldn't be called" end, [skip_deserialization: true])
      assert {:ok, %FullResponse{
        status: 200,
        body: %{success: true}
      }} == result
    end

    test "doesn't process error response when skip_deserialization is passed" do
      result = format_response(@failure, fn _resp -> raise "shouldn't be called" end, [skip_deserialization: true])
      assert {:error, %FullResponse{
        status: 400,
        body: %{"error" => %{"message" => "invalid"}}
      }} == result
    end

    test "processes success response when skip_deserialization is not passed" do
      result = format_response(@success, fn resp -> resp.body.success end, [])
      assert {:ok, true} == result
    end

    test "processes error response when skip_deserialization is not passed" do
      result = format_response(@failure, fn _resp -> raise "shouldn't be called" end, [])
      assert {:error, "invalid"} == result
    end

    test "responses with :ok but a high response code are interpreted as errors" do
      result = format_response(@status_failure, fn _resp -> raise "shouldn't be called" end, [])
      assert {:error, "invalid"} == result
    end

    test "error responses with non-standard body return entire body" do
      result = format_response(@nonstandard_body_failure, fn _resp -> raise "shouldn't be called" end, [])
      assert {:error, %{"unknown" => "value"}} == result
    end

    test "errors with a reason other than FullResponse.t() return the reason" do
      result = format_response(@nonhttp_error, fn _resp -> raise "shouldn't be called" end, [])
      assert {:error, "reason"}
    end
  end
end
