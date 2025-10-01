import { useState } from "react";

import { format } from "date-fns";

import { formatCurrency } from "../utils/formatCurrency";

import ExpenseEditPopover from "./ExpenseEditPopover";
import EditExpenseModal from "./EditExpenseModal";
import DeleteExpenseModal from "./DeleteExpenseModal";
import GroupDetailsData from "./GroupDetailsData";

import { Expense, Group } from "../types/BaseInterfaces";
import { ExpenseStatus } from "../enums/ExpenseStatus";

interface Props {
  expense: Expense;
  group: Group;
  isInitialExpense: boolean;
}

const Expense = ({ expense, group, isInitialExpense }: Props) => {
  const [showEditExpenseModal, setShowEditExpenseModal] = useState(false);
  const [showDeleteExpenseModal, setShowDeleteExpenseModal] = useState(false);

  const renderBadge = () => {
    if (expense.status === ExpenseStatus.Deleted) {
      return (
        <span className="bg-rose-600 text-white text-xs text-bold px-2 rounded-xl">
          Deleted
        </span>
      );
    }
  };

  return (
    <>
      {!isInitialExpense && <hr />}

      <div
        className="flex justify-between items-center"
        id={`expense-${expense.id}`}
      >
        <GroupDetailsData
          headingData={
            <div className="flex flex-row items-center justify-start gap-2">
              {expense.reference}
              {renderBadge()}
            </div>
          }
          headingClasses="text-2xl"
          subHeadingData={`Paid by ${expense.user.firstName} ${
            expense.user.lastName
          } on ${format(new Date(expense.createdAt), "MMM d, yyyy")}`}
          subHeadingClasses="text-neutral-500"
        />

        <div className="flex gap-4">
          <div className="text-2xl">{formatCurrency(expense.amount)}</div>

          <ExpenseEditPopover
            expense={expense}
            onEdit={() => setShowEditExpenseModal(true)}
            onDelete={() => setShowDeleteExpenseModal(true)}
          />
        </div>
      </div>

      <EditExpenseModal
        expense={expense}
        group={group}
        isOpen={showEditExpenseModal}
        onClose={() => setShowEditExpenseModal(false)}
      />

      <DeleteExpenseModal
        expense={expense}
        isOpen={showDeleteExpenseModal}
        onClose={() => setShowDeleteExpenseModal(false)}
      />
    </>
  );
};

export default Expense;
