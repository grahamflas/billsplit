require "rails_helper"

describe DemoData::Create do
  it "creates demo data for the new user" do
    new_user = create(
      :user,
      first_name: "Newt",
      last_name: "Newsome",
      email: "newt.newsome@mail.com"
    )

    password = "password"

    DemoData::Create.new(new_user:).process

    # Create demo users the new_user can log in as
    demo_user_1 = User.find_by(
      email: "#{new_user.email_prefix}-demo-1@demo.com",
      demo: true,
    )
    demo_user_2 = User.find_by(
      email: "#{new_user.email_prefix}-demo-2@demo.com",
      demo: true,
    )
    demo_user_3 = User.find_by(
      email: "#{new_user.email_prefix}-demo-3@demo.com",
      demo: true,
    )

    expect(demo_user_1).to be_present
    expect(demo_user_2).to be_present
    expect(demo_user_3).to be_present

    expect(demo_user_1.valid_password?(password)).to be(true)
    expect(demo_user_2.valid_password?(password)).to be(true)
    expect(demo_user_3.valid_password?(password)).to be(true)

    # Create two demo groups
    group_1 = Group.find_by(
      name: "The Rolling Loans",
      demo: true,
    )
    group_2 = Group.find_by(
      name: "Hauptstadt Heroes (Berlin trip)",
      demo: true,
    )
    expect(group_1).to be_present
    expect(group_2).to be_present

    # Create group_1 settlement
    expect(
      Settlement.find_by(
        user: demo_user_1,
        group: group_1,
      )
    ).to be_present

    # Create group_1 deleted_expense
    expect(
      Expense.find_by(
        user: demo_user_1,
        group: group_1,
        amount: 15,
        reference: "Uber trip",
        status: :deleted
      )
    ).to be_present

    # Create group_1 open expenses
    open_expense_1 = Expense.find_by(
      user: new_user,
      group: group_1,
      amount: 1800,
      reference: "Rent",
    )
    expect(open_expense_1).to be_present
    expect(open_expense_1.notifications).to be_present

    open_expense_2 = Expense.find_by(
      user: demo_user_1,
      group: group_1,
      amount: 150,
      reference: "Concert tickets",
    )
    expect(open_expense_2).to be_present
    expect(open_expense_2.notifications).to be_present

    # Create group_2 open expenses
    group_2_open_expense = Expense.find_by(
      user: demo_user_3,
      group: group_2,
      amount: 12,
      reference: "Currywurst",
    )

    expect(group_2_open_expense).to be_present
    expect(group_2_open_expense.notifications).to be_empty

    # Invite new user to group 2
    expect(
      Invitation.find_by(
        group: group_2,
        creator: demo_user_3,
        invitee: new_user,
        status: :pending,
      )
    ).to be_present


  end
end
