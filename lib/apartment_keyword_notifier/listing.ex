defmodule ApartmentKeywordNotifier.Listing do
  @type t :: %__MODULE__{
          name: String.t(),
          url: String.t(),
          price: String.t(),
          listing_detail: ListingDetail.t()
        }

  defstruct [:name, :url, :price, :listing_detail]

  defmodule ListingDetail do
    @type t :: %__MODULE__{
            text: String.t(),
            images: list(String.t())
          }

    defstruct [:text, :images]
  end
end
