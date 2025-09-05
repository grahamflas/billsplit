import { Group } from "../types/BaseInterfaces";

interface Props {
  group: Group;
}

const GroupDetails = ({ group }: Props) => {
  return (
    <div className="p-6 max-w-2xl mx-auto">
      <div className="flex flex-col">
        <div className="flex flex-row justify-between items-center">
          <h1 className="text-4xl">{group.name}</h1>

          <a
            className="rounded-md px-3 py-2 bg-indigo-400 hover:bg-indigo-500 focus:bg-indigo-500 text-white text-2xl"
            href="/expenses/new?"
          >
            + Add Expense
          </a>
        </div>

        <div>GROUP DETAILS GO HERE</div>
      </div>
    </div>
  );
};

export default GroupDetails;
