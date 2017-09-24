defmodule Writing.Parser do

  @doc """
  Converts markdown text to an html string
  """
  def to_html(text) when is_binary(text) do
    options = %Earmark.Options{
      code_class_prefix: "",
      gfm: true,
      breaks: true,
      smartypants: true
    }
    case Earmark.as_html(text, options) do
      {:ok, html_doc, _} -> html_doc
      {:error, _, _} -> ""
    end
  end
  def to_html(_), do: nil

end