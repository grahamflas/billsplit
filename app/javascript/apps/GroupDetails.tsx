import { format, max } from "date-fns";

import GroupDetailsSection from "./GroupDetailsSection";
import GroupedAvatars from "./GroupedAvatars";

import { Balances, Group } from "../types/BaseInterfaces";
import GroupDetailsData from "./GroupDetailsData";
import Expense from "./Expense";

interface Props {
  balances: Balances;
  group: Group;
}

const GroupDetails = ({ balances, group }: Props) => {
  const groupMembersList = () => {
    return group.users.map((user) => user.firstName).join(", ");
  };

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

            <div className="rounded-2xl bg-neutral-100 p-6 mx-4">
              <GroupDetailsData
                headingData="Total Expenses"
                subHeadingData={`$${balances.totalExpenses}`}
                subHeadingClasses="text-3xl mt-2"
              />
            </div>

            <div className="flex flex-row justify-between">
              <div>
                <GroupDetailsData
                  headingData="Members"
                  subHeadingData={group.users.length}
                />
              </div>

              <div>
                <GroupDetailsData
                  headingData="Expenses"
                  subHeadingData={group.expenses.length || "-"}
                />
              </div>

              <div>
                <GroupDetailsData
                  headingData="Latest Activity"
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

        <GroupDetailsSection>
          <>
            {group.expenses.map((expense, i) => (
              <Expense
                expense={expense}
                isInitialExpense={i === 0}
                key={expense.id}
              />
            ))}
          </>
        </GroupDetailsSection>
      </div>
    </div>
  );
};

export default GroupDetails;
