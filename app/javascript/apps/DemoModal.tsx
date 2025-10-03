import { IoCopyOutline } from "react-icons/io5";

import Modal from "./Modal";

import { User } from "../types/BaseInterfaces";
import { toast } from "react-toastify";

interface Props {
  currentUser: User;
  demoUsers: User[];
  handleModalClose: () => void;
  isOpen: boolean;
}

const DemoModal = ({
  currentUser,
  demoUsers,
  handleModalClose,
  isOpen,
}: Props) => {
  const setClipboardText = async (text: string) => {
    const type = "text/plain";
    const clipboardItemData = {
      [type]: text,
    };
    const clipboardItem = new ClipboardItem(clipboardItemData);

    try {
      await navigator.clipboard.write([clipboardItem]);

      toast(`${text} copied to clipboard`);
    } catch (error) {
      toast("Something went wrong");
    }
  };

  return (
    <Modal
      isOpen={isOpen}
      onCloseModal={handleModalClose}
      title={"About this demo"}
    >
      <div className="w-full sm:max-w-[50vw]">
        <h1 className="text-3xl text-indigo-500 text-center mb-6">
          {currentUser.firstName
            ? `Hi, ${currentUser.firstName}. Welcome to BillSplit!`
            : "Welcome to BillSplit!"}
        </h1>

        <p className="mb-6">
          To help you to explore all of BillSplit's features, we generated some
          demo data when you signed up.
        </p>

        <h2 className="text-2xl mb-2">Demo Groups</h2>

        <p>
          You are currently a member of the{" "}
          <span className="font-bold text-lg text-indigo-500">
            The Rolling Loans{" "}
          </span>{" "}
          and have been invited to join{" "}
          <span className="font-bold text-lg text-indigo-500">
            Hauptstadt Heroes (Berlin trip)
          </span>
          .
        </p>

        <p className="mb-6">
          If you haven't already, check your notifications to accept the group
          invite.
        </p>

        <p>With these demo groups, you can:</p>

        <ul className="ml-4">
          <li className="mb-1">
            <span className="text-2xl ml-2">&#9989;</span> Add new expenses
          </li>

          <li className="mb-1">
            <span className="text-2xl ml-2">&#x1F527;</span> Update existing
            expenses
          </li>

          <li className="mb-1">
            <span className="text-2xl ml-2">&#x1F4B8;</span> Settle open
            expenses to reset the group's balances
          </li>

          <li className="mb-1">
            <span className="text-2xl ml-2">&#x1F50D;</span> Review past
            settlements
          </li>

          <li className="mb-1">
            <span className="text-2xl ml-2">&#x1F5C4; &#x1F512;</span> Archive
            groups
          </li>

          <li className="mb-1">
            <span className="text-2xl ml-2">&#x1F48C; &#x1F464; </span> Invite
            new group members,{" "}
            <span className="italic">
              even if they don't have a{" "}
              <span className="font-bold text-indigo-500">BillSplit</span>{" "}
              account yet
            </span>
          </li>
        </ul>

        <h2 className="text-2xl mt-6 mb-2">Demo Users</h2>

        <p className="mb-2">Demo user login credentials based on your email:</p>

        <table className="w-full border border-neutral-300 rounded-lg overflow-hidden text-sm sm:text-base mb-4">
          <thead>
            <tr className="bg-neutral-100">
              <th className="border border-neutral-200 px-3 py-2 text-left">
                Name
              </th>

              <th className="border border-neutral-200 px-3 py-2 text-left">
                Email
              </th>

              <th className="border border-neutral-200 px-3 py-2 text-left">
                Password
              </th>
            </tr>
          </thead>

          <tbody>
            {demoUsers.map((demoUser) => (
              <tr key={demoUser.id} className="bg-white even:bg-neutral-50">
                <td className="border border-neutral-200 px-3 py-2 break-all">
                  {demoUser.fullName}
                </td>

                <td className="border border-neutral-200 px-3 py-2 break-all">
                  <span className="inline-flex item-center gap-1">
                    <span className="font-mono bg-neutral-800 text-indigo-200 px-2 py-1 rounded">
                      {demoUser.email}
                    </span>

                    <button onClick={() => setClipboardText(demoUser.email)}>
                      <IoCopyOutline size={20} />
                    </button>
                  </span>
                </td>

                <td className="border border-neutral-200 px-3 py-2">
                  <span className="font-mono bg-neutral-800 text-indigo-200 px-2 py-1 rounded">
                    password
                  </span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>

        <p className="mb-2">
          We've also created some demo users so that you can see how activity
          within a group looks from the perspective of other group members.
        </p>

        <p className="mb-2">
          For example, adding/ editing an expense will create a notification in
          the{" "}
          <span className="inline-flex items-center gap-2 px-4 py-2 bg-gray-800 text-white">
            Notifications
            <span className="w-6 h-6 rounded-full flex justify-center items-center bg-rose-500 p-2">
              1
            </span>
          </span>{" "}
          menu for all other group members so that they can keep on top of any
          changes you've made.
        </p>
      </div>
    </Modal>
  );
};

export default DemoModal;
