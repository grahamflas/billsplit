import Avatar from "react-avatar";
import { Group } from "../types/BaseInterfaces";
import GroupedAvatars from "./GroupedAvatars";

interface Props {
  group: Group;
}

const GroupsListCard = ({ group }: Props) => {
  const renderExpensesCount = () => {
    if (group.expenses.length) {
      return <p className="text-gray-700">{group.expenses.length} expenses</p>;
    }

    return <p className="text-gray-700">No expenses yet</p>;
  };

  return (
    <div className="p-4 rounded-2xl shadow-sm hover:shadow-md transition bg-white max-w-xs sm:max-w-none">
      <a href={`/groups/${group.id}`}>
        <div id={`group-${group.id}`} className="flex flex-col flex-1 gap-6">
          <h2 className="text-2xl font-bold truncate">{group.name}</h2>

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
