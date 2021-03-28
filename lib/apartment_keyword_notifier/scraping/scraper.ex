defmodule ApartmentKeywordNotifier.Scraping.Scraper do
  alias ApartmentKeywordNotifier.Listing

  @callback scrape(String.t()) :: {:ok, list(Listing.t())} | {:error, term()}
end
