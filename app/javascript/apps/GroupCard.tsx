import Avatar from "react-avatar";
import { Group } from "../types/BaseInterfaces";

interface Props {
  group: Group;
}

const GroupCard = ({ group }: Props) => {
  const renderAvatars = () => {
    return group.users.map((user) => {
      const userName = `${user.firstName} ${user.lastName}`;

      return (
        <Avatar
          className="outline outline-white"
          key={user.id}
          name={userName}
          round
          size="50"
        />
      );
    });
  };

  const renderExpensesCount = () => {
    if (group.expenses.length) {
      return <p className="text-gray-700">{group.expenses.length} expenses</p>;
    }

    return <p className="text-gray-700">No expenses yet</p>;
  };

  return (
    <div className="rounded-2xl shadow-sm hover:shadow-md transition bg-white">
      <a href={`/groups/${group.id}`}>
        <div
          id={`group-${group.id}`}
          className="flex flex-col p-4 flex-1 gap-4"
        >
          <h2 className="text-2xl font-bold">{group.name}</h2>

          <div className="flex -space-x-2">{renderAvatars()}</div>

          <p className="text-gray-700">{group.users.length} members</p>

          {renderExpensesCount()}

          <p className="text-gray-400">Created {group.readableCreatedAt}</p>
        </div>
      </a>
    </div>
  );
};

export default GroupCard;
