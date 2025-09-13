import { useState } from "react";
import { Balances, Expense, Group, User } from "../types/BaseInterfaces";
import BalancesData from "./BalancesData";
import GroupDetailsData from "./GroupDetailsData";
import Modal from "./Modal";

interface Props {
  balances: Balances;
  currentUser: User;
  id?: string;
  isOpen: boolean;
  onClose: () => void;
  title: string;
}

const SettleExpensesModal = ({
  balances,
  currentUser,
  id,
  isOpen,
  onClose,
  title,
}: Props) => {
  const [note, setNote] = useState<string | undefined>(undefined);

  return (
    <Modal id={id} isOpen={isOpen} onCloseModal={onClose} title={title}>
      <div className="max-w-2xl">
        <div className="flex flex-col gap-2 mb-4">
          <p>
            You are about to settle expenses for this group. All open expenses
            will be marked as "settled" and the group's balances will be reset.
          </p>

          <p>
            By proceeding, you acknowledge that the following outstanding
            balances have been paid:
          </p>
        </div>

        <div id="balances" className="rounded-2xl bg-neutral-100 p-6 mx-4 mb-4">
          <GroupDetailsData
            headingData="Total Expenses"
            id={"total-expenses-to-settle"}
            subHeadingData={Intl.NumberFormat("en-US", {
              style: "currency",
              currency: "USD",
            }).format(balances.totalExpenses)}
            subHeadingClasses="text-3xl mt-2"
          />

          <div className="mt-8">
            <BalancesData balances={balances} currentUser={currentUser} />
          </div>
        </div>

        <label htmlFor="note">
          Leave an optional note describing, <i>e.g.</i>, how these expenses
          were settled, or anything else you'd like to mention.
        </label>

        <textarea
          name="note"
          id="note"
          className="border border-cream-300 border-2 w-full max-w-3/4 mt-2"
          onChange={(e) => setNote(e.target.value)}
          value={note}
        />

        <div className="flex justify-between mt-10">
          <button
            className="rounded-md px-3 py-1 border border-indigo-400 hover:bg-neutral-100 focus:bg-neutral-300 text-indigo-500 text-center"
            type="button"
          >
            cancel
          </button>

          <button
            className="rounded-md px-3 py-1 bg-indigo-400 hover:bg-indigo-500 focus:bg-indigo-500 text-white text-center"
            onClick={() => console.log("settling expenses")}
          >
            settle
          </button>
        </div>
      </div>
    </Modal>
  );
};

export default SettleExpensesModal;
