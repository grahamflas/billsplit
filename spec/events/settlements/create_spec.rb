require "rails_helper"

describe Settlements::Create do
  it "creates a settlement, marks the associated expenses as :settled", :aggregate_failures do
    group = create(:group)
    other_group = create(:group )

    user = create(:user, groups: [ group, other_group ])
    other_user = create(:user, groups: [ group, other_group ])

    expense_1 = create(
      :expense,
      amount: 10,
      user:,
      group:,
    )
    expense_2 = create(
      :expense,
      amount: 20,
      user: other_user,
      group:,
    )
    deleted_expense = create(
      :expense,
      :deleted,
      amount: 30,
      user:,
      group:,
    )

    other_group_expense_1 = create(
      :expense,
      amount: 10,
      user:,
      group: other_group,
    )
    other_group_expense_2 = create(
      :expense,
      amount: 20,
      user: other_user,
      group: other_group,
    )
    other_group_deleted_expense = create(
      :expense,
      :deleted,
      amount: 30,
      user:,
      group: other_group,
    )

    balances = Balances.new(group:).compute
    other_group_balances = Balances.new(group: other_group).compute

    expect do
      Settlements::Create.new(
        group:,
        initiator: user,
        balances:,
      ).process
    end.to change(Settlement, :count).by(1)

    settlement = Settlement.last

    expect(settlement.group).to eq(group)
    expect(settlement.user).to eq(user)
    expect(settlement.balances).to eq(balances.deep_stringify_keys)

    expect(expense_1.reload.settled?).to eq(true)
    expect(expense_2.reload.settled?).to eq(true)
    expect(deleted_expense.reload.deleted?).to eq(true)
    expect(
      Balances.new(group:).compute[:totalExpenses],
    ).to eq(0)

    expect(other_group_expense_1.reload.open?).to eq(true)
    expect(other_group_expense_2.reload.open?).to eq(true)
    expect(other_group_deleted_expense.reload.deleted?).to eq(true)
    expect(
      Balances.new(group: other_group).compute,
    ).to eq(other_group_balances)
  end

  it "runs the process in a transaction" do
    group = create(:group)

    user = create(:user, groups: [ group ])
    other_user = create(:user, groups: [ group ])

    create(
      :expense,
      amount: 10,
      user:,
      group:,
    )
    create(
      :expense,
      amount: 20,
      user: other_user,
      group:,
    )

    balances = Balances.new(group:).compute

    allow_any_instance_of(Expense).
      to receive(:update!).
      and_raise(ActiveRecord::RecordInvalid)

    expect do
      begin
        Settlements::Create.new(
          group:,
          initiator: user,
          balances:,
        ).process
      rescue ActiveRecord::RecordInvalid
        #noop
      end
    end.not_to change(Settlement, :count)
  end
end
