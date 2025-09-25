import Avatar from "react-avatar";
import { Group } from "../types/BaseInterfaces";
import GroupedAvatars from "./GroupedAvatars";
import { ExpenseStatus } from "../enums/ExpenseStatus";

interface Props {
  group: Group;
}

const GroupsListCard = ({ group }: Props) => {
  const renderExpensesCount = () => {
    const openExpenses = group.expenses.filter(
      (expense) => expense.status === ExpenseStatus.Open
    );

    if (openExpenses.length) {
      return <p className="text-gray-700">{openExpenses.length} expenses</p>;
    }

    return <p className="text-gray-700">No expenses yet</p>;
  };

  return (
    <div className="flex flex-col p-4 rounded-2xl shadow-sm hover:shadow-md transition bg-white w-full min-w-[220px] max-w-small">
      <a href={`/groups/${group.id}`}>
        <div id={`group-${group.id}`} className="flex flex-col flex-1 gap-6">
          <h2 className="flex text-2xl font-bold items-center gap-1">
            <span>
              {group.name}
              {group.demo ? (
                <span className="bg-rose-600 text-white text-base text-bold px-2 rounded-xl ml-2">
                  Demo
                </span>
              ) : null}
            </span>
          </h2>

          <div className="flex flex-col gap-1">
            <div className="flex -space-x-2">
              <GroupedAvatars users={group.users} />
            </div>

            <p className="text-gray-700">{group.users.length} members</p>

            {renderExpensesCount()}

            <p className="text-gray-400">Created {group.readableCreatedAt}</p>
          </div>
        </div>
      </a>
    </div>
  );
};

export default GroupsListCard;
