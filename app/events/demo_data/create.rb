module DemoData
  class Create
    def initialize(new_user:)
      @new_user = new_user
    end

    def process
      ApplicationRecord.transaction do
        create_demo_accounts_for_user

        create_group_1
        create_group_2

        create_group_1_settlement
        create_group_1_deleted_expense
        create_group_1_open_expenses

        create_group_2_open_expense
        invite_new_user_to_group_2
      end
    end

    private

    attr_reader(
      :new_user,
      :demo_user_1,
      :demo_user_2,
      :demo_user_3,
      :group_1,
      :group_2
    )

    def create_demo_accounts_for_user
      password = "password"

      @demo_user_1 = User.create!(
        first_name: "Al",
        last_name: "Gorithm",
        email: "#{new_user.email_prefix}-demo-1@#{new_user.email_domain}",
        password:,
        password_confirmation: password,
        demo: true,
      )

      @demo_user_2 = User.create!(
        first_name: "Sabrina",
        last_name: "Sample",
        email: "#{new_user.email_prefix}-demo-2@#{new_user.email_domain}",
        password:,
        password_confirmation: password,
        demo: true,
      )

      @demo_user_3 = User.create!(
        first_name: "Faira",
        last_name: "Share",
        email: "#{new_user.email_prefix}-demo-3@#{new_user.email_domain}",
        password:,
        password_confirmation: password,
        demo: true,
      )
    end

    def create_group_1
      @group_1 = Group.create!(
        name: "The Rolling Loans",
        users: [
          new_user,
          @demo_user_1,
          @demo_user_2,
        ],
        demo: true,
      )
    end

    def create_group_2
      @group_2 = Group.create!(
        name: "Hauptstadt Heroes (Berlin trip)",
        users: [ @demo_user_3 ],
        demo: true
      )
    end

    def create_group_1_settlement
      Expense.create(
        user: new_user,
        group: group_1,
        amount: 30,
        reference: "Sushi takeout",
      )
      Expense.create(
        user: demo_user_1,
        group: group_1,
        amount: 24,
        reference: "Cinema tickets",
      )
      Expense.create(
        user: demo_user_2,
        group: group_1,
        amount: 20,
        reference: "Coffee",
      )

      Settlements::Create.new(
        group: group_1,
        initiator: demo_user_1,
        balances: Balances.new(group: group_1).compute,
        note: "Paid with cash",
      ).process
    end

    def create_group_1_deleted_expense
      Expense.create!(
        user: demo_user_1,
        group: group_1,
        amount: 15,
        reference: "Uber trip",
        status: :deleted
      )
    end

    def create_group_1_open_expenses
      expense_1 = Expense.create!(
        user: new_user,
        group: group_1,
        amount: 1800,
        reference: "Rent",
      )

      expense_1.notify_other_group_users(current_user: new_user)

      expense_2 = Expense.create!(
        user: demo_user_1,
        group: group_1,
        amount: 150,
        reference: "Concert tickets",
      )

      expense_2.notify_other_group_users(current_user: demo_user_1)
    end

    def create_group_2_open_expense
      expense = Expense.create!(
        user: demo_user_3,
        group: group_2,
        amount: 12,
        reference: "Currywurst",
      )

      expense.notify_other_group_users(current_user: demo_user_3)
    end

    def invite_new_user_to_group_2
      Invitations::Create.new(
        creator: demo_user_3,
        invitee_email: new_user.email,
        group: group_2,
      ).process
    end
  end
end
