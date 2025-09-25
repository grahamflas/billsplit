import { Group } from "../types/BaseInterfaces";
import GroupDetailsSection from "./GroupDetailsSection";
import GroupsListCard from "./GroupsListCard";

interface Props {
  groups: Group[];
}

const GroupsListContainer = ({ groups }: Props) => {
  return (
    <div className="p-4 sm:p-6 max-w-7xl mx-auto">
      <div className="flex flex-col sm:flex-row sm:justify-between gap-4 items-center mb-6">
        <h1 className="text-3xl sm:text-4xl font-bold text-center sm:text-left w-full">
          My Groups
        </h1>

        <a
          className="rounded-md px-4 py-2 bg-indigo-400 hover:bg-indigo-500 focus:bg-indigo-500 text-white text-lg w-full sm:w-auto text-center whitespace-nowrap"
          href="/groups/new"
        >
          + Add Group
        </a>
      </div>

      {groups.length > 0 && (
        <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3 auto-rows-fr justify-center">
          {groups.map((group) => (
            <GroupsListCard group={group} key={group.id} />
          ))}
        </div>
      )}

      {groups.length === 0 && (
        <GroupDetailsSection>
          <div className="text-center">
            <h2 className="text-2xl mb-6">
              Welcome to <span className="text-indigo-500">Bill÷Split</span>!
            </h2>

            <p>
              To get started, create a Group by clicking the{" "}
              <strong>+ Add Group</strong> button
            </p>
          </div>
        </GroupDetailsSection>
      )}
    </div>
  );
};

export default GroupsListContainer;
