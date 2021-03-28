defmodule ApartmentKeywordNotifier.Scraping.CraigslistScraperTest do
  alias ApartmentKeywordNotifier.Scraping.CraigslistScraper
  alias ApartmentKeywordNotifier.Scraping.Scraper

	use ExUnit.Case

	doctest ApartmentKeywordNotifier.Scraping.CraigslistScraper

  setup_all do
    Hammox.protect(CraigslistScraper, Scraper)
  end

  describe "scrape/2" do
    test "returns an error when not a craiglist url", %{scrape_1: scrape_1} do
      url = "http://example.com"

      assert {:error, "Must pass a craiglist url" } = scrape_1.(url)
    end
  end
end
