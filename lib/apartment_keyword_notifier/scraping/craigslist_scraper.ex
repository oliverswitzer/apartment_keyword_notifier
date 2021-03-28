defmodule ApartmentKeywordNotifier.Scraping.CraigslistScraper do
  @http_client Application.compile_env!(:apartment_keyword_notifier, :http_client)

  defmodule Listing do
    defstruct [:name, :url, :price, :listing_detail]
  end

  defmodule ListingDetail do
    defstruct [:text, :images]
  end

  defmodule Html do
    def attribute(element, attribute) do
      Floki.attribute(element, attribute) |> List.first()
    end
  end

  def scrape(starting_url, opts \\ []) do
    uri = URI.parse(starting_url)

    if(uri.host =~ ~r/craigslist.org/) do
      delay = Keyword.get(opts, :delay, 500)
      num_results = Keyword.get(opts, :num_result, 10)

      parse(starting_url)
      |> Floki.find(".result-info")
      |> Enum.take(num_results)
      |> Enum.map(fn result ->
        Process.sleep(delay)

        url = Floki.find(result, "a") |> Html.attribute("href")
        listing_detail = fetch_listing_detail(url)

        %Listing{
          name: Floki.find(result, ".result-title") |> Floki.text(),
          url: url,
          price: Floki.find(result, ".result-price") |> Floki.text(),
          listing_detail: listing_detail
        }
      end)
      |> ok()
    else
      {:error, "Must pass a craiglist url"}
    end
  end

  defp fetch_listing_detail(url) do
    parsed_listing = parse(url)

    text =
      parsed_listing
      |> Floki.find("#postingbody")
      |> Floki.text()
      |> String.replace("QR Code Link to This Post\n", "")

    images =
      parsed_listing
      |> Floki.find(".gallery img")
      |> Enum.map(fn image -> Html.attribute(image, "src") end)

    %ListingDetail{
      text: text,
      images: images
    }
  end

  defp parse(url) when is_binary(url) do
    with {:ok, res} <- @http_client.get(url),
         {:ok, parsed_response} <- Floki.parse_document(res.body) do
      parsed_response
    end
  end

  defp ok(res) do
    {:ok, res}
  end
end
