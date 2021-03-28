defmodule ApartmentKeywordNotifier.Scraping.CraigslistScraperTest do
  alias ApartmentKeywordNotifier.Scraping.CraigslistScraper
  alias ApartmentKeywordNotifier.Scraping.Scraper
  alias ApartmentKeywordNotifier.HTTPoisonMock

  use ExUnit.Case

  doctest ApartmentKeywordNotifier.Scraping.CraigslistScraper

  setup_all do
    Hammox.protect(CraigslistScraper, Scraper)
  end

  describe "scrape/2" do
    test "returns an error when not a craiglist url", %{scrape_1: scrape_1} do
      url = "http://example.com"

      assert {:error, "Must pass a craiglist url"} = scrape_1.(url)
    end

    test "returns Listings for the given url", %{scrape_1: scrape_1} do
      url = "https://newyork.craigslist.org/d/apartments-housing-for-rent/search/apa"

      Mox.expect(HTTPoisonMock, :get, fn called_url ->
        assert called_url == url

        {:ok,
         %HTTPoison.Response{status_code: 200, body: "<html><head></head><body></body</html>"}}
      end)

      assert {:ok, []} = scrape_1.(url)
    end
  end
end
