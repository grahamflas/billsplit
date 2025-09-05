import { Group } from "../types/BaseInterfaces";
import GroupsListCard from "./GroupsListCard";

interface Props {
  groups: Group[];
}

const GroupsListContainer = ({ groups }: Props) => {
  return (
    <div className="p-6 max-w-7xl mx-auto">
      <div className="flex flex-col sm:flex-row gap-4 items-center justify-between mb-6">
        <h1 className="text-4xl font-bold">My Groups</h1>

        <a
          className="rounded-md px-3 py-2 bg-indigo-400 hover:bg-indigo-500 focus:bg-indigo-500 text-white text-2xl"
          href="/groups/new"
        >
          + Add Group
        </a>
      </div>

      <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3 auto-rows-fr">
        {groups.map((group) => (
          <GroupsListCard group={group} key={group.id} />
        ))}
      </div>
    </div>
  );
};

export default GroupsListContainer;
