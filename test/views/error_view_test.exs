defmodule Peepchat.ErrorViewTest do
  use Peepchat.Web.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View
  alias Peepchat.Web.ErrorView

  test "renders 401.json" do
    assert render(ErrorView, "401.json", []) ==
           %{"errors" => [%{code: 401, title: "Unauthorized"}], "jsonapi" => %{"version" => "1.0"}}
  end

  test "renders 403.json" do
    assert render(ErrorView, "403.json", []) ==
           %{"errors" => [%{code: 403, title: "Forbidden"}], "jsonapi" => %{"version" => "1.0"}}
  end

  test "renders 404.json" do
    assert render(ErrorView, "404.json", []) ==
           %{"errors" => [%{code: 404, title: "Not found"}], "jsonapi" => %{"version" => "1.0"}}
  end

  test "render 500.json" do
    assert render(ErrorView, "500.json", []) ==
           %{"errors" => [%{code: 500, title: "Internal server error"}], "jsonapi" => %{"version" => "1.0"}}
  end

  test "render any other" do
    assert render(ErrorView, "505.json", []) ==
           %{"errors" => [%{code: 500, title: "Internal server error"}], "jsonapi" => %{"version" => "1.0"}}
  end
end
