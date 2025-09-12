import { format, max } from "date-fns";

import BalancesData from "./BalancesData";
import BillSplitAccordion from "./BillSplitAccordion";
import Expense from "./Expense";
import GroupDetailsData from "./GroupDetailsData";
import GroupDetailsSection from "./GroupDetailsSection";
import GroupedAvatars from "./GroupedAvatars";

import { Balances, Group, User } from "../types/BaseInterfaces";
import { ExpenseStatus } from "../enums/ExpenseStatus";

interface Props {
  balances: Balances;
  currentUser: User;
  group: Group;
}

const GroupDetails = ({ balances, currentUser, group }: Props) => {
  const groupMembersList = () => {
    return group.users.map((user) => user.firstName).join(", ");
  };

  const openExpenses = group.expenses.filter(
    (expense) => expense.status === ExpenseStatus.Open
  );

  const deletedExpenses = group.expenses.filter(
    (expense) => expense.status === ExpenseStatus.Deleted
  );

  const latestDate = () => {
    if (group.expenses.length > 0) {
      const dates = group.expenses.map(
        (expense) => new Date(expense.createdAt)
      );

      return format(max(dates), "MMM d, yyyy");
    }

    return "-";
  };

  return (
    <div className="p-6 max-w-2xl mx-auto">
      <div className="flex flex-col gap-6">
        <GroupDetailsSection>
          <>
            <div className="flex flex-row justify-between">
              <div className="flex flex-col gap-1">
                <h2 className="text-4xl">{group.name}</h2>

                <span className="text-neutral-500">{groupMembersList()}</span>
              </div>

              <div className="flex flex-row -space-x-2">
                <GroupedAvatars users={group.users} />
              </div>
            </div>

            <div id="balances" className="rounded-2xl bg-neutral-100 p-6 mx-4">
              <GroupDetailsData
                headingData="Total Expenses"
                id={"total-expenses"}
                subHeadingData={Intl.NumberFormat("en-US", {
                  style: "currency",
                  currency: "USD",
                }).format(balances.totalExpenses)}
                subHeadingClasses="text-3xl mt-2"
              />

              <div className="mt-8">
                <BalancesData balances={balances} currentUser={currentUser} />
              </div>
            </div>

            <div className="flex flex-row justify-between">
              <div>
                <GroupDetailsData
                  headingData="Members"
                  id="group-members-count"
                  subHeadingData={group.users.length}
                />
              </div>

              <div>
                <GroupDetailsData
                  headingData="Expenses"
                  id="open-expenses-count"
                  subHeadingData={openExpenses.length || "-"}
                />
              </div>

              <div>
                <GroupDetailsData
                  headingData="Latest Activity"
                  id="latest-activity"
                  subHeadingData={latestDate()}
                />
              </div>
            </div>
          </>
        </GroupDetailsSection>

        <a
          className="rounded-md px-3 py-2 bg-indigo-400 hover:bg-indigo-500 focus:bg-indigo-500 text-white text-2xl text-center"
          href={`/expenses/new?group_id=${group.id}`}
        >
          + Add Expense
        </a>

        {openExpenses.length > 0 && (
          <GroupDetailsSection id="open-expenses">
            <>
              {openExpenses.map((expense, i) => (
                <Expense
                  expense={expense}
                  group={group}
                  isInitialExpense={i === 0}
                  key={expense.id}
                />
              ))}
            </>
          </GroupDetailsSection>
        )}

        {deletedExpenses.length > 0 && (
          <GroupDetailsSection id="deleted-expenses">
            <BillSplitAccordion
              headingContent="Deleted Expenses"
              triggerId="deleted-expenses-accordion"
            >
              <div className="flex flex-col gap-6 mt-6">
                {deletedExpenses.map((expense, i) => (
                  <Expense
                    expense={expense}
                    group={group}
                    isInitialExpense={i === 0}
                    key={expense.id}
                  />
                ))}
              </div>
            </BillSplitAccordion>
          </GroupDetailsSection>
        )}
      </div>
    </div>
  );
};

export default GroupDetails;
