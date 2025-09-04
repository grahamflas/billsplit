import { Group } from "../types/BaseInterfaces";

interface Props {
  group: Group;
}

const GroupCard = ({ group }: Props) => {
  return (
    <div className="rounded-2xl shadow-sm hover:shadow-md transition bg-white">
      <div id={`group-${group.id}`} className="flex flex-col p-4 flex-1">
        <a href={`/groups/${group.id}`}>
          <h2 className="text-2xl">{group.name}</h2>
        </a>

        <ul>
          {group.users.map((user) => (
            <li key={user.id}>{user.email}</li>
          ))}
        </ul>
      </div>
    </div>
  );
};

export default GroupCard;
