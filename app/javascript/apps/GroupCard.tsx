import { Group } from "../types/BaseInterfaces";

interface Props {
  group: Group;
}

const GroupCard = ({ group }: Props) => {
  const renderExpensesCount = () => {
    if (group.expenses.length) {
      return <p className="text-gray-700">{group.expenses.length} expenses</p>;
    }

    return <p className="text-gray-700">No expenses yet</p>;
  };

  return (
    <div className="rounded-2xl shadow-sm hover:shadow-md transition bg-white">
      <div id={`group-${group.id}`} className="flex flex-col p-4 flex-1 gap-4">
        <a href={`/groups/${group.id}`}>
          <h2 className="text-2xl font-bold">{group.name}</h2>
        </a>

        <p className="text-gray-700">{group.users.length} members</p>

        {renderExpensesCount()}

        <p className="text-gray-400">Created {group.readableCreatedAt}</p>
      </div>
    </div>
  );
};

export default GroupCard;
