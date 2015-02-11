require 'spec_helper'

describe EmailSubscriptionList do
  let(:filter_form) { double(:filter_form, page: 123) }
  let(:list) { EmailSubscriptionList.new(filter_form) }

  let(:ordered_query) { double(:ordered_query) }
  let(:paginated_query) { double(:paginated_query) }

  before do
    allow(OrderedQuery).to receive(:new).with('subscription_type ASC, accounts.email ASC') { ordered_query }
    allow(PaginatedQuery).to receive(:new).with(123) { paginated_query }
  end

  it 'is a filterable list' do
    expect(list).to be_a FilterableList
  end

  it 'configures the source' do
    expect(list.source).to be_a EmailSubscription::ActiveRecord_Relation
    expect(list.source.includes_values).to eq [:account]
    expect(list.source.joins_values).to eq [:account]
  end

  it 'configures the presenter' do
    expect(list.presenter).to eq EmailSubscriptionPresenter
  end

  it 'configures the filters' do
    expect(list.filters.length).to eq 2
    expect(list.filters).to include ordered_query
    expect(list.filters).to include paginated_query
  end
end
