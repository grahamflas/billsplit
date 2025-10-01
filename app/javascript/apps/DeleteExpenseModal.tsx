import { format } from "date-fns";

import Modal from "./Modal";
import GroupDetailsData from "./GroupDetailsData";

import { Expense } from "../types/BaseInterfaces";
import ExpensesRepository from "../repositories/ExpensesRepository";
import { formatCurrency } from "../utils/formatCurrency";

interface Props {
  expense: Expense;
  isOpen: boolean;
  onClose: () => void;
}

const DeleteExpenseModal = ({ expense, isOpen, onClose }: Props) => {
  const handleDelete = async () => {
    const success = await ExpensesRepository.delete(expense.id);

    if (success) {
      window.location.href = `/groups/${expense.groupId}`;
    }
  };

  return (
    <Modal
      isOpen={isOpen}
      onCloseModal={onClose}
      title={`Delete ${expense.reference}`}
    >
      <div className="flex flex-col items-center gap-6">
        <div className="flex flex-col items-center">
          <h1 className="text-2xl text-rose-600">Are you sure?</h1>

          <p>You're about to delete:</p>
        </div>

        <div className="flex flex-col gap-2 justify-center items-center rounded-2xl bg-neutral-100 p-6 mx-4">
          <GroupDetailsData
            containerClasses="flex flex-col items-center"
            headingData={expense.reference}
            headingClasses="text-2xl"
            subHeadingData={`Paid by ${expense.user.firstName} ${
              expense.user.lastName
            } on ${format(new Date(expense.createdAt), "MMM d, yyyy")}`}
            subHeadingClasses="text-neutral-500"
          />

          <h4 className="text-4xl">{formatCurrency(expense.amount)}</h4>
        </div>

        <div className="flex justify-between w-full">
          <button
            className="rounded-md px-3 py-1 border border-indigo-400 hover:bg-neutral-100 focus:bg-neutral-300 text-indigo-500 text-center"
            type="button"
            onClick={onClose}
          >
            cancel
          </button>

          <button
            className="rounded-md px-3 py-1 bg-rose-400 hover:bg-rose-500 focus:bg-rose-500 text-white text-center"
            type="button"
            onClick={handleDelete}
            aria-label={`Delete expense ${expense.reference}`}
          >
            delete
          </button>
        </div>
      </div>
    </Modal>
  );
};

export default DeleteExpenseModal;
