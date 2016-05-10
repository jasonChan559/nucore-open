require "rails_helper"

RSpec.describe AvailableAccountsFinder do
  subject(:accounts) { described_class.new(user, facility, current: current).accounts }

  let(:user) { FactoryGirl.create(:user) }
  let(:facility) { FactoryGirl.create(:facility) }
  let(:current) { nil }

  describe "a global account" do
    let!(:chartstring) { FactoryGirl.create(:nufs_account, :with_account_owner, owner: user) }

    describe "for any facility" do
      it { is_expected.to eq([chartstring]) }
    end
  end

  describe "with current" do
    let!(:chartstring) { FactoryGirl.create(:nufs_account, :with_account_owner, owner: user) }
    let(:current) { chartstring }

    it "has the account only once" do
      is_expected.to eq([chartstring])
    end

    describe "and that account is expired" do
      before { chartstring.update_attributes!(suspended_at: 1.month.ago) }

      it "still has it available" do
        is_expected.to eq([chartstring])
      end
    end
  end

  describe "with an expired account" do
    let(:expired_account) { FactoryGirl.create(:nufs_account, :with_account_owner, owner: user, expires_at: 1.month.ago) }

    it { is_expected.to be_empty }
  end

  describe "with a suspended account" do
    let(:suspended_account) { FactoryGirl.create(:nufs_account, :with_account_owner, owner: user, suspended_at: 1.month.ago) }
    it { is_expected.to be_empty }
  end
end